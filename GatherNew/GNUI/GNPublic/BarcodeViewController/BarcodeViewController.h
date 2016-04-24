//
//  BarcodeViewController.h
//  ZXingDemo
//
//  Created by CP_Kiwi on 14-5-5.
//  Copyright (c) 2014年 cpsoft. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GNActivitySignInVC.h"

typedef NS_ENUM(NSUInteger, GNScanResultPushType) {
    GNScanResultPushTypeActivityDetail  = 1,
    GNScanResultPushTypeActivityManual  = 2,
    GNScanResultPushTypeClub            = 3,
    GNScanResultPushTypeNews            = 4,
    GNScanResultPushTypeNoApply         = 5,
    GNScanResultPushTypeUnknown         = 6
};

@interface BarcodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

+ (instancetype)controllerWithResultHandler:(void(^)(GNScanResultPushType type, NSString *resultString, NSUInteger resultId, GNActivitySignInModel *model))handler;

@end
