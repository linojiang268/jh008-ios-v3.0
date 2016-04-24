//
//  GNVCBase.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"

@implementation GNVCBase

- (void)dealloc {
    DDLogError(@"dealloc %@",NSStringFromClass([self class]));
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypePop;
}

- (void)setupUI {
    self.view.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    self.navigationController.navigationBar.translucent = NO;
    
    if ([self backButtonType] != GNBackButtonTypeNone) {
        UIImage *imageReturn =[UIImage imageNamed:@"nav_return"];
        imageReturn = [imageReturn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageReturn style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemPressed:)];
    }
}

- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender{
    if ([self backButtonType] == GNBackButtonTypePop) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self backButtonType] == GNBackButtonTypeDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)privateBinding {
    if (self.bindingHandler) {
        [self.bindingHandler binding];
    }else {
        [self binding];
    }
}

- (void)binding {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self privateBinding];
}

@end
