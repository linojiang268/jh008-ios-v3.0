//
//  GNMeVC.m
//  GatherNew
//
//  Created by Kaka on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeVC.h"
#import "GNVisitingCardVC.h"
#import "GNSwitchCityVC.h"
#import "GNLocationService.h"
#import "GNMeHeaderCell.h"
#import "GNMeClubAndActivityCell.h"
#import "GNMeClubVC.h"
#import "GNMeActivityVC.h"
#import "GNMyPerfectInfoVC.h"
#import "GNMyPerfectInfoVM.h"
#import "GNPerfectInfoModel.h"
#import "GNMeVM.h"

/// 扫描
#import "BarcodeViewController.h"
#import "GNSignInVC.h"
#import "GNWebViewVC.h"
#import "GNClubHomePageVC.h"
#import "GNActivityDetailsVC.h"
#import "GNActivityManualVC.h"
#import "GNScanStatusVC.h"

#import <MJRefresh.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kUITableViewCellHeader @"tableViewCellHeader"
#define kUITableViewCellClubAndActivity @"tableViewCellClubAndActivity"

@interface GNMeVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *activityResponse;
@property (nonatomic, strong) NSDictionary *clubResponse;
@property (nonatomic, strong) GNPerfectInfoModel *perfectInfo;;
@property (nonatomic, strong) GNMyPerfectInfoVM *viewModelPerfectInfo;
@property (nonatomic, strong) GNMeVM *viewModel;

@end

@implementation GNMeVC

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"我";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbar_me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_me_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypeNone;
}


- (void)setupUI {
    [super setupUI];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[GNMeHeaderCell nib] forCellReuseIdentifier:kUITableViewCellHeader];
    [self.tableView registerNib:[GNMeClubAndActivityCell nib] forCellReuseIdentifier:kUITableViewCellClubAndActivity];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[GNApp userCity].name ? : @"" style:UIBarButtonItemStylePlain target:nil action:Nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"me_Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];

    __weakify;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        __strongify;
        
        [self.viewModelPerfectInfo.getPerfectInfoResponse start];
        [self.viewModel.getActivityDataResponse start];
        [self.viewModel.getClubDataResponse start];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
        });
    }];
    self.tableView.header.stateHidden = YES;
}

- (void)scan {
    BarcodeViewController *controller = [BarcodeViewController controllerWithResultHandler:^(GNScanResultPushType type, NSString *resultString, NSUInteger resultId, GNActivitySignInModel *model) {
        
        switch (type) {
            case GNScanResultPushTypeActivityDetail:
            {
                GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[NSString stringWithFormat:@"%lu",(unsigned long)resultId]];
                [self.navigationController pushVC:controller animated:YES];
            }
                break;
            case GNScanResultPushTypeActivityManual:
            {
                [self.navigationController pushVC:[[GNActivityManualVC alloc] initWithActivityId:resultId showActivityIntro:YES] animated:YES];
            }
                break;
            case GNScanResultPushTypeClub:
            {
                GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
                controller.viewModel = [[GNClubHomePageVM alloc] initWithClubId:resultId visibility:GNClubMemberVisibilityAll];
                [self.navigationController pushVC:controller animated:YES];
            }
                break;
            case GNScanResultPushTypeNews:
            {
                GNWebViewVC *controller = [[GNWebViewVC alloc] initWithTitle:@"" url:[NSURL URLWithString:resultString]];
                [self.navigationController pushVC:controller animated:YES];
            }
                break;
            case GNScanResultPushTypeNoApply:
            case GNScanResultPushTypeUnknown:
            {
                [self.navigationController pushVC:[GNScanStatusVC statusWithType:(GNScanResultType)type backBlock:nil] animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)binding {
    
    [self bindingMeData];
    
    __weakify;
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        
        GNSwitchCityVC *controller = [[GNSwitchCityVC alloc] initWithBackEnabled:YES block:^(GNCityModel *model) {
            self.navigationItem.leftBarButtonItem.title = model.name;
        }];
        [self.navigationController pushVC:controller animated:YES];
        
        return [RACSignal empty];
    }];
    
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        
        NSString *mediaType = AVMediaTypeVideo;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中,允许集合访问你的相机。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
        }else if(authStatus == ALAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if (granted) {
                    [self scan];
                }
            }];
        }else {
            [self scan];
        }
        
        return [RACSignal empty];
    }];
    
    if (![GNApp userCity]) {
        [SVProgressHUD showWithStatus:@"正在获取当前城市" maskType:SVProgressHUDMaskTypeBlack];
    }
    [GNLocationService requestPlacemarkWithBlock:^(CLPlacemark *placemark, GNCityModel *model, INTULocationStatus status) {
        __strongify;
        
        [SVProgressHUD dismiss];
        if (status == INTULocationStatusSuccess) {
            self.navigationItem.leftBarButtonItem.title = model.name;
            [GNApp switchUserCity:model];
            [GNApp setUserLocation:placemark.location];
        }else if (status == (INTULocationStatus)kLSwitchNewCityCode) {
            NSString *msg = [NSString stringWithFormat:@"你当前的位置为%@,是否切换？",model.name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
            [alert show];
            [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x intValue] == 1) {
                    __strongify;
                    self.navigationItem.leftBarButtonItem.title = model.name;
                    [GNApp switchUserCity:model];
                    [GNApp setUserLocation:placemark.location];
                }
            }];
        }else if (![GNApp userCity]) {
            [SVProgressHUD showErrorWithStatus:@"定位失败，请选择一个城市"];
            GNSwitchCityVC *controller = [[GNSwitchCityVC alloc] initWithBackEnabled:NO block:^(GNCityModel *model) {
                __strongify;
                self.navigationItem.leftBarButtonItem.title = model.name;
            }];
            [self.navigationController pushVC:controller animated:YES];
        }
    }];
}

