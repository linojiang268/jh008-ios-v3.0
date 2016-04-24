//
//  GNActivityApplyVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityDetailsVC.h"
#import "UIView+GNExtension.h"
#import "UIView+XBHintViewExtension.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GNActivityDetailsVM.h"
#import "GNActivityTopCell.h"
#import "GNActivitySponsorCell.h"
#import "GNActivityDetailsCell.h"
#import "GNActivityLocationCell.h"
#import "GNActivityApplyCell.h"
#import "GNActivityMapLineCell.h"
#import "GNActivityDetailsModel.h"
#import "GNMapVC.h"
#import "GNRoadMapVC.h"
#import "GNActivityListModel.h"
#import "GNClubHomePageVC.h"
#import "MHGalleryItem.h"
#import "GNGalleryController.h"
#import "GNStatusVC.h"
#import "GNActivityApplyInputInfoVC.h"
#import "GNPayVC.h"
#import "GNPushSubscibeService.h"
#import "GNShareService.h"
#import "GNActivityManualVC.h"
#import "GNActivityDetailManualCell.h"
#import "GNActivityAlbumContainerVC.h"
#import "GNActivityManualFileVC.h"
#import "GNMemberVC.h"
#import "GNActivityFlowVC.h"


#define activity_cell1 @"activity_cell1"
#define activity_cell2 @"activity_cell2"
#define activity_cell3 @"activity_cell3"
#define activity_cell4 @"activity_cell4"
#define activity_cell5 @"activity_cell5"

@interface GNActivityDetailsVC ()<UITableViewDataSource,UITableViewDelegate,GNActivityDetailsDelegate>
{
    double _scrollY;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewMain;
@property (weak, nonatomic) IBOutlet UILabel *lbMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnApplyAction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewVerticalSp;
@property (weak, nonatomic) IBOutlet UIView *viewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineHeight;
@property (nonatomic, strong) GNActivityDetailsVM *viewModel;
@property (nonatomic, strong) UIView *viewNav;
@property (nonatomic, strong) UILabel * activityTitle;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) GNActivityApplyInputInfoVC *inputInfoController;


@end

@implementation GNActivityDetailsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPayEndRefreshUINotificationName object:nil];
}

