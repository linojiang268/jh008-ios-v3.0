//
//  GNClubMessageVC.m
//  GatherNew
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubMessageVC.h"
#import "GNClubMessageTVC.h"
#import "GNMessageVM.h"
#import "GNWebViewVC.h"
#import "GNActivityDetailsVC.h"
#import "GNClubHomePageVC.h"
#import "UIView+XBHintViewExtension.h"
#import "GNMessageService.h"

@interface GNClubMessageVC ()<UITableViewDataSource,UITableViewDelegate,XBTableViewRefreshDelegate>

@property (nonatomic, strong) GNMessageVM *viewModel;

@end

@implementation GNClubMessageVC

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)setupUI {
    [super setupUI];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isFirstRefresh) {
        [self.tableView refresh];
        [self setIsFirstRefresh:NO];
    }
}

- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.refreshDelegate = self;
    self.tableView.rowHeight = 90;
    
    [self.tableView registerNib:[GNClubMessageTVC nib] forCellReuseIdentifier:kUICellIdentifier];
    [self.tableView addRefreshControl];
    
    self.viewModel = [[GNMessageVM alloc] initWithType:GNMessageTypeClub];
    
    __weakify;
    [self.viewModel.refreshResponse start:NO success:^(id response, NSArray *model) {
        __strongify;
        
        if (!model.count) {
            [self.tableView showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }else {
            [self.tableView reloadData];
            [self.tableView hideHintView];
        }
        [self.tableView endAllRefresh];
    } error:^(id response, NSInteger code) {

    } failure:^(id req, NSError *error) {

    }];
}

#pragma mark -

- (void)req:(XBRefreshType)refreshType page:(NSUInteger)page tableView:(UIScrollView *)tableView {
    if (refreshType == XBRefreshTypeRefresh) {
        [self.viewModel.refreshResponse start];
    }
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNClubMessageTVC *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    [cell bindingModel:[self.viewModel.messageArray objectAtIndex:indexPath.row]];
    [cell deleteWithCallback:^(id model) {
        
        NSInteger row = [self.viewModel.messageArray indexOfObject:model];
        [self.viewModel.messageArray removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    return cell;
}

#pragma mark -

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kUICellIdentifier configuration:^(id cell) {
        [cell bindingModel:[self.viewModel.messageArray objectAtIndex:indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GNClubMessageTVC *cell = (GNClubMessageTVC *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setReadState:YES];
    
    GNMessageModel *message = [self.viewModel.messageArray objectAtIndex:indexPath.row];
    if ([message.type isEqualToString:@"url"]) {
        
        GNWebViewVC *controller = [[GNWebViewVC alloc] initWithTitle:@"" url:[NSURL URLWithString:message.url]];
        [self.navigationController pushVC:controller animated:YES];
        
    }else if ([message.type isEqualToString:@"activity"]) {
        GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[NSString stringWithFormat:@"%lld",message.activity_id]];
        [self.navigationController pushVC:controller animated:YES];
    }else if ([message.type isEqualToString:@"team"]) {
        GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
        controller.viewModel = [[GNClubHomePageVM alloc] initWithClubId:message.team_id visibility:GNClubMemberVisibilityAll];
        [self.navigationController pushVC:controller animated:YES];
    }
}

@end