-(void)bindingMeData{
    self.viewModelPerfectInfo = [[GNMyPerfectInfoVM alloc]init];
    self.viewModel = [[GNMeVM alloc]init];
    
    __weakify;
    [self.viewModelPerfectInfo.getPerfectInfoResponse start:YES success:^(id response, id model) {
        __strongify;
        self.perfectInfo = model;
        [GNApp setUserMobile:self.perfectInfo.mobile];
        [self.tableView reloadData];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取资料失败!"];
    }];
    
    [self.viewModel.getClubDataResponse start:YES success:^(id response, id model) {
        __strongify;
        self.clubResponse = response;
        
        [self.tableView reloadData];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取社团数据失败!"];
    }];
    
    
    [self.viewModel.getActivityDataResponse start:YES success:^(id response, id model) {
        __strongify;
        self.activityResponse = response;
        
        [self.tableView reloadData];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取活动数据失败!"];
    }];
}

#pragma mark -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GNMeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellHeader forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.imageHeader setUserAvatarImageWithURL:_perfectInfo.avatar_url];
        cell.lbName.text = _perfectInfo.nick_name;
        
        return cell;
    }
    if (indexPath.section == 1) {
        GNMeClubAndActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellClubAndActivity forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbTitle.text = @"我的社团";
        
        if (_clubResponse==nil) {
            cell.lbMeClub.text = @"已加入：0，被邀请：0";
        }
        else
        {
            cell.lbMeClub.text = [NSString stringWithFormat:@"已加入：%@，被邀请：%@",self.clubResponse[@"enrolled_teams"],self.clubResponse[@"invited_teams"]];

        }
        return cell;
    }
    if (indexPath.section == 2) {
        GNMeClubAndActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellClubAndActivity forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbTitle.text = @"活动日历";

        if (_activityResponse==nil) {
            cell.lbMeClub.text = @"即将开始：0，已参加：0";
        }
        else
        {
            cell.lbMeClub.text = [NSString stringWithFormat:@"即将开始：%@，已参加：%@",self.activityResponse[@"count"][@"notBeginning"],self.activityResponse[@"count"][@"all"]];
        }
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 106;
    }else{
        return 64;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GNMyPerfectInfoVC *perfectInfo = [GNMyPerfectInfoVC loadFromStoryboard];
        [perfectInfo updateCompleteWithBlock:^{
            [self.viewModelPerfectInfo.getPerfectInfoResponse start];
        }];
        [self.navigationController pushVC:perfectInfo animated:YES];
    }
    if (indexPath.section==1) {
        GNMeClubVC *clubVC = [GNMeClubVC loadFromStoryboard];
        [self.navigationController pushVC:clubVC animated:YES];
    }else if (indexPath.section == 2){
        
        GNMeActivityVC *activityVC = [GNMeActivityVC loadFromStoryboard];
        [self.navigationController pushVC:activityVC animated:YES];
    }
}

@end
