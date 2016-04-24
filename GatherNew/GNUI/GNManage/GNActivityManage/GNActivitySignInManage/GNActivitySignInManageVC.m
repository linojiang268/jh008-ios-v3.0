//
//  GNActivitySignInManageVC.m
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySignInManageVC.h"
#import "HMSegmentedControl.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "GNActivitySignInManageCell.h"
#import "GNActivitySignInManageVM.h"
#import "GNActivityCheckInListModel.h"
#import "GNCustomAlertView.h"
#import "GNActivitySignInManageSearchVC.h"


@interface GNActivitySignInManageVC ()<UITableViewDataSource,UITableViewDelegate,XBTableViewRefreshDelegate, GNCustomAlertViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *notCheckedTableView;
@property (nonatomic, strong) UITableView *checkedTableView;
@property (nonatomic, strong) HMSegmentedControl *segment;

@property (nonatomic, strong) GNActivitySignInManageVM *viewModel;

@property (nonatomic, strong) GNCustomAlertView* QRCodeAlertView;

@property (nonatomic, strong) UIImageView* qrCodeImageView;
@property (nonatomic, assign) BOOL qrCodeLoaded;

@end

@implementation GNActivitySignInManageVC

+ (instancetype)initWithActivityId:(NSUInteger)activityId subStatus:(NSUInteger)subStatus {
    GNActivitySignInManageVC * vc = [[GNActivitySignInManageVC alloc]init];
    vc.activityId = activityId;
    vc.subStatus = subStatus;
    return vc;
}

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"签到管理"];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.notCheckedTableView];
    [self.scrollView addSubview:self.signedInTableView];
    
    UIBarButtonItem* qrCode = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"manage_show_qrcode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showQRCode)];
    UIBarButtonItem* search = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchMembers)];
    self.navigationItem.rightBarButtonItems = @[search, qrCode];

    self.QRCodeAlertView = [[GNCustomAlertView alloc]init];
    
    UIView* qrCodeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 240)];
    [self.QRCodeAlertView setContainerView:qrCodeView];
    
    self.qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 220, 220)];
    self.qrCodeImageView.center = qrCodeView.center;
    self.qrCodeImageView.backgroundColor = kUIColorWithHexUint(GNUIColorDarkgray);
    [qrCodeView addSubview:self.qrCodeImageView];
    
    self.QRCodeAlertView.delegate = self;
    self.QRCodeAlertView.dismissTouchOutside = NO;
}

-(void)refreshDataAfterSearch {
    [self.notCheckedTableView refresh];
    [self.checkedTableView refresh];
}

- (void)searchMembers {
    GNActivitySignInManageSearchVC* controller = [GNActivitySignInManageSearchVC initWithActivityId:self.activityId subStaus:self.subStatus manageVC:self];
    [self.navigationController pushVC:controller animated:YES];
}


- (void)showQRCode {
    [self getQRCodes];
    [self.QRCodeAlertView show];
}

- (void)GNCustomAlertView:(GNCustomAlertView *)customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.QRCodeAlertView dismiss];
}

