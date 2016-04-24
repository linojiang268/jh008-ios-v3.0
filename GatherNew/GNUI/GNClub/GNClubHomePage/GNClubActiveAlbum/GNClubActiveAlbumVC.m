//
//  GNClubActiveAlbumVC.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubActiveAlbumVC.h"
#import "GNClubActiveAlbumTVC.h"
#import "GNClubActiveAlbumVM.h"
#import "GNActivityAlbumContainerVC.h"

@interface GNClubActiveAlbumVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GNClubActiveAlbumVM *viewModel;

@end

@implementation GNClubActiveAlbumVC

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
    [self setTitle:@"社团相册"];
}

- (instancetype)initWithClubId:(NSUInteger)clubId {
    self = [super init];
    if (self) {
        self.viewModel = [[GNClubActiveAlbumVM alloc] initWithClubId:clubId];
    }
    return self;
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
    self.tableView.estimatedRowHeight = 60;
    
    [self.tableView registerNib:[GNClubActiveAlbumTVC nib] forCellReuseIdentifier:kUICellIdentifier];
    [self.tableView addRefreshAndLoadMore];
    
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.activityArray.count) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }else {
            [self.tableView showHintViewWithType:XBHintViewTypeLoadError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
        [self.tableView endAllRefresh];
    };
    [self.viewModel.refreshResponse start:NO success:^(id response, GNClubAlbumListModel *model) {
        __strongify;
        
        if (!self.viewModel.activityArray.count) {
            [self.tableView showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }else {
            [self.tableView reloadData];
            [self.tableView hideHintView];
            [self.tableView setTotalPage:model.pages];
        }
        [self.tableView endAllRefresh];
    } error:^(id response, NSInteger code) {
        errorHandler();
    } failure:^(id req, NSError *error) {
        errorHandler();
    }];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.activityArray.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNClubActiveAlbumTVC *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    [cell bindingModel:[self.viewModel.activityArray objectAtIndex:indexPath.row]];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kUICellIdentifier configuration:^(id cell) {
        [cell bindingModel:[self.viewModel.activityArray objectAtIndex:indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GNClubAlbumListItemModel *model = [self.viewModel.activityArray objectAtIndex:indexPath.row];
    GNActivityAlbumContainerVC *controller = [[GNActivityAlbumContainerVC alloc] initWithActivityId:model.id canUpload:NO];
    [self.navigationController pushVC:controller animated:YES];
}


@end