- (instancetype)initWithId:(NSString *)activityId{
    self = [super init];
    if (self) {
        self.activityId = activityId;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypePop;
}

- (void)setupUI {
    [super setupUI];
    
    self.bottomLineHeight.constant = 0.5;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableViewMain.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    self.tableViewMain.bounces = NO;
    
    
    self.viewNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 64)];
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 64)];
    image.image = [UIImage imageNamed:@"activity_detail_shadow"];
    [self.viewNav addSubview:image];
    
    UIView* alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 64)];
    alphaView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayBlack);
    alphaView.alpha = 0;
    alphaView.tag = 1;
    [self.viewNav addSubview:alphaView];
    
    UIView *noAlPhaView = [[UIView alloc]initWithFrame:self.viewNav.bounds];
    noAlPhaView.backgroundColor = [UIColor clearColor];
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(noAlPhaView.bounds.size.width-42, 20, 40, 44);
    [btnShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [noAlPhaView addSubview:btnShare];
    
    __weakify;
    btnShare.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        if (self.viewModel.detailsModel) {
            [GNShareService shareActivity:self.viewModel.detailsModel.activity];
        }
        return [RACSignal empty];
    }];
    
    UIButton *btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReturn.frame = CGRectMake(0, 22, 40, 44);
    [btnReturn setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [btnReturn addTarget:self action:@selector(returnVC) forControlEvents:UIControlEventTouchUpInside];
    [noAlPhaView addSubview:btnReturn];
    
    self.activityTitle = [[UILabel alloc]initWithFrame:CGRectMake(44, 20, kUIScreenWidth-88, 44)];
    self.activityTitle.text = @"";
    self.activityTitle.font = [UIFont systemFontOfSize:GNUIFontSize18];
    self.activityTitle.textColor = kUIColorWithHexUint(GNUIColorWhite);
    self.activityTitle.textAlignment = NSTextAlignmentCenter;
    [noAlPhaView addSubview:self.activityTitle];
    
    [self.view addSubview:self.viewNav];
    [self.view addSubview:noAlPhaView];
    
    [self.lbMoney setTextColor:kUIColorWithHexUint(GNUIColorOrange)];
    [self.btnApplyAction setBackgroundColor:kUIColorWithHexUint(GNUIColorOrange)];
    [self.btnApplyAction addTarget:self action:@selector(btnApplyPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kPayEndRefreshUINotificationName object:nil];
    
    self.viewButton.hidden = YES;
}

- (void)refreshUI {
    [self.viewModel.getActivityDataResponse start];
}


-(void) updateStatus{
    
    //已签到
    BOOL checkin  = NO;
    if (self.viewModel.detailsModel.activity.activity_check_in_list.count > 0) {
        for (GNActivitySignInItemModel *item in self.viewModel.detailsModel.activity.activity_check_in_list) {
            if (item.status == 1) {
                [self.btnApplyAction setTitle:@"已签到" forState:UIControlStateNormal];
                [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
                [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                self.btnApplyAction.enabled = NO;
                checkin = YES;
                break;
            }
        }
    }
    
    if(!checkin) {
        switch (self.viewModel.detailsModel.activity.sub_status) {
            case GNActivityStatusCreateing:
                [self.btnApplyAction setTitle:@"即将报名" forState:UIControlStateNormal];
                [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
                [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                self.btnApplyAction.enabled = NO;
                break;
            case GNActivityStatusApplying:
            {
                switch (self.viewModel.detailsModel.activity.applicant_status) {
                    case GNActivityApplicantInfoLose:
                        [self.btnApplyAction setTitle:@"立即报名" forState:UIControlStateNormal];
                        break;
                    case GNActivityApplicantInfoBeginning:
                        [self.btnApplyAction setTitle:@"立即报名" forState:UIControlStateNormal];
                        break;
                    case GNActivityApplicantInfoChecking:
                        [self.btnApplyAction setTitle:@"请等待审核" forState:UIControlStateNormal];
                        [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorDarkgray) forState:UIControlStateNormal];
                        [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                        self.btnApplyAction.enabled = NO;
                        break;
                    case GNActivityApplicantInfoPayment:
                        [self.btnApplyAction setTitle:@"立即付款" forState:UIControlStateNormal];
                        break;
                    case GNActivityApplicantInfoSuccess:
                        [self.btnApplyAction setTitle:@"报名成功" forState:UIControlStateNormal];
                        [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
                        [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                        self.btnApplyAction.enabled = NO;
                        break;
                    case GNActivityApplicantInfoTimeOut:
                        [self.btnApplyAction setTitle:@"重新报名" forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                
            }
                break;
            case GNActivityStatusInPrepare:
                if(self.viewModel.detailsModel.activity.applicant_status == GNActivityApplicantInfoPayment){
                    [self.btnApplyAction setTitle:@"立即付款" forState:UIControlStateNormal];
                }else{
                    [self.btnApplyAction setTitle:@"即将开始" forState:UIControlStateNormal];
                    [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
                    [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                    self.btnApplyAction.enabled = NO;
                }
                break;
            case GNActivityStatusRunning:
                [self.btnApplyAction setTitle:@"进行中" forState:UIControlStateNormal];
                [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
                [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                self.btnApplyAction.enabled = NO;
                break;
            case GNActivityStatusEnd:
                [self.btnApplyAction setTitle:@"已结束" forState:UIControlStateNormal];
                [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorDarkgray) forState:UIControlStateNormal];
                [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                self.btnApplyAction.enabled = NO;
                break;
            default:
                break;
        }
    }
    
    
    switch (self.viewModel.detailsModel.activity.enroll_fee_type) {
        case GNActivityFeeTypeFee:
            self.lbMoney.text = @"免费";
            break;
        case GNActivityFeeTypeAA:
            self.lbMoney.text = @"AA制";
            break;
        case GNActivityFeeTypeToll:
            self.lbMoney.text =[NSString stringWithFormat:@"%@ 元",self.viewModel.detailsModel.activity.enroll_fee];
            break;
        default:
            break;
    }
    
    self.btnApplyAction.layer.masksToBounds = YES;
    self.btnApplyAction.layer.cornerRadius = 5.0f;
    NSRange range = [self.btnApplyAction.titleLabel.text rangeOfString:@"报名"];
    if (range.location != NSNotFound){
        if(self.viewModel.detailsModel.activity.enroll_limit > 0){ //报名有限制
            if(self.viewModel.detailsModel.activity.enrolled_num >= self.viewModel.detailsModel.activity.enroll_limit){
                [self.btnApplyAction setTitle:@"已报满" forState:UIControlStateNormal];
                [self.btnApplyAction setTitleColor:kUIColorWithHexUint(GNUIColorDarkgray) forState:UIControlStateNormal];
                [self.btnApplyAction setBackgroundColor:self.viewButton.backgroundColor];
                self.btnApplyAction.enabled = NO;
            }
        }
    }
    [self.tableViewMain reloadData];
}

- (void)binding {

    self.viewModel = [[GNActivityDetailsVM alloc]init];
    self.viewModel.activityId = self.activityId;
    
    self.tableViewMain.dataSource = self;
    self.tableViewMain.delegate = self;
    self.tableViewMain.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    
    [self.tableViewMain registerNib:[GNActivityTopCell nib] forCellReuseIdentifier:activity_cell1];
    [self.tableViewMain registerNib:[GNActivityLocationCell nib] forCellReuseIdentifier:activity_cell2];
    [self.tableViewMain registerNib:[GNActivityDetailManualCell nib] forCellReuseIdentifier:activity_cell3];
    [self.tableViewMain registerNib:[GNActivityDetailsCell nib] forCellReuseIdentifier:activity_cell4];
    [self.tableViewMain registerNib:[GNActivitySponsorCell nib] forCellReuseIdentifier:activity_cell5];
    
     __weakify;
    [self.viewModel.getActivityDataResponse start:YES success:^(id response, id model) {
        __strongify;
        if (model != nil) {
            self.viewButton.hidden = NO;
            [self updateStatus];
        }else{
            [self.tableViewMain reloadData];
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];
}

#pragma mark - 报名

- (void)btnApplyPressed:(UIButton *)sender {
    __weakify;
    /// 获取订单信息
    [self.viewModel.getOrderInfoResponse start:NO success:^(id response, id model) {
        __strongify;
        NSString *orderNo = [[response objectForKey:@"info"] objectForKey:@"order_no"];
        NSString *price = [[response objectForKey:@"info"] objectForKey:@"fee"];
        //[self.inputInfoController.navigationController popToViewController:self animated:NO];
        
        GNPayVC *controller = [[GNPayVC alloc]
                               initWithOrderNumber:orderNo
                               price:price
                               expireAt:[[response objectForKey:@"info"] objectForKey:@"expire_at"]
                               enrollEndAt:self.viewModel.detailsModel.activity.begin_time
                               backEventHandler:^(GNPayVC* payVC){
                                   //[payVC.navigationController popToViewController:self animated:YES];
                                   GNStatusVC *statusController = [GNStatusVC statusWithStatus:GNStatusTypeSignUpForActivePayFailed
                                                                                   backEnabled:YES
                                                                                   needPayment:(self.viewModel.detailsModel.activity.enroll_fee_type==GNActivityFeeTypeToll)
                                                                              backEventHandler:^(GNStatusVC *statusVC) {
                                                                                  [statusVC.navigationController popToViewController:self animated:YES];
                                                                              }];
                                   
                                   [payVC.navigationController pushVC:statusController animated:YES];
                               }];
        
        [SVProgressHUD dismiss];
        [self.navigationController pushVC:controller animated:YES];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
    }];
    
    /// 提交报名信息
    [self.viewModel.applyResultResponse start:NO success:^(id response, id model) {
        __strongify;
        [SVProgressHUD dismiss];
        
        /// 通知主页面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshMainPageUINotificationName object:nil];
        switch ([[[response objectForKey:@"info"] objectForKey:@"status"] intValue]) {
            case GNApplyStatusInReview:
            {
                //[self.viewModel.getActivityDataResponse start];
                self.viewModel.detailsModel.activity.applicant_status = GNActivityApplicantInfoChecking;
                [self updateStatus];
                
                GNStatusVC *controller = [GNStatusVC statusWithStatus:GNStatusTypeSignUpForActiveWaiting
                                                          backEnabled:YES
                                                          needPayment:(self.viewModel.detailsModel.activity.enroll_fee_type==GNActivityFeeTypeToll)
                                                        backEventHandler:^(GNStatusVC *statusVC) {
                     [statusVC.navigationController popToViewController:self animated:YES];
                 }];
                
                //[self.inputInfoController.navigationController popToViewController:self animated:NO];
                [self.navigationController pushVC:controller animated:YES];
            }
                break;
            case GNApplyStatusWaitingPay:
            {
                //[self.viewModel.getActivityDataResponse start];
                self.viewModel.detailsModel.activity.applicant_status = GNActivityApplicantInfoPayment;
                [self updateStatus];
                //支付
                [SVProgressHUD showWithStatus:@"订单获取中" maskType:SVProgressHUDMaskTypeBlack];
                [self.viewModel.getOrderInfoResponse start];
            }
                break;
            case GNApplyStatusSuccess:
            {
                //[self.viewModel.getActivityDataResponse start];
                self.viewModel.detailsModel.activity.applicant_status = GNActivityApplicantInfoSuccess;
                [self updateStatus];
                
                [GNPushSubscibeService subscribeActivity:[self.activityId integerValue]];
                GNStatusVC *controller = [GNStatusVC statusWithStatus:GNStatusTypeSignUpForActiveSuccess backEnabled:YES needPayment:(self.viewModel.detailsModel.activity.enroll_fee_type==GNActivityFeeTypeToll) backEventHandler:^(GNStatusVC *statusVC) {
                    __strongify;
                    [statusVC.navigationController popToViewController:self animated:YES];
                }];
                
                [self.inputInfoController.navigationController popToViewController:self animated:NO];
                [self.navigationController pushVC:controller animated:YES];
            }
                break;
            default:
            {
                [SVProgressHUD showErrorWithStatus:@"报名失败"];
            }
                break;
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
    }];
    
    switch (self.viewModel.detailsModel.activity.applicant_status) {
        case GNApplyStatusInvalid:
        case GNApplyStatusNormal:
        case GNApplyStatusPayTimeout:
        {
            if (self.viewModel.detailsModel.activity.enroll_type == 2 && !self.viewModel.detailsModel.activity.enrolled_team) {
                [SVProgressHUD showInfoWithStatus:@"此活动只允许本社团成员参加"];
            }else {
                if (self.viewModel.detailsModel.activity.enroll_attrs.count > 0) {
                    if(!self.inputInfoController){
                        self.inputInfoController = [[GNActivityApplyInputInfoVC alloc] initWithRequirements:self.viewModel.detailsModel.activity.enroll_attrs commitHandler:^(NSArray *info) {
                            __strongify;
                            self.viewModel.applyInfo = info;
                            [self.viewModel.applyResultResponse start];
                            [SVProgressHUD showWithStatus:@"提交资料中" maskType:SVProgressHUDMaskTypeBlack];
                        }];
                    }
                    [self.navigationController pushVC:self.inputInfoController animated:YES];
                    
                }else {
                    [self.viewModel.applyResultResponse start];
                }
            }
        }
            break;
        case GNApplyStatusWaitingPay:
        {
            [self.viewModel.getOrderInfoResponse start];
        }
            break;
        case GNApplyStatusInReview:
        case GNApplyStatusSuccess:
            /// 不做任何事
            break;
        default:
            break;
    }
}

-(void)returnVC{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewModel.detailsModel==nil) {
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GNActivityTopCell *cell = [tableView dequeueReusableCellWithIdentifier:activity_cell1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell bindingModel:self.viewModel.detailsModel];
        return cell;
    }
    else if (indexPath.section == 1) {
        GNActivityLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:activity_cell2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell bindActivity:self.viewModel.detailsModel.activity];
        return cell;
    }
    else if (indexPath.section == 2) {
        GNActivityDetailManualCell *cell = [tableView dequeueReusableCellWithIdentifier:activity_cell3 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell bindActivity:self.viewModel.detailsModel.activity];
        return cell;
    }else if (indexPath.section == 3) {
        GNActivityDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:activity_cell4 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell bindingModel:self.viewModel.detailsModel];
        return cell;
    }
    else {
        GNActivitySponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:activity_cell5 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate  = self;
        [cell bindingModel:self.viewModel.detailsModel];
        return cell;
    }
    
    return nil;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 324;
    }else if(indexPath.section == 1){       
        return 90;
    }
    else if(indexPath.section == 2){
        return 125;
    }
    else if(indexPath.section == 3){
        return [tableView fd_heightForCellWithIdentifier:activity_cell4 configuration:^(id cell) {
            [cell bindingModel:self.viewModel.detailsModel];
        }];
    }else if(indexPath.section == 4){
        return 95;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 0.0f;
    else
        return 1.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 4){
        GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
        controller.viewModel = [[GNClubHomePageVM alloc] initWithClubId:self.viewModel.detailsModel.activity.team.id visibility:GNClubMemberVisibilityAll];
        [self.navigationController pushVC:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableViewMain.contentOffset.y<94&&_scrollY<self.tableViewMain.contentOffset.y) {
        _scrollY = self.tableViewMain.contentOffset.y;
        [self.viewNav viewWithTag:1].alpha+=0.1;
    }
    
    if(_scrollY>self.tableViewMain.contentOffset.y&&self.tableViewMain.contentOffset.y<94){
        _scrollY = self.tableViewMain.contentOffset.y;
        [self.viewNav viewWithTag:1].alpha-=0.1;
    }
    
    if (self.tableViewMain.contentOffset.y>94) {
        [self.viewNav viewWithTag:1].alpha = 0.9;
        self.activityTitle.text = self.viewModel.detailsModel.activity.title;
    }
    
    if (self.tableViewMain.contentOffset.y <= 44)
    {
        [self.viewNav viewWithTag:1].alpha = 0;
        self.activityTitle.text = @"";
    }
}

-(void)callPhone:(NSString*)phone {
    if (phone == nil || [phone length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"主办方未设置联系电话"];
        return;
    }
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

-(void)intoMapShowLocaton:(id)sender{
    GNMapVC *mapVC = [GNMapVC loadFromStoryboard];
    mapVC.mapType = GNMapType_CurrentActivity;
    mapVC.activityDetails = self.viewModel.detailsModel.activity;
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

-(void)intoMapShowLine:(id)sender{
    GNRoadMapVC *roadMapVC = [[GNRoadMapVC alloc]initRoadArray:self.viewModel.detailsModel.activity.roadmap];
    roadMapVC.activityDetails = self.viewModel.detailsModel.activity;
    [self.navigationController pushViewController:roadMapVC animated:YES];
}

-(void)showActivityPicture:(id)sender{
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *urlStr in self.viewModel.detailsModel.activity.images_url){
        [array addObject:[self compData:urlStr]];
    }
    
    GNGalleryController *controller = [GNGalleryController galleryControllerWithAlbum:array defaultIndex:0];
    [self.navigationController presentMHGalleryController:controller];
}


-(MHGalleryItem *)compData:(NSString *)url{
    MHGalleryItem *item = [MHGalleryItem.alloc initWithURL:url
                                               galleryType:MHGalleryTypeImage];
    return item;
}

-(void)showActivityFlow:(id)sender{
    if (self.viewModel.detailsModel.activity.applicant_status == 3) {
        GNActivityFlowVC *controller = [[GNActivityFlowVC alloc] initWithActivityModel:self.viewModel.detailsModel];
        [self.navigationController pushVC:controller animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"报名成功后可见"];
    }
}


-(void)showActivityAblum:(id)sender{
    if(self.viewModel.detailsModel.activity.applicant_status == 3){
        GNActivityAlbumContainerVC *controller = [[GNActivityAlbumContainerVC alloc] initWithActivityId:[self.viewModel.activityId integerValue] canUpload:YES];
        [self.navigationController pushVC:controller animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"报名成功后可见"];
    }
}

-(void)showActivityFile:(id)sender{
    if(self.viewModel.detailsModel.activity.applicant_status == 3){
        GNActivityManualFileVC *controller = [[GNActivityManualFileVC alloc] initWithActivityId:[self.viewModel.activityId integerValue]];
        [self.navigationController pushVC:controller animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"报名成功后可见"];
    }
}

-(void)showActivityRoadMap:(id)sender{
    if(self.viewModel.detailsModel.activity.applicant_status == 3){
        if (self.viewModel.detailsModel.activity.roadmap.count > 0) {
            GNRoadMapVC *roadMapVC = [[GNRoadMapVC alloc]initRoadArray:self.viewModel.detailsModel.activity.roadmap];
            roadMapVC.activityDetails = self.viewModel.detailsModel.activity;
            [self.navigationController pushViewController:roadMapVC animated:YES];
        }else {
            [SVProgressHUD showInfoWithStatus:@"主办方未设置路线图"];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"报名成功后可见"];
    }
}

-(void)showActivityMembers:(id)sender{
    if (self.viewModel.detailsModel.activity.id > 0) {
        GNMemberVC *controller = [[GNMemberVC alloc] initWithType:GNMemberTypeActivity typeId:self.viewModel.detailsModel.activity.id];
        [self.navigationController pushVC:controller animated:YES];
    }
}

@end
