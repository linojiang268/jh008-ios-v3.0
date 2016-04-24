//
//  GNScanStatusVC.m
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNScanStatusVC.h"

@interface GNScanStatusVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, assign) GNScanResultType type;

@property (nonatomic, copy) void(^backBlock)(void);

@end

@implementation GNScanStatusVC

+ (NSString *)sbIdentifier {
    return @"scan_status";
}

+ (UIStoryboard *)storyboard {
    return [UIStoryboard storyboardWithName:@"GNPublicUI" bundle:nil];
}

+ (GNScanStatusVC *)statusWithType:(GNScanResultType)type backBlock:(void(^)(void))block {
    GNScanStatusVC *controller = [self loadFromStoryboard];
    if (self) {
        controller.type = type;
        controller.backBlock = block;
    }
    return controller;
}

- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (self.backBlock) {
        self.backBlock();
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupUI {
    [super setupUI];
    
    [self setTitle:@"扫描结果"];
    
    if (self.type == GNScanResultTypeNoApply) {
        self.titleLabel.text = @"您没有报名，无法签到";
        self.subTitleLabel.text = @"请联系主办方现场工作人员";
    }
}

@end
