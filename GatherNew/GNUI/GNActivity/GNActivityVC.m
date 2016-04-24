//
//  GNActivityVC.m
//  GatherNew
//
//  Created by apple on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityVC.h"
#import "UIView+GNExtension.h"
#import "UIView+XBHintViewExtension.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "GNActivitySearchVC.h"
#import "GNMapVC.h"
#import "GNActivityCell.h"
#import "GNActivityListModel.h"
#import "GNActivityDetailsVC.h"

@interface GNActivityVC ()<UITableViewDataSource,UITableViewDelegate, XBTableViewRefreshDelegate>

@end

@implementation GNActivityVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"活动";
        
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbar_active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_active_pressed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (instancetype)initWithViewModel:(GNActivityVM *)viewModel {
    self = [self init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (GNBackButtonType)backButtonType {
    if (self.viewModel.activityType == GNActivityTypeActivity) {
        return GNBackButtonTypeNone;
    }
    return GNBackButtonTypePop;
}

- (void)setupUI {
    [super setupUI];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.viewModel.activityType == GNActivityTypeActivity) {
        UIImage *imageReturn =[UIImage imageNamed:@"activity_IntoMap"];
        imageReturn = [imageReturn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:imageReturn style:UIBarButtonItemStylePlain target:self action:@selector(intoMap)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"search_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];;
        
        __weakify;
        self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            __strongify;
            GNActivitySearchVC *controller = [[GNActivitySearchVC alloc] initWithViewModel:[[GNActivityVM alloc] initActiveList]];
            [self.navigationController pushVC:controller animated:YES];
            return [RACSignal empty];
        }];
    }
}

- (void)binding {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.refreshDelegate = self;
    
    [self.tableView addRefreshAndLoadMore];
    [self.tableView registerNib:[GNActivityCell nib] forCellReuseIdentifier:kUICellIdentifier];
    
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
    
    [self.viewModel.refreshActivityResponse start:NO success:^(id response, GNActivityListModel *model) {
        __strongify;
        
        if (!model.activities.count) {
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

-(void)intoMap{
    GNMapVC *mapVC = [GNMapVC loadFromStoryboard];
    mapVC.mapType = GNMapType_AllActivity;
    [self.navigationController pushVC:mapVC animated:YES];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.activityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    [cell bindingModel:[self.viewModel.activityArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kUIScreenWidth * 2 /3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GNActivities *activiety =[self.viewModel.activityArray objectAtIndex:indexPath.row];
    
    GNActivityDetailsVC *detailsVC = [[GNActivityDetailsVC alloc]initWithId:[NSString stringWithFormat:@"%ld",(long)activiety.id]];
    
    [self.navigationController pushVC:detailsVC animated:YES];

}


@end
