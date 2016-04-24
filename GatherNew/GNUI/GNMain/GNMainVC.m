//
//  GNMainVC.m
//  GatherNew
//
//  Created by apple on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMainVC.h"
#import "GNMainActivityCell.h"
#import "GNSectionHeadView.h"
#import "GNMeActivityVC.h"
#import "GNMainClubCell.h"
#import "GNMainClubItemCell.h"
#import "BannerView.h"
#import "GNMainVM.h"
#import "GNActivityListModel.h"
#import "GNActivityDetailsVC.h"
#import "GNMainNoneRecentActivityView.h"
#import "GNClubHomePageVC.h"
#import "GNLocationService.h"
#import "GNSwitchCityVC.h"
#import <MJRefresh.h>
#import "GNMyPerfectInfoVC.h"
#import "GNMyPerfectInfoVM.h"
#import "GNWebViewVC.h"
#import "GNOptionView.h"
#import "BarcodeViewController.h"
#import "GNActivityManualVC.h"
#import "GNScanStatusVC.h"
#import "GNMessageVC.h"
#import "GNMessageService.h"
#import "GNAboutUs.h"
#import "GNActivityManageVC.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface GNMainVC () <UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,XBTableViewRefreshDelegate>
@property(nonatomic, strong) GNOptionView* optionView;
@property(nonatomic, assign) NSUInteger sectionCount;

@property(nonatomic, strong) GNMainNoneRecentActivityView* noneRecentActivityView;
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, strong) UIImageView *userAvatar;

@property (nonatomic, strong) GNMyPerfectInfoVM *userViewModel;
@property(nonatomic, strong) GNMainVM *viewModel;

@property (nonatomic, strong) UIView *dotView;

@end

@implementation GNMainVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshMainPageUINotificationName object:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbar_main_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_main_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypeNone;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *options = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"options"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showOption)];
    if([GNApp isTeamOwner]){
        UIBarButtonItem *manage = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"enter_manage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(enterManage)];
        self.navigationItem.rightBarButtonItems = @[options,manage];
    }else{
        self.navigationItem.rightBarButtonItems = @[options];
    }
}


- (void)setupUI {
    [super setupUI];

    self.userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    kUIAvatar(self.userAvatar, [UIColor clearColor]);
    self.userAvatar.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.userAvatar];
    [self.userAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfo)]];

    self.cityButton = [[UIButton alloc] init];
    [self.cityButton addTarget:self action:@selector(switchCity) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:self.cityButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[GNMainClubCell nib] forCellReuseIdentifier:@"ClubCell"];
    [self.tableView registerNib:[GNMainActivityCell nib] forCellReuseIdentifier:kUICellIdentifier];
    
    
    __weakify;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        __strongify;
        [self.viewModel.refreshResponse start];
    }];
    self.tableView.header.updatedTimeHidden = YES;
    
    self.noneRecentActivityView = [[GNMainNoneRecentActivityView alloc]initWithTips:nil action:^(UIView *v) {
        __strongify;
        self.tabBarController.selectedIndex = 1;
        
    }];
    
    self.optionView = [[GNOptionView alloc]initWithOptions:@[@"扫一扫", @"消息", @"关于我们"] icons:@[@"op_scan", @"op_message", @"op_about_us"] position:CGPointMake(kUIScreenWidth, 0) arrowOffset:112.0f expectSize:CGSizeMake(135, 0)];
    [self.view addSubview:self.optionView];
    [self.optionView hide];
    
    [self.optionView setOnItemClick:^(NSInteger position, NSString* option){
        __strongify;
        switch (position) {
            case 0: {
                [self scan];
            }
                break;
            case 1: {
                [self.optionView showRedDotAtRow:1 show:NO];
                GNMessageVC * messageVC = [[GNMessageVC alloc]init];
                [self.navigationController pushVC:messageVC animated:YES];
            }
                break;
            case 2:{
                GNAboutUs* aboutUsVC = [GNAboutUs loadFromStoryboard];
                [self.navigationController pushVC:aboutUsVC animated:YES];
            }
                break;
        }
    }];
}

- (void)enterManage {
    GNActivityManageVC * activityManageVC = [[GNActivityManageVC alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushVC:activityManageVC animated:YES];
}

- (void)showOption {
    [self.optionView autoShowOrHide];
}

-(void)scan{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中,允许集合访问你的相机。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
    }else if(authStatus == ALAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted) {
                [self scanQRCode];
            }
        }];
    }else {
        [self scanQRCode];
    }
}

