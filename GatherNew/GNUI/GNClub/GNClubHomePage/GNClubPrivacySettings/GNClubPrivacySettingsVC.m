//
//  GNClubPrivacySettingsVC.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubPrivacySettingsVC.h"

@interface GNClubPrivacySettingsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) GNClubMemberVisibility oldVisibility;
@property (nonatomic, assign) GNClubMemberVisibility visibility;
@property (nonatomic, copy) void(^changeHandler)(GNClubMemberVisibility visibility);

@end

@implementation GNClubPrivacySettingsVC

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"隐私设置"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUICellIdentifier];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (instancetype)initWithVisibility:(GNClubMemberVisibility)visibility
                     changeHandler:(void(^)(GNClubMemberVisibility visibility))handler
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.oldVisibility = visibility;
        self.visibility = visibility;
        self.changeHandler = handler;
    }
    return self;
}

- (void)binding {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (self.oldVisibility != self.visibility) {
        if (self.changeHandler) {
            self.changeHandler(self.visibility);
        }
    }
    [super backBarButtonItemPressed:sender];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == self.visibility) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"所有人可见";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"仅本社团成员可见";
    }
    
    return cell;
}

#pragma mark -

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.visibility = indexPath.row;
    [tableView reloadData];
}


@end
