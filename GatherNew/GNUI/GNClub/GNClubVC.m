//
//  GNClubVC.m
//  GatherNew
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubVC.h"
#import "GNClubVM.h"
#import "GNClubTVC.h"
#import "GNClubSearchVC.h"
#import "GNClubHomePageVC.h"
#import "UIView+GNExtension.h"
#import "UIView+XBHintViewExtension.h"
#import "UIScrollView+XBRefreshExtension.h"

@interface GNClubVC ()<UITableViewDataSource,UITableViewDelegate, XBTableViewRefreshDelegate>

@end

@implementation GNClubVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"社团";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbar_club"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_club_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypeNone;
}

- (void)setupUI {
    [super setupUI];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];;
    
    __weakify;
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        
        GNClubSearchVC *controller = [[GNClubSearchVC alloc] init];
        
        [self.navigationController pushVC:controller animated:YES];
        
        return [RACSignal empty];
    }];
}

- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.refreshDelegate = self;
    
    [self.tableView addRefreshAndLoadMore];
    [self.tableView registerNib:[GNClubTVC nib] forCellReuseIdentifier:kUICellIdentifier];
    
    self.viewModel = [[GNClubVM alloc] init];
    
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);

    __weakify;
    
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.clubArray.count) {
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
    
    [self.viewModel.refreshResponse start:NO success:^(id response, GNClubListModel *model) {
        __strongify;
        
        if (!self.viewModel.clubArray.count) {
            [self.tableView reloadData];
            [self.tableView setTotalPage:0];
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
    
    if(![self.navigationItem.rightBarButtonItem.title isEqualToString:@"搜索"]){
        [self.tableView refresh];
    }
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.clubArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNClubTVC *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    [cell bindingModel:[self.viewModel.clubArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
    controller.viewModel = [[GNClubHomePageVM alloc] initWithClubModel:[self.viewModel.clubArray objectAtIndex:indexPath.row]];
    [self.navigationController pushVC:controller animated:YES];
}


@end
