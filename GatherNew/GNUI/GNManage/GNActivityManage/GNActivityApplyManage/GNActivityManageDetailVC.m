//
//  GNActivityManageDetailVC.m
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <Masonry.h>
#import "GNActivityManageDetailVC.h"
#import "HMSegmentedControl.h"
#import "GNActivityApplySuccessListVC.h"
#import "GNActivityApplyVerifyListVC.h"
#import "GNActivityApplyPayListVC.h"
#import "GNActivityManageAddNewVC.h"

@interface GNActivityManageDetailVC () <UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *verifyListView;
@property (nonatomic, strong) UIView *payListView;
@property (nonatomic, strong) UIView *successListView;
@property (nonatomic, strong) GNActivityApplySuccessListVC *successListVC;
@property (nonatomic, strong) HMSegmentedControl *segment;

@property (nonatomic, strong) NSMutableArray* groups;
@end

@implementation GNActivityManageDetailVC

+ (instancetype)initWithActivity:(NSUInteger)activityId needAuth:(BOOL)needAuth needPay:(BOOL)needPay enrollAttrs:(NSArray *)enrollAttrs subStatus:(NSInteger)subStatus {
    GNActivityManageDetailVC * vc = [[GNActivityManageDetailVC alloc]init];
    vc.activityId = activityId;
    vc.needAuth = needAuth;
    vc.needPay = needPay;
    vc.enrollAttrs = enrollAttrs;
    vc.subStatus = subStatus;
    return vc;
}

-(void)initGroups {
    self.groups = [NSMutableArray array];
    if(self.needAuth){
        [self.groups addObject:@"待审核"];
    }
    if(self.needPay){
        [self.groups addObject:@"待交费"];
    }
    [self.groups addObject:@"已成功"];
}


- (void)setupUI {
    [super setupUI];
    [self setTitle:@"报名管理"];
    [self initGroups];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.scrollView];
    
    if(self.subStatus < 5) {
        UIBarButtonItem* addNew = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"album_add_barButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addNewMember)];
        self.navigationItem.rightBarButtonItem = addNew;
    }
    
    int index= 0;
    if(self.needAuth){
        GNActivityApplyVerifyListVC* verifyListVC = [GNActivityApplyVerifyListVC initWithActivity:self.activityId controller:self];
        self.verifyListView = verifyListVC.view;
        [self.scrollView addSubview:self.verifyListView];
        [self.verifyListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@(self.scrollView.bounds.size.height));
            make.left.equalTo(@(kUIScreenWidth*index));
            make.width.equalTo(@(kUIScreenWidth));
        }];
        index++;
    }
    
    if(self.needPay){
        GNActivityApplyPayListVC* payListVC = [GNActivityApplyPayListVC initWithActivity:self.activityId controller:self];
        self.payListView = payListVC.view;
        [self.scrollView addSubview:self.payListView];
        [self.payListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@(self.scrollView.bounds.size.height));
            make.left.equalTo(@(kUIScreenWidth*index));
            make.width.equalTo(@(kUIScreenWidth));
        }];
        index++;
    }
    
    self.successListVC = [GNActivityApplySuccessListVC initWithActivity:self.activityId];
    self.successListView = self.successListVC.view;
    [self.scrollView addSubview:self.successListView];
    [self.successListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@(self.scrollView.bounds.size.height));
        make.left.equalTo(@(kUIScreenWidth*index));
        make.width.equalTo(@(kUIScreenWidth));
    }];
    
}

-(void)addNewMember {
    GNActivityManageAddNewVC* controller = [GNActivityManageAddNewVC initWithActivityId:self.activityId requirements:self.enrollAttrs sucVC:self.successListVC];
    [self.navigationController pushVC:controller animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 0x1000) {
        CGFloat xoffset = scrollView.contentOffset.x;
        if (xoffset < kUIScreenWidth) {
            [self changeIndex:0];
        }else if (xoffset < kUIScreenWidth*2) {
            [self changeIndex:1];
        }else{
            [self changeIndex:2];
        }
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat topHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        topHeight += CGRectGetHeight(self.navigationController.navigationBar.frame);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32, kUIScreenWidth, kUIScreenHeight-topHeight - 32)];
        _scrollView.backgroundColor = [UIColor clearColor];
        int pages = 1;
        if(self.needAuth) pages++;
        if(self.needPay) pages++;
        _scrollView.contentSize = CGSizeMake(kUIScreenWidth * pages, kUIScreenHeight - topHeight - 32);
        _scrollView.pagingEnabled = YES;
        _scrollView.tag = 0x1000;
        _scrollView.delegate = self;
    }
    return _scrollView;
}




- (HMSegmentedControl *)segment {
    if (!_segment) {
        _segment = [[HMSegmentedControl alloc] initWithSectionTitles:self.groups];
        _segment.frame = CGRectMake(0, 0, kUIScreenWidth, 32);
        _segment.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorGrayBlack)};
        _segment.selectedTitleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorBlue)};
        _segment.selectionIndicatorHeight = 2;
        _segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        [_segment addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}



- (void)segmentControlValueChanged:(HMSegmentedControl *)segment {
    [self changeIndex:segment.selectedSegmentIndex];
}

- (void)changeIndex:(NSUInteger)index {
    [self.segment setSelectedSegmentIndex:index animated:YES];
    [self.scrollView setContentOffset:CGPointMake(index * kUIScreenWidth, 0) animated:YES];
}



@end
