//
//  GNActivityAlbumContainerVC.m
//  GatherNew
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityAlbumContainerVC.h"
#import "GNActivityAlbumVC.h"
#import "GNActivityAlbumUploadVC.h"

@interface GNActivityAlbumContainerVC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic, strong) GNActivityAlbumVC *sponsorView;
@property (nonatomic, strong) GNActivityAlbumVC *userView;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIPageViewController *pageController;

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, assign) BOOL showUpload;
@property (nonatomic, strong) UIBarButtonItem *addButton;

@end

@implementation GNActivityAlbumContainerVC

- (instancetype)initWithActivityId:(NSUInteger)activityId canUpload:(BOOL)canUpload {
    self = [super init];
    if (self) {
        self.sponsorView = [[GNActivityAlbumVC alloc] initWithType:GNActivityAlbumTypeSponsor activityId:activityId];
        self.userView = [[GNActivityAlbumVC alloc] initWithType:GNActivityAlbumTypeUser activityId:activityId];
        
        self.activityId = activityId;
        self.showUpload = canUpload;
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    
    [self showAddButton:self.showUpload];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"活动相册",@"用户分享"]];
    [self.segmentedControl setTintColor:kUIColorWithHexUint(GNUIColorBlue)];
    [self.segmentedControl.layer setBorderColor:[kUIColorWithHexUint(0xff414550) CGColor]];
    [self.segmentedControl.layer setBorderWidth:2];
    [self.segmentedControl setBackgroundColor:kUIColorWithHexUint(0xff414550)];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorWhite)} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: kUIColorWithHexUint(0xffcccccc)} forState:UIControlStateNormal];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl addTarget:self action:@selector(switchType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:@{UIPageViewControllerOptionSpineLocationKey: @(UIPageViewControllerSpineLocationMax)}];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    self.pageController.view.frame = self.view.bounds;
    
    [self switchType:self.segmentedControl];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
}

- (void)showAddButton:(BOOL)show {
    if (self.showUpload) {
        if (show && !self.navigationItem.rightBarButtonItem) {
            
            if (!self.addButton) {
                self.addButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"album_add_barButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:Nil];
                __weakify;
                self.addButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    __strongify;
                    GNActivityAlbumUploadVC *controller = [[GNActivityAlbumUploadVC alloc] initWithActivityId:self.activityId];
                    [controller uploadComplete:^{
                        [self.userView prepareRefresh];
                    }];
                    [self.navigationController pushVC:controller animated:YES];
                    
                    return [RACSignal empty];
                }];
            }
            self.navigationItem.rightBarButtonItem = self.addButton;
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)switchType:(UISegmentedControl *)segment {
    UIViewController *willShowView = nil;
    UIPageViewControllerNavigationDirection direction;
    if (segment.selectedSegmentIndex == 0) {
        willShowView = self.sponsorView;
        direction = UIPageViewControllerNavigationDirectionReverse;
        [self showAddButton:NO];
    }else {
        willShowView = self.userView;
        direction = UIPageViewControllerNavigationDirectionForward;
        [self showAddButton:YES];
    }
    [self.pageController setViewControllers:@[willShowView] direction:direction animated:YES completion:NULL];
}

#pragma mark -

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isEqual:self.userView]) {
        return self.sponsorView;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isEqual:self.sponsorView]) {
        return self.userView;
    }
    return nil;
}

#pragma mark -

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        if ([[previousViewControllers firstObject] isEqual:self.sponsorView]) {
            [self.segmentedControl setSelectedSegmentIndex:1];
            [self showAddButton:YES];
        }else {
            [self.segmentedControl setSelectedSegmentIndex:0];
            [self showAddButton:NO];
        }
    }
}

@end
