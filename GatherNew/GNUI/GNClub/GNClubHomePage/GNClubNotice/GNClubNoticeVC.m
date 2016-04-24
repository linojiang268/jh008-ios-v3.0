//
//  GNClubNoticeVC.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubNoticeVC.h"
#import "GNClubNoticeTVC.h"
#import "UIScrollView+XBRefreshExtension.h"

@interface GNClubNoticeVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation GNClubNoticeVC

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"社团通知"];
}

- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView addRefreshAndLoadMore];
    [self.tableView registerNib:[GNClubNoticeTVC nib] forCellReuseIdentifier:kUICellIdentifier];
//    __weakify;
//    [self.viewModel.refreshResponse success:^(id response, id model) {
//        __strongify;
//        
//        [self.GNUI.tableView reloadData];
//    } error:^(id response, NSInteger code) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}


#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNClubNoticeTVC *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