- (void)scanQRCode {
    
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
                GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[NSString stringWithFormat:@"%lu",(unsigned long)resultId]];
                [self.navigationController pushVC:controller animated:YES];
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


- (void)userInfo {
    GNMyPerfectInfoVC *perfectInfo = [GNMyPerfectInfoVC loadFromStoryboard];
    [perfectInfo updateCompleteWithBlock:^{
        [self.userViewModel.getPerfectInfoResponse start];
    }];
    [self.navigationController pushVC:perfectInfo animated:YES];
}

- (void)setCityWithCityName:(NSString *)cityName {
    if (cityName) {
        [self refresh];
        NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] init];
        [attributes appendAttributedString:[[NSAttributedString alloc] initWithString:cityName attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize18],NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorWhite)}]];
        [attributes appendAttributedString:[[NSAttributedString alloc] initWithString:@" ﹀" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize12],NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorWhite)}]];
        
        [self.cityButton setAttributedTitle:attributes forState:UIControlStateNormal];
        [self.cityButton sizeToFit];
    }
}

- (void)switchCity {
    GNSwitchCityVC *controller = [[GNSwitchCityVC alloc] initWithBackEnabled:YES block:^(GNCityModel *model) {
        [self setCityWithCityName:model.name];
    }];
    [self.navigationController pushVC:controller animated:YES];
}

- (void)refresh {
    [self.tableView.header beginRefreshing];
}

- (void)binding {
    
    /// 注册通知，加入社团，报名活动后需要刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kRefreshMainPageUINotificationName object:nil];
    
    self.viewModel = [[GNMainVM alloc]init];
    self.userViewModel = [[GNMyPerfectInfoVM alloc] init];
    
    __weakify;
    [self.viewModel.refreshResponse start:NO success:^(id response, id model) {
        __strongify;
        [self refreshUI];
    } error:^(id response, NSInteger code) {
        
    } failure:^(id req, NSError *error) {
    
    }];
    
    if (![GNApp userCity]) {
        [SVProgressHUD showWithStatus:@"正在获取当前城市" maskType:SVProgressHUDMaskTypeBlack];
    }else {
        [self setCityWithCityName:[GNApp userCity].name];
    }
    [GNLocationService requestPlacemarkWithBlock:^(CLPlacemark *placemark, GNCityModel *model, INTULocationStatus status) {
        __strongify;
        
        [SVProgressHUD dismiss];
        if (status == INTULocationStatusSuccess) {
            [GNApp switchUserCity:model];
            [GNApp setUserLocation:placemark.location];
            [self setCityWithCityName:model.name];
        }else if (status == (INTULocationStatus)kLSwitchNewCityCode) {
            NSString *msg = [NSString stringWithFormat:@"你当前的位置为%@,是否切换？",model.name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
            [alert show];
            [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                if ([x intValue] == 1) {
                    __strongify;

                    [GNApp switchUserCity:model];
                    [GNApp setUserLocation:placemark.location];
                    [self setCityWithCityName:model.name];
                }
            }];
        }else if (![GNApp userCity]) {
            [SVProgressHUD showErrorWithStatus:@"定位失败，请选择一个城市"];
            GNSwitchCityVC *controller = [[GNSwitchCityVC alloc] initWithBackEnabled:NO block:^(GNCityModel *model) {
                __strongify;
                [self setCityWithCityName:model.name];
            }];
            [self.navigationController pushVC:controller animated:YES];
        }
    }];
    
    [self.userViewModel.getPerfectInfoResponse start:YES success:^(id response, GNPerfectInfoModel *model) {
        __strongify;
        [GNApp setUserMobile:model.mobile];
        [self.userAvatar setUserAvatarImageWithURL:model.avatar_url];
    } error:^(id response, NSInteger code) {
        
    } failure:^(id req, NSError *error) {
        
    }];
}

