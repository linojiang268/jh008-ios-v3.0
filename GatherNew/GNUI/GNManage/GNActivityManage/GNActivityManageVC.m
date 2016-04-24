//
//  GNActivityManageVC.m
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageVC.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "GNActivityManageCell.h"
#import "GNActivityManageCellWithOptions.h"
#import "GNActivitySignInManageVC.h"
#import "GNActivityAlbumContainerVC.h"
#import "GNActivityApplySuccessListVC.h"
#import "GNActivityManageVM.h"
#import "GNActivityManageListModel.h"
#import "GNActivityManageDetailVC.h"
#import "GNActivityMessageVC.h"

@interface GNActivityManageVC ()<UITableViewDelegate, UITableViewDataSource, XBTableViewRefreshDelegate>

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, strong) GNActivityManageVM* viewModel;


@end

@implementation GNActivityManageVC

-(void)setupUI{
    [super setupUI];
    
    self.title = @"活动";
    self.tableView.tableFooterView = [[UIView alloc]init];
    //self.tableView.contentInset = UIEdgeInsetsMake(32, 0, 0, 0);
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    [self.tableView registerNib:[GNActivityManageCell nib] forCellReuseIdentifier:@"GNActivityManageCell"];
    [self.tableView registerNib:[GNActivityManageCellWithOptions nib] forCellReuseIdentifier:@"GNActivityManageCellWithOptions"];
    
    
}

-(void)binding {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.refreshDelegate = self;
    
    [self.tableView addRefreshAndLoadMore];
    self.viewModel = [[GNActivityManageVM alloc]init];
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    __weakify;
    [self.viewModel.getActivityListResponse start:NO success:^(id response, GNActivityManageListModel* model) {
        __strongify;
        [self.tableView reloadData];
        [self.tableView setTotalPage:model.pages];
        [self.tableView endAllRefresh];
        
        if(model.total_num == 0){
            [self.tableView showHintViewWithType:XBHintViewTypeNoData message:@"活动管理列表为空，点击刷新！" tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        [self.tableView endAllRefresh];
    } failure:^(id req, NSError *error) {
        [self.tableView endAllRefresh];
        if([self.viewModel.activityList count] == 0){
            [self.tableView showHintViewWithType:XBHintViewTypeNetworkError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
    }];
    
    [self.tableView refresh];
}

#pragma mark --
- (void)onActivityEnrollViewClicked:(UITapGestureRecognizer *)tap {
    GNActivityManageModel* activity = [self.viewModel.activityList objectAtIndex:tap.view.tag];
    GNActivityManageDetailVC* controller = [GNActivityManageDetailVC initWithActivity:activity.id needAuth:(activity.auditing ==1 ) needPay:(activity.enroll_fee_type == 3) enrollAttrs:activity.enroll_attrs subStatus:activity.sub_status];
    [self.navigationController pushVC:controller animated:YES];
}

- (void)onActivityCheckInViewClicked:(UITapGestureRecognizer *)tap {
    GNActivityManageModel* activity = [self.viewModel.activityList objectAtIndex:tap.view.tag];
    GNActivitySignInManageVC *controller = [GNActivitySignInManageVC initWithActivityId:activity.id subStatus:activity.sub_status];
    [self.navigationController pushVC:controller animated:YES];
}

- (void)onActivityMessageViewClicked:(UITapGestureRecognizer *)tap {
    GNActivityManageModel* activity = [self.viewModel.activityList objectAtIndex:tap.view.tag];
    __weakify;
    [self.viewModel getLeftMessageForActivity:activity.id success:^(id response, id model) {
        __strongify;
        GNActivityMessageVC *controller = [GNActivityMessageVC initWithActivity:activity.id];
        [self.navigationController pushVC:controller animated:YES];
    } error:^(id response, NSInteger code) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:activity.title message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } failure:^(id req, NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 32;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.activityList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selectedIndexPath isEqual:indexPath]){
        return 110;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityManageModel* activity = [self.viewModel.activityList objectAtIndex:indexPath.row];
    DateTime tm = {0};
    ParseDateTime([activity.begin_time UTF8String], tm);
    
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger currentYear = [dateComponent year];
    NSString* time = (currentYear == tm.year) ? [NSString stringWithFormat:@"%ld月%ld日  %.2ld:%.2ld", tm.mon, tm.day, tm.hour, tm.min]:[NSString stringWithFormat:@"%ld年%ld月%ld日  %.2ld:%.2ld",tm.year, tm.mon, tm.day, tm.hour, tm.min];
    
    if([self.selectedIndexPath isEqual:indexPath]){
        GNActivityManageCellWithOptions* cell = [tableView dequeueReusableCellWithIdentifier:@"GNActivityManageCellWithOptions" forIndexPath:indexPath];
        [cell setActivityId:activity.id name:activity.title time:time state:activity.sub_status enableMessage:YES];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.activityEnrollView setTag:indexPath.row];
        [cell.activityCheckInView setTag:indexPath.row];
        [cell.activityMessageView setTag:indexPath.row];
        [cell.activityEnrollView addGestureRecognizer: [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(onActivityEnrollViewClicked:)]];
        [cell.activityCheckInView addGestureRecognizer: [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(onActivityCheckInViewClicked:)]];
        [cell.activityMessageView addGestureRecognizer: [[UITapGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(onActivityMessageViewClicked:)]];
        return cell;
    }else{
        GNActivityManageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GNActivityManageCell" forIndexPath:indexPath];
        [cell setActivityName:activity.title time:time state:activity.sub_status];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.selectedIndexPath){
        self.selectedIndexPath = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if(![self.selectedIndexPath isEqual:indexPath]){
        [self.tableView beginUpdates];
        NSIndexPath *temp = self.selectedIndexPath;
        self.selectedIndexPath = nil;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:temp] withRowAnimation:UITableViewRowAnimationNone];
     
        self.selectedIndexPath = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    else if([self.selectedIndexPath isEqual:indexPath]){
        [self.tableView beginUpdates];
        NSIndexPath *temp = self.selectedIndexPath;
        self.selectedIndexPath = nil;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:temp] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}


@end
