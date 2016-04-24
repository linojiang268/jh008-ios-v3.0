//
//  AppDelegate.h
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIAlertView *lostConnectionAlert;

- (void)showMainUI;
- (void)showLoginUI;

- (void)showLostConnectionAlertView;

@end