- (void)binding {
    self.viewModel = [GNActivitySignInManageVM initWithActivity:self.activityId];
    
    RAC(self.viewModel,notCheckInListPage) = RACObserve(self.notCheckedTableView, page);
    RAC(self.viewModel,checkInListPage) = RACObserve(self.checkedTableView, page);
    
    [self.viewModel.getCheckInListResponse start:NO success:^(id response, GNActivityCheckInListModel* model) {
        [self.checkedTableView reloadData];
        [self.checkedTableView setTotalPage:model.pages];
        [self.checkedTableView endAllRefresh];
        if(self.viewModel.checkInTotal == 0){
            ((UILabel *)[self.checkedTableView.tableHeaderView viewWithTag:1]).text = @"";
            __weakify;
            [self.checkedTableView showHintViewWithType:XBHintViewTypeNoData message:@"已签到列表为空，点击刷新！"  tapHandler:^(UIView *tapView) {
                __strongify;
                [self.checkedTableView hideHintView];
                [self.checkedTableView refresh];
            }];
        }
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        [self.checkedTableView endAllRefresh];
    } failure:^(id req, NSError *error) {
        [self.checkedTableView endAllRefresh];
        if([self.viewModel.checkInList count] == 0){
            ((UILabel *)[self.checkedTableView.tableHeaderView viewWithTag:1]).text = @"";
            __weakify;
            [self.checkedTableView showHintViewWithType:XBHintViewTypeNetworkError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.checkedTableView hideHintView];
                [self.checkedTableView refresh];
            }];
        }
    }];
    
    
    [self.viewModel.getNotCheckInListResponse start:NO success:^(id response, GNActivityCheckInListModel* model) {
        [self.notCheckedTableView reloadData];
        [self.notCheckedTableView setTotalPage:model.pages];
        [self.notCheckedTableView endAllRefresh];
        
        if(self.viewModel.notCheckInTotal == 0){
            ((UILabel *)[self.notCheckedTableView.tableHeaderView viewWithTag:1]).text = @"";
            __weakify;
            [self.notCheckedTableView showHintViewWithType:XBHintViewTypeNoData message:@"未签到列表为空，点击刷新！" tapHandler:^(UIView *tapView) {
                __strongify;
                [self.notCheckedTableView hideHintView];
                [self.notCheckedTableView refresh];
            }];
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        [self.notCheckedTableView endAllRefresh];

    } failure:^(id req, NSError *error) {
        [self.notCheckedTableView endAllRefresh];
        if([self.viewModel.notCheckInList count] == 0){
            ((UILabel *)[self.notCheckedTableView.tableHeaderView viewWithTag:1]).text = @"";
            __weakify;
            [self.notCheckedTableView showHintViewWithType:XBHintViewTypeNetworkError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.notCheckedTableView hideHintView];
                [self.notCheckedTableView refresh];
            }];
        }
    }];
    
    [self.notCheckedTableView refresh];
    [self.checkedTableView refresh];
    
    [self getQRCodes];
}



-(void)getQRCodes {
    if(!self.qrCodeLoaded){
        __weakify;
        [self.viewModel getQRCodeList:self.activityId success:^(id response, id model) {
            __strongify;
            NSArray* qrcodes = [response objectForKey:@"qrcodes"];
            if(qrcodes && [qrcodes count] > 0){
                NSURL* url = [NSURL URLWithString:[[qrcodes objectAtIndex:0]objectForKey:@"url"]];
                [self.qrCodeImageView setImageWithURL:url];
                self.qrCodeLoaded = YES;
            }
        } error:^(id response, NSInteger code) {
            self.qrCodeLoaded = NO;
        } failure:^(id req, NSError *error) {
            self.qrCodeLoaded = NO;
        }];
    }
   
}


#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = (tableView.tag == 1) ? self.viewModel.notCheckInList.count : self.viewModel.checkInList.count;
    
    NSInteger total = (tableView.tag == 1) ? self.viewModel.notCheckInTotal : self.viewModel.checkInTotal;
    ((UILabel*)[tableView.tableHeaderView viewWithTag:1]).text = [NSString stringWithFormat:@"共计：%ld人", (long)total];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivitySignInManageCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GNActivityCheckInModel* who = nil;
    if (tableView.tag == 1) {
        who = [self.viewModel.notCheckInList objectAtIndex:indexPath.row];
    }else {
        who = [self.viewModel.checkInList objectAtIndex:indexPath.row];
    }
    
    __weakify;
    [cell bindingModel:who subStatus:self.subStatus OnCheckInClick:^(GNActivityCheckInModel *who) {
        __strongify;
        NSString* message;
        
        if(who.status == 0){
            message = [NSString stringWithFormat:@"确定为 %@ 签到", who.name];
        }else{
            message = [NSString stringWithFormat:@"确定为 %@ 取消签到", who.name];
        }
        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        objc_setAssociatedObject(alertView, @"GNActivityCheckInModel", who, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        alertView.tag = 0x100;
        [alertView show];
    }];
    return cell;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1 && alertView.tag == 0x100){
        GNActivityCheckInModel* who = objc_getAssociatedObject(alertView, @"GNActivityCheckInModel");
        [self setCheckIn:who];
    }
}


