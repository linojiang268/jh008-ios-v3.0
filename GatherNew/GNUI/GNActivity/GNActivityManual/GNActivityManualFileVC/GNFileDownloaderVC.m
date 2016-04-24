//
//  GNFileDownloaderVC.m
//  GatherNew
//
//  Created by apple on 15/8/30.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNFileDownloaderVC.h"
#import "TCBlobDownload.h"

@interface GNFileDownloaderVC ()<UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, strong) GNActivityManualFileItemModel *fileModel;

@property (nonatomic, strong) TCBlobDownloader *download;

@property (nonatomic, assign) BOOL isExists;
@property (nonatomic, strong) NSString *localPath;

@end

@implementation GNFileDownloaderVC

- (instancetype)initWithFileModel:(GNActivityManualFileItemModel *)fileModel {
    self = [super init];
    if (self) {
        self.fileModel =fileModel;
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"文件"];
    
    if ([self.fileModel.extension isEqualToString:@"doc"] || [self.fileModel.extension isEqualToString:@"docx"]) {
        self.imageView.image = [UIImage imageNamed:@"file_type_word"];
    }else if ([self.fileModel.extension isEqualToString:@"xls"] || [self.fileModel.extension isEqualToString:@"xlsx"]) {
        self.imageView.image = [UIImage imageNamed:@"file_type_excel"];
    }else if ([self.fileModel.extension isEqualToString:@"pdf"]) {
        self.imageView.image = [UIImage imageNamed:@"file_type_pdf"];
    }else if ([self.fileModel.extension isEqualToString:@"ppt"] || [self.fileModel.extension isEqualToString:@"pptx"]) {
        self.imageView.image = [UIImage imageNamed:@"file_type_ppt"];
    }else if ([self.fileModel.extension isEqualToString:@"jpg"]  ||
              [self.fileModel.extension isEqualToString:@"jpeg"] ||
              [self.fileModel.extension isEqualToString:@"png"]  ||
              [self.fileModel.extension isEqualToString:@"bmp"]  ||
              [self.fileModel.extension isEqualToString:@"gif"])
    {
        self.imageView.image = [UIImage imageNamed:@"file_type_jpg"];
    }else {
        self.imageView.image = [UIImage imageNamed:@"file_type_other"];
    }

    
    self.nameLabel.text = self.fileModel.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"%dkb",self.fileModel.size / 1024];
    
    self.progressView.progress = 0;
    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *documentURL =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.localPath = [documentURL stringByAppendingPathComponent:[NSString stringWithFormat:@"/download/%@",[[self.fileModel.url componentsSeparatedByString:@"/"] lastObject]]];
    
    if ([fileManager fileExistsAtPath:self.localPath]) {
        self.isExists = YES;
        
        [self hide];
    }
}

- (void)hide {
    self.progressView.hidden = YES;
    self.sizeLabel.hidden = YES;
    self.actionButton.hidden = YES;
    
    self.imageView.userInteractionEnabled = YES;
    
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFile)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.download cancelDownloadAndRemoveFile:YES];
}

- (IBAction)download:(id)sender {
    
    if (self.isExists) {
        [self openFile];
    }else if(self.actionButton.selected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定停止下载吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
            if ([x intValue]) {
                [self.download cancelDownloadAndRemoveFile:YES];
                [self.actionButton setSelected:NO];
            }
        }];
        [alert show];
    }else{
        TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
        
        NSString *documentURL =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *localPath = [documentURL stringByAppendingPathComponent:@"download"];
        
        __weakify;
       self.download = [sharedManager startDownloadWithURL:[NSURL URLWithString:self.fileModel.url]
                                 customPath:localPath
                              firstResponse:^(NSURLResponse *response) {
                                  __strongify;
                                  [self.actionButton setSelected:YES];
                              } progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                  __strongify;
                                  
                                  [self.progressView setProgress:progress animated:NO];
                              } error:^(NSError *error) {
                                  [SVProgressHUD showErrorWithStatus:@"下载失败"];
                                  __strongify;
                                  [self.navigationController popViewControllerAnimated:YES];
                              } complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                  if (downloadFinished) {
                                      __strongify;
                                      self.isExists = YES;
                                      [self hide];
                                      NSError *e = nil;
                                      NSFileManager *fileManager = [[NSFileManager alloc] init];
                                      if (![fileManager fileExistsAtPath:self.localPath]) {
                                          [fileManager moveItemAtPath:pathToFile toPath:self.localPath error:&e];
                                      }
                                      if (e) {
                                          [SVProgressHUD showErrorWithStatus:@"下载失败"];
                                      }else {
                                          [self openFile];
                                      }
                                  }
                              }];

    }
}

- (void)openFile {
    NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.localPath]];
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentController.delegate = self;
    [self.documentController presentOptionsMenuFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
}

#pragma mark -

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

@end
