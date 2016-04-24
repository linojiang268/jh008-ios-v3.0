//
//  GNChooseImageService.m
//  GatherNew
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNChooseImageService.h"
#import <RACSignal.h>
#import <UIActionSheet+RACSignalSupport.h>

@interface GNChooseImageService ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, copy) void(^finishedBlock)(UIImage *image);

@end

@implementation GNChooseImageService

+ (GNChooseImageService *)service {
    static dispatch_once_t onceToken;
    static GNChooseImageService *service;
    dispatch_once(&onceToken, ^{
        service = [[GNChooseImageService alloc] init];
    });
    return service;
}

+ (void)chooseImageWithController:(UIViewController *)controller finishedBlock:(void(^)(UIImage *image))block {
    [[self service] setController:controller];
    [[self service] setFinishedBlock:block];
    [[self service] showChooseView];
}

- (void)showChooseView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    
    [actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
        switch ([x intValue]) {
            case 0:
                [self presentControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                [self presentControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            default:
                break;
        }
    }];
    [actionSheet showInView:self.controller.view];
}

- (void)presentControllerWithSourceType:(UIImagePickerControllerSourceType)type {
    
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        [SVProgressHUD showErrorWithStatus:@"当前设备不支持拍照功能"];
    }else {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = YES;
        controller.sourceType = type;
        
        [self.controller presentViewController:controller animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info count] > 0) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (image) {
            self.finishedBlock(image);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
