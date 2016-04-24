//
//  GNClubNewsVC.m
//  GatherNew
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubNewsVC.h"
#import "GNClubNewsTVC.h"
#import "GNClubNewsVM.h"
#import "GNWebViewVC.h"
#import "GNShareService.h"

@interface GNClubNewsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GNClubNewsVM *viewModel;

@property (nonatomic, strong) GNClubDetailModel *model;

@end

@implementation GNClubNewsVC

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
    [self setTitle:@"资讯列表"];
}

- (instancetype)initWithClubModel:(GNClubDetailModel *)model {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.model = model;
        self.viewModel = [[GNClubNewsVM alloc] initWithClubId:model.id];
    }
    return self;
}

- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    
    [self.tableView registerNib:[GNClubNewsTVC nib] forCellReuseIdentifier:kUICellIdentifier];\
    [self.tableView addRefreshAndLoadMore];
    
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.newsArray.count) {
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
    [self.viewModel.refreshResponse start:NO success:^(id response, GNClubNewsListModel *model) {
        __strongify;
        
        if (!self.viewModel.newsArray.count) {
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
    
    [self.tableView refresh];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNClubNewsTVC *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    [cell bindingModel:[self.viewModel.newsArray objectAtIndex:indexPath.row]];
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
    
    GNClubNewsModel *news = [self.viewModel.newsArray objectAtIndex:indexPath.row];
    
    NSString *stringURL = [NSString stringWithFormat:@"%@/wap/news/detail?news_id=%d",kHttpDomain,news.id];
    NSURL *url = [NSURL URLWithString:stringURL];

    GNWebViewVC *controller = [[GNWebViewVC alloc] initWithTitle:@"资讯详情" url:url];
    [controller addShareWithClickBlock:^{
        [GNShareService shareNews:self.model url:stringURL];
    }];
    [self.navigationController pushVC:controller animated:YES];
}

@end
