//
//  GNActivityFlowVC.m
//  GatherNew
//
//  Created by apple on 15/9/21.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityFlowVC.h"
#import "GNActivityManualFlowCell.h"
#import "GNActivityManualSponsorCell.h"
#import "GNActivityDetailsModel.h"


@interface GNActivityFlowVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GNActivityDetailsModel *activityModel;

@end

@implementation GNActivityFlowVC

- (instancetype)initWithActivityModel:(GNActivityDetailsModel *)model {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"活动流程";
        self.activityModel = model;
    }
    return self;
}

- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[GNActivityManualFlowCell nib] forCellReuseIdentifier:@"flowCell"];
    [self.tableView registerNib:[GNActivityManualSponsorCell nib] forCellReuseIdentifier:@"sponsorCell"];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GNActivityManualFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flowCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell bindingModel:self.activityModel];
        [cell hideSignInView];
        
        return cell;
    }else {

        GNActivityManualSponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell bindingModel:self.activityModel];
        
        return cell;
    }
    
    return nil;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (self.activityModel.activity.activity_plans.count > 0) {
                GNActivityManualFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flowCell"];
                [cell bindingModel:self.activityModel];
                [cell hideSignInView];
                return [cell cellHeight];
            }else {
                return 225.0;
            }
        }
            break;
        case 1:
        {
            GNActivityManualSponsorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sponsorCell"];
            [cell bindingModel:self.activityModel];
            
            return [cell cellHeight];
        }
            break;
        default:
            break;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
