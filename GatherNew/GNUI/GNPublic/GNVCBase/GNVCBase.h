//
//  GNVCBase.h
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNBHBase.h"
#import "UIImageView+GNExtension.h"
#import "UIView+XBHintViewExtension.h"
#import "UIViewController+GNExtension.h"
#import "UINavigationController+GNExtension.h"

typedef NS_ENUM(NSUInteger, GNBackButtonType) {
    GNBackButtonTypeNone      = 1,
    GNBackButtonTypePop       = 2,
    GNBackButtonTypeDismiss   = 3,
};

@interface GNVCBase : UIViewController

@property (nonatomic, strong) GNBHBase *bindingHandler;

- (void)binding;

- (void)setupUI;
- (GNBackButtonType)backButtonType;
- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
