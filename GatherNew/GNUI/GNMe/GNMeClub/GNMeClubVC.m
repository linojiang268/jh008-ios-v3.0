//
//  GNMeClubVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeClubVC.h"
#import "GNMeClubCell.h"
#import "GNMeClubListVM.h"
#import "GNMeClubListModel.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "GNClubHomePageVC.h"

#define kUITableViewCellHeader @"tableViewMeClubCell"

@interface GNMeClubVC ()<UITableViewDelegate,UITableViewDataSource,XBTableViewRefreshDelegate>

@property (nonatomic, strong) NSMutableArray* titleList;
@property (nonatomic, strong) GNMeClubListVM *viewModel;

@end

@implementation GNMeClubVC

+ (UIStoryboard *)storyboard {
    return [UIStoryboard storyboardWithName:@"GNMeUI" bundle:nil];
}

+ (instancetype)loadFromStoryboard {
    return [[self storyboard] instantiateViewControllerWithIdentifier:@"meClub"];
}

- (GNBackButtonType)backButtonType{
    return GNBackButtonTypePop;
}

-(void)setupUI{
    [super setupUI];
    
    self.titleList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    
    [self.tableView registerNib:[GNMeClubCell nib] forCellReuseIdentifier:kUITableViewCellHeader];
}

-(void)binding{
    self.viewModel = [[GNMeClubListVM alloc]init];
    
    __weakify;
    [self.viewModel.getClubListResponse start:YES success:^(id response, id model) {
        __strongify;
        
        [self.titleList removeAllObjects];
        
        
        if (self.viewModel.clubListModel.invited_teams.count > 0){
            [self.titleList addObject:@"邀请我的社团"];
        }
        
        if (self.viewModel.clubListModel.enrolled_teams.count > 0) {
            [self.titleList addObject:@"我的社团"];
        }
        
        if (self.viewModel.clubListModel.recommended_teams.count > 0){
            [self.titleList addObject:@"推荐的社团"];
        }
        
        if (self.viewModel.clubListModel.requested_teams.count > 0){
            [self.titleList addObject:@"申请的社团"];
        }
        
        
        [self.tableView reloadData];
        
        if(self.titleList.count == 0){
            [self.tableView  showHintViewWithType:XBHintViewTypeNoData position:CGPointMake(self.view.center.x, self.view.center.y-self.navigationController.navigationBar.bounds.size.height) tapHandler:^(UIView *tapView) {
                [self.tableView hideHintView];                
                [self.viewModel.getClubListResponse start];
            }];
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取社团列表失败!"];
    }];
}

#pragma mark -



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.titleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.titleList objectAtIndex: section]isEqualToString:@"我的社团"]) {
        return self.viewModel.clubListModel.enrolled_teams.count;
    }else if ([[self.titleList objectAtIndex: section]isEqualToString:@"推荐的社团"]){
        return self.viewModel.clubListModel.recommended_teams.count;
    }else if ([[self.titleList objectAtIndex: section]isEqualToString:@"申请的社团"]){
        return self.viewModel.clubListModel.requested_teams.count;
    }else if ([[self.titleList objectAtIndex: section]isEqualToString:@"邀请我的社团"]){
        return self.viewModel.clubListModel.invited_teams.count;
    }
    
    return 0;
}


-(NSObject*)modelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.titleList objectAtIndex: indexPath.section]isEqualToString:@"我的社团"]) {
        return [self.viewModel.clubListModel.enrolled_teams objectAtIndex:indexPath.row];
    }else if ([[self.titleList objectAtIndex: indexPath.section]isEqualToString:@"推荐的社团"]){
        return [self.viewModel.clubListModel.recommended_teams objectAtIndex:indexPath.row];
    }else if ([[self.titleList objectAtIndex: indexPath.section]isEqualToString:@"申请的社团"]){
        return [self.viewModel.clubListModel.requested_teams objectAtIndex:indexPath.row];
    }else if ([[self.titleList objectAtIndex: indexPath.section]isEqualToString:@"邀请我的社团"]){
        return [self.viewModel.clubListModel.invited_teams objectAtIndex:indexPath.row];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNMeClubCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellHeader forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageIsMyClub.hidden = YES;
    cell.hidden = NO;
    
    NSObject* model =[self modelForRowAtIndexPath:indexPath];
    
    if([model isKindOfClass:[GNEnrolled_Teams class]]){
        cell.clubId = ((GNEnrolled_Teams*)model).id;
        [cell setUIData:((GNEnrolled_Teams*)model).logo_url title:((GNEnrolled_Teams*)model).name count:[NSString stringWithFormat:@"新活动：%ld",(long)((GNEnrolled_Teams*)model).activity_num] isShow:((GNEnrolled_Teams*)model).joined];
    }
    else if([model isKindOfClass:[GNInvited_Teams class]]){
        cell.clubId = ((GNInvited_Teams*)model).id;
        [cell setUIData:((GNInvited_Teams*)model).logo_url title:((GNInvited_Teams*)model).name count:[NSString stringWithFormat:@"新活动：%ld",(long)((GNInvited_Teams*)model).activity_num] isShow:((GNInvited_Teams*)model).joined];
    }
    else if([model isKindOfClass:[GNRecommended_Teams class]]){
        cell.clubId = ((GNRecommended_Teams*)model).id;
        [cell setUIData:((GNRecommended_Teams*)model).logo_url title:((GNRecommended_Teams*)model).name count:[NSString stringWithFormat:@"新活动：%ld",(long)((GNRecommended_Teams*)model).activity_num] isShow:((GNRecommended_Teams*)model).joined];
    }else if([model isKindOfClass:[GNRequested_Teams class]]){
        cell.clubId = ((GNRequested_Teams*)model).id;
        [cell setUIData:((GNRequested_Teams*)model).logo_url title:((GNRequested_Teams*)model).name count:[NSString stringWithFormat:@"新活动：%ld",(long)((GNRequested_Teams*)model).activity_num] isShow:((GNRequested_Teams*)model).joined];
    }else{
        cell.hidden = YES;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    [view setBackgroundColor:kUIColorWithHexUint(GNUIColorWhite)];
    UILabel *lbName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    [lbName setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    lbName.font = [UIFont systemFontOfSize:12];
    lbName.text = [self.titleList objectAtIndex:section];
    [view addSubview:lbName];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GNMeClubCell *cell = (GNMeClubCell *)[tableView cellForRowAtIndexPath:indexPath];
    GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
    controller.viewModel = [[GNClubHomePageVM alloc] initWithClubId:cell.clubId visibility:GNClubMemberVisibilityAll];
    [self.navigationController pushVC:controller animated:YES];
}

@end
