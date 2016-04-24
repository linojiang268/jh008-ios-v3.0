//
//  GNMessageVC.m
//  GatherNew
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMessageVC.h"
#import "HMSegmentedControl.h"
#import <Masonry.h>
#import "GNClubMessageVC.h"
#import "GNSystemMessageVC.h"

@interface GNMessageVC ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>



@property (nonatomic, strong) GNClubMessageVC *clubVC;
@property (nonatomic, strong) GNSystemMessageVC *systemVC;
@property (nonatomic, strong) HMSegmentedControl *segment;
@property (nonatomic, strong) UIPageViewController *pageController;

@end

@implementation GNMessageVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"消息";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbar_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_message_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypePop;
}

- (void)setupUI {
    [super setupUI];
    
    self.segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@" 社团      ",@" 系统      "]];
    self.segment.frame = CGRectMake(0, 0, kUIScreenWidth, 32);
    self.segment.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorBlack)};
    self.segment.selectionIndicatorHeight = 2;
    self.segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.segment addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];

    
    self.clubVC = [[GNClubMessageVC alloc] init];
    self.systemVC = [[GNSystemMessageVC alloc] init];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:@{UIPageViewControllerOptionSpineLocationKey: @(UIPageViewControllerSpineLocationMax)}];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController setViewControllers:@[self.clubVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(48, 0, 0, 0));
    }];
}

- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    
    if (segment.selectedSegmentIndex == 0) {
        [self.pageController setViewControllers:@[self.clubVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
    }else {
        [self.pageController setViewControllers:@[self.systemVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    }
}

#pragma mark -

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isEqual:self.systemVC]) {
        return self.clubVC;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isEqual:self.clubVC]) {
        return self.systemVC;
    }
    return nil;
}

#pragma mark -

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if ([[previousViewControllers firstObject] isEqual:self.clubVC]) {
            [self.segment setSelectedSegmentIndex:1 animated:YES];
        }else {
            [self.segment setSelectedSegmentIndex:0 animated:YES];
        }
    }
}
@end
