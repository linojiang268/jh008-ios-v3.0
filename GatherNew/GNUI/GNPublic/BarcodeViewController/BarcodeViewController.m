//
//  BarcodeViewController.m
//  ZXingDemo
//
//  Created by CP_Kiwi on 14-5-5.
//  Copyright (c) 2014年 cpsoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BarcodeViewController.h"
#import "NSString+GNExtension.h"
#import "GNScanStatusVC.h"

@interface BarCodeScanView : UIView {
    UIImageView * lightBar;
}
@property (nonatomic, retain) NSTimer * repeatTimer;

- (void)startAnimations;
- (void)stopAnimations;

@end

@implementation BarCodeScanView
@synthesize repeatTimer;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        lightBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barCode_light"]];
        lightBar.alpha = 0;
        [self addSubview:lightBar];
        
        UIImageView * frameView = [[UIImageView alloc] initWithFrame:self.bounds];
        frameView.image = [UIImage imageNamed:@"barCode_frame"];
        [self addSubview:frameView];
    }
    return self;
}

- (void)startAnimations {
    [self animationRepeatHandler:nil];
}

- (void)stopAnimations {
    lightBar.alpha = 0;
    if ([repeatTimer isValid]) {
        [repeatTimer invalidate];
        self.repeatTimer = nil;
    }
}

- (void)animationRepeatHandler:(NSTimer*)sender {
    lightBar.alpha = 1;
    CGRect frame = lightBar.frame;
    frame.origin.y = -frame.size.height;
    lightBar.frame = frame;
    [UIView animateWithDuration:1.75
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        CGRect frame = lightBar.frame;
        frame.origin.y = self.frame.size.height;
        lightBar.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animationRepeatHandler:) userInfo:nil repeats:NO];
        }
    }];
}

@end

@interface BarcodeViewController () {
    IBOutlet BarCodeScanView * scanView;
    UIButton * btnLEDLightOn;
    UIButton * btnLEDLightOff;
    BOOL _lightingIsOpen;
}

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, copy) void(^completeHandler)(NSString *result);
@property (nonatomic, copy) void(^resultHandler)(GNScanResultPushType type, NSString *resultString, NSUInteger resultId, GNActivitySignInModel *model);

@property (nonatomic, strong) GNActivitySignInVC *signInController;

@end

@implementation BarcodeViewController

+ (instancetype)controllerWithResultHandler:(void(^)(GNScanResultPushType type, NSString *resultString, NSUInteger resultId, GNActivitySignInModel *model))handler {
    BarcodeViewController * con = [[BarcodeViewController alloc] init];
    con.resultHandler = handler;
    return con;
}

- (id)init {
    if (self = [super initWithNibName:@"BarcodeViewController" bundle:nil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"扫描二维码";
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIBarButtonItem *lightingControl = [[UIBarButtonItem alloc] initWithTitle:@"开灯" style:UIBarButtonItemStylePlain target:self action:@selector(lightingControl:)];
    self.navigationItem.rightBarButtonItem = lightingControl;
}

- (void)lightingControl:(UIBarButtonItem *)item {
    
    _lightingIsOpen = !_lightingIsOpen;
    [self setLEDLightON:_lightingIsOpen];
    [item setTitle:_lightingIsOpen ? @"关灯": @"开灯"];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [scanView startAnimations];
    [self setupCamera];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [scanView stopAnimations];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)btnCancelPressed:(id)sender {
    [self back];
}

#define btnMarginTop 40

- (void)setupCamera {
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (self.device == nil) return;
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [self.session startRunning];
}

/// 开灯 关灯
- (BOOL)setLEDLightON:(BOOL)bl {
    AVCaptureDevice * device = self.device;
    BOOL res = [device hasTorch];
    if (res) {
        [device lockForConfiguration:nil];
        [device setTorchMode:bl ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    return res;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [scanView stopAnimations];
    NSString * stringValue;
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    if ([stringValue rangeOfString:@"wap/checkin"].length > 0) {
        
        [self handleWithURL:stringValue];
        
    }else {
        __weakify;
        [self dismissViewControllerAnimated:YES completion:^{
            __strongify;
            if (stringValue) {
                
//                if ([stringValue rangeOfString:@"wap/activity"].length > 0) {
//                    
//                    NSRange range = [stringValue rangeOfString:@"activity_id="];
//                    NSUInteger activityId = [[stringValue substringFromIndex:range.location + range.length] integerValue];
//                    if (activityId > 0) {
//                        self.resultHandler(GNScanResultPushTypeActivityDetail,stringValue,activityId);
//                    }else {
//                        [SVProgressHUD showErrorWithStatus:@"无效的二维码"];
//                    }
//                }else
                    if ([stringValue rangeOfString:@"wap/team"].length > 0) {
                    
                        NSRange range = [stringValue rangeOfString:@"team_id="];
                        NSUInteger teamId = [[stringValue substringFromIndex:range.location + range.length] integerValue];
                        if (teamId > 0) {
                            self.resultHandler(GNScanResultPushTypeClub,stringValue,teamId,nil);
                        }else {
                            self.resultHandler(GNScanResultPushTypeUnknown,stringValue,0,nil);
                        }
                    }else {
                        self.resultHandler(GNScanResultPushTypeUnknown,stringValue,0,nil);
                    }
//                    else if ([stringValue rangeOfString:@"wap/news"].length > 0) {
//                    self.resultHandler(GNScanResultPushTypeNews,stringValue,0);
//                }
            } else {
                self.resultHandler(GNScanResultPushTypeUnknown,stringValue,0,nil);
            }
        }];
    }
}

- (void)handleWithURL:(NSString *)url {
    
    UIView *currentView = self.navigationController.view;
    UIView *containView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    __weakify;
    self.signInController = [[GNActivitySignInVC alloc] initWithSigninURL:url success:^(GNActivitySignInModel *model) {
        __strongify;
        [self dismissViewControllerAnimated:YES completion:^{
            __strongify;
            self.resultHandler(GNScanResultPushTypeActivityManual,url,model.activity_id,model);
        }];
    } noApplyCallback:^{
        __strongify;
        [containView removeFromSuperview];
        [self.navigationController pushVC:[GNScanStatusVC statusWithType:GNScanResultTypeNoApply backBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }] animated:YES];
    } stepsErrorCallback:^{
        __strongify;
        [self dismissViewControllerAnimated:YES completion:nil];
    } backCallback:^{
        __strongify;
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];;
    self.signInController.view.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, kUIScreenHeight);
    self.signInController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    [self.signInController viewWillAppear:YES];
    [self.signInController viewDidAppear:YES];;
    [containView addSubview:self.signInController.view];
    [currentView addSubview:containView];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.signInController.view.frame = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight);
        containView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        
    }];
}

@end