#pragma mark -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 0) {
        if (scrollView.contentOffset.x < kUIScreenWidth) {
            [self changeIndex:0];
        }else {
            [self changeIndex:1];
        }
    }
}

#pragma mark - UI

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat topHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        topHeight += CGRectGetHeight(self.navigationController.navigationBar.frame);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32, kUIScreenWidth, kUIScreenHeight-topHeight-32)];// 32 切换卡
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(kUIScreenWidth * 2, kUIScreenHeight - topHeight-32);// 32 切换卡
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)createTotalView{
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 35)];
    containView.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kUIScreenWidth - 20, 14)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 1;
    label.text = @"共计：--人";
    [containView addSubview:label];
    return containView;
}

- (UITableView *)notCheckedTableView {
    if (!_notCheckedTableView) {
        CGRect r = CGRectMake(0, 0, kUIScreenWidth, CGRectGetHeight(self.scrollView.frame));
        _notCheckedTableView = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
        _notCheckedTableView.backgroundColor = [UIColor clearColor];
        _notCheckedTableView.tag = 1;
        _notCheckedTableView.dataSource = self;
        _notCheckedTableView.delegate = self;
        _notCheckedTableView.refreshDelegate = self;
        _notCheckedTableView.rowHeight = 60;
        _notCheckedTableView.tableHeaderView = [self createTotalView];
        
        [_notCheckedTableView registerNib:[GNActivitySignInManageCell nib] forCellReuseIdentifier:kUICellIdentifier];
        [_notCheckedTableView addRefreshAndLoadMore];
    }
    return _notCheckedTableView;
}

- (UITableView *)signedInTableView {
    if (!_checkedTableView) {
        CGRect r = CGRectMake(kUIScreenWidth, 0, kUIScreenWidth, CGRectGetHeight(self.scrollView.frame));
        _checkedTableView = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
        _checkedTableView.backgroundColor = [UIColor clearColor];
        _checkedTableView.tag = 2;
        _checkedTableView.dataSource = self;
        _checkedTableView.delegate = self;
        _checkedTableView.refreshDelegate = self;
        _checkedTableView.rowHeight = 60;
        _checkedTableView.tableHeaderView = [self createTotalView];
        
        [_checkedTableView registerNib:[GNActivitySignInManageCell nib] forCellReuseIdentifier:kUICellIdentifier];
        [_checkedTableView addRefreshAndLoadMore];
    }
    return _checkedTableView;
}

- (HMSegmentedControl *)segment {
    if (!_segment) {
        _segment = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"未签到",@"已签到"]];
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



-(void)setCheckIn:(GNActivityCheckInModel *)who{
    __weakify;
    [SVProgressHUD showWithStatus:@"正在更改状态，请稍后" maskType:SVProgressHUDMaskTypeBlack];
    [self.viewModel manualCheckIn:self.activityId setp:1 userId:who.user_id approve:!who.status success:^(id response, id model) {
        __strongify;
        [SVProgressHUD dismiss];
        if(who.status == 0){
            who.status = 1;
        }else{
            who.status = 0;
        }
        
        [self.checkedTableView reloadData];
        [self.notCheckedTableView reloadData];
        
        NSString* message = [NSString stringWithFormat:@"%@ %@", who.name, (who.status ? @"已签到" : @"已取消签到")];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD dismiss];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:(who.status ? @"取消签到失败" : @"签到失败") message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