- (void)refreshUI {
    
    self.sectionCount = 0;
    
    if (self.viewModel.bannerArray.count > 0) {
        __weakify;
        
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth/2+18)];
        
        BannerView *headerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth*1/2)];
        [headerView enventHandler:^(UIImageView *imageView, NSUInteger index) {
            __strongify;
            
            GNMainBannerItemModel *banner = [self.viewModel.bannerArray objectAtIndex:index];
            
            if ([banner.type isEqualToString:@"url"] && [[banner.attributes allKeys] containsObject:@"url"]) {
                NSMutableString *url = [[NSMutableString alloc] initWithString:[banner.attributes objectForKey:@"url"]];
                GNCityModel *city = [GNApp userCity];
                if (city) {
                    NSRange r = [url rangeOfString: @"?"];
                    if (r.length > 0) {
                        [url appendFormat:@"&city=%ld", (long)city.id];
                    } else {
                        [url appendFormat:@"?city=%ld", (long)city.id];
                    }
                }
                
                GNWebViewVC *controller = [[GNWebViewVC alloc] initWithTitle:@"" url:[NSURL URLWithString: url]];
                [self.navigationController pushVC:controller animated:YES];
            }else if ([banner.type isEqualToString:@"activity"] && [[banner.attributes allKeys] containsObject:@"activity_id"]) {
                
                GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[banner.attributes objectForKey:@"activity_id"]];
                [self.navigationController pushVC:controller animated:YES];
            }else if ([banner.type isEqualToString:@"team"] && [[banner.attributes allKeys] containsObject:@"team_id"]) {
                
                GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
                controller.viewModel = [[GNClubHomePageVM alloc] initWithClubId:[[banner.attributes objectForKey:@"team_id"] integerValue] visibility:GNClubMemberVisibilityAll];
                [self.navigationController pushVC:controller animated:YES];
            }else {
                [SVProgressHUD showErrorWithStatus:@"类型错误"];
            }
        }];
        
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for (GNMainBannerItemModel *item in self.viewModel.bannerArray) {
            [urls addObject:item.image_url];
        }
        
        headerView.imageItems = urls;
        
        [containView addSubview:headerView];
        
        self.tableView.tableHeaderView = containView;
    }
    if (self.viewModel.clubArray.count > 0) {
        self.sectionCount++;
    }
    
    if(self.viewModel.activityArray.count > 0){
        self.sectionCount++;
        self.tableView.tableFooterView = [[UIView alloc]init];
    }else{
        self.tableView.tableFooterView = self.noneRecentActivityView;
    }
    [self.tableView reloadData];
    [self.tableView endAllRefresh];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.viewModel.clubArray.count > 0 && section == 0){
        return 1;
    }
    
    return [self.viewModel.activityArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    GNSectionHeadView* headView;
    if(self.viewModel.clubArray.count > 0 && section == 0){
        headView = [[GNSectionHeadView alloc]initWithSectionName:@"关注的社团" ShowMore:NO OnSectionClicked:nil];
    }
    else{
        __weakify;
        headView = [[GNSectionHeadView alloc]initWithSectionName:@"参与的活动" ShowMore:YES OnSectionClicked:^(UIView *v) {
            __strongify;
            GNMeActivityVC *activityVC = [GNMeActivityVC loadFromStoryboard];
            [self.navigationController pushVC:activityVC animated:YES];
        }];
    }
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewModel.clubArray.count > 0 && indexPath.section == 0){
        return 80;
    }
    return kUIScreenWidth * 2 / 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 || (indexPath.section == 0 && self.viewModel.clubArray.count == 0)){
        GNActivities* activity = [self.viewModel.activityArray objectAtIndex:indexPath.row];
        GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc]
                                           initWithId:[NSString stringWithFormat:@"%ld",(long)activity.id]];
        [self.navigationController pushVC:controller animated:YES];
    }
    [self.optionView hide];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[self.optionView hide];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.optionView hide];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && self.viewModel.clubArray.count > 0) {
        GNMainClubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubCell" forIndexPath:indexPath];
        [cell.collectionView registerNib:[GNMainClubItemCell nib] forCellWithReuseIdentifier:@"ClubItemCell"];
        [cell.collectionView setDataSource:self];
        [cell.collectionView setDelegate:self];
        [cell.collectionView reloadData];
        return cell;
    }else {
        GNMainActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.activity = [self.viewModel.activityArray objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.clubArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNMainClubItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClubItemCell" forIndexPath:indexPath];
    GNClubDetailModel *item = [self.viewModel.clubArray objectAtIndex:indexPath.item];
    [cell.imageView setImageWithURLString:item.logo_url];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
    controller.viewModel = [[GNClubHomePageVM alloc] initWithClubModel:[self.viewModel.clubArray objectAtIndex:indexPath.row]];
    [self.navigationController pushVC:controller animated:YES];
    
    [self.optionView hide];
}

@end
