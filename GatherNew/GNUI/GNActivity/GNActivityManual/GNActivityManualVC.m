//
//  GNActivityManualVC.m
//  GatherNew
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualVC.h"
#import "GNActivityManualModuleCell.h"
#import "GNActivityManualFlowCell.h"
#import "GNActivityManualSponsorCell.h"
#import "GNActivityManualIntroCell.h"

#import "GNActivityManualVM.h"

/// 扫描
#import "BarcodeViewController.h"
#import "GNSignInVC.h"
#import "GNWebViewVC.h"
#import "GNClubHomePageVC.h"
#import "GNActivityDetailsVC.h"
#import "GNActivityManualVC.h"
#import "GNScanStatusVC.h"

#import "GNRoadMapVC.h"
#import "GNMemberVC.h"
#import "GNActivityManualFileVC.h"
#import "GNActivityAlbumContainerVC.h"

@interface GNActivityManualVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GNActivityManualVM *viewModel;

@property (nonatomic, assign) BOOL showActivityIntro;

@end

@implementation GNActivityManualVC

- (instancetype)initWithActivityId:(NSUInteger)activityId showActivityIntro:(BOOL)showActivityIntro {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.showActivityIntro = showActivityIntro;
        self.viewModel = [[GNActivityManualVM alloc] initWithActivityId:activityId];
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"活动手册"];
}
- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[GNActivityManualModuleCell nib] forCellReuseIdentifier:kUICellIdentifier];
    [self.tableView registerNib:[GNActivityManualFlowCell nib] forCellReuseIdentifier:@"flowCell"];
    [self.tableView registerNib:[GNActivityManualSponsorCell nib] forCellReuseIdentifier:@"sponsorCell"];
    [self.tableView registerNib:[GNActivityManualIntroCell nib] forCellReuseIdentifier:@"introCell"];
    
    __weakify;
    [self.viewModel.getManualInfoResponse start:YES success:^(id response, id model) {
        __strongify;
        [self.tableView reloadData];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
    }];
}

- (void)member {
    if (self.viewModel.activityId > 0) {
        GNMemberVC *controller = [[GNMemberVC alloc] initWithType:GNMemberTypeActivity typeId:self.viewModel.activityId];
        [self.navigationController pushVC:controller animated:YES];
    }
}

- (void)album {
    if (self.viewModel.activityId > 0) {
        GNActivityAlbumContainerVC *controller = [[GNActivityAlbumContainerVC alloc] initWithActivityId:self.viewModel.activityId canUpload:YES];
        [self.navigationController pushVC:controller animated:YES];
    }
}

- (void)file {
    if (self.viewModel.activityId > 0) {
        GNActivityManualFileVC *controller = [[GNActivityManualFileVC alloc] initWithActivityId:self.viewModel.activityId];
        [self.navigationController pushVC:controller animated:YES];
    }
}

- (void)roadMap {
    if (self.viewModel.manualModel.activity.roadmap.count > 0) {
        GNRoadMapVC *roadMapVC = [[GNRoadMapVC alloc]initRoadArray:self.viewModel.manualModel.activity.roadmap];
        roadMapVC.activityDetails = (GNActivityDetails *)self.viewModel.manualModel.activity;
        [self.navigationController pushViewController:roadMapVC animated:YES];
    }else {
        [SVProgressHUD showInfoWithStatus:@"主办方未设置路线图"];
    }
}

- (void)showActivityDetail {
    GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[NSString stringWithFormat:@"%ld",(unsigned long)self.viewModel.activityId]];
    [self.navigationController pushVC:controller animated:YES];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showActivityIntro ? 4 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            GNActivityManualModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell bindingModel:self.viewModel.manualModel];
            
            [cell.memberButton addTarget:self action:@selector(member) forControlEvents:UIControlEventTouchUpInside];
            [cell.albumButton addTarget:self action:@selector(album) forControlEvents:UIControlEventTouchUpInside];
            [cell.fileButton addTarget:self action:@selector(file) forControlEvents:UIControlEventTouchUpInside];
            [cell.roadMapButton addTarget:self action:@selector(roadMap) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
            break;
        case 1:
        {
            GNActivityManualFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flowCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell bindingModel:self.viewModel.manualModel];
            
            return cell;
        }
            break;
        case 2:
        {
            GNActivityManualSponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell bindingModel:self.viewModel.manualModel];
            
            return cell;
        }
            break;
        case 3:
        {
            GNActivityManualIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.button addTarget:self action:@selector(showActivityDetail) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 122.0;
            break;
        case 1:
        {
            if (self.viewModel.manualModel.activity.activity_plans.count > 0) {
                GNActivityManualFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flowCell"];
                [cell bindingModel:self.viewModel.manualModel];
                
                return [cell cellHeight];
            }else {
                return 225.0;
            }
        }
            break;
        case 2:
        {
            GNActivityManualSponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell"];
            [cell bindingModel:self.viewModel.manualModel];
            
            return [cell cellHeight];
        }
            break;
        case 3:
            return 65;
            break;
        default:
            break;
    }
    return 0.0;
}

@end
