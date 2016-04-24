//
//  GNSwitchCityVC.m
//  GatherNew
//
//  Created by apple on 15/7/10.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNSwitchCityVC.h"
#import "GNSwitchCityVM.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "UIView+XBHintViewExtension.h"

@interface GNSwitchCityVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GNSwitchCityVM *viewModel;

@property (nonatomic, assign) BOOL backEnabled;
@property (nonatomic, copy) void(^block)(GNCityModel *model);

@end

@implementation GNSwitchCityVC

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

    self.title = @"选择城市";
    
    if (!self.backEnabled) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:Nil];
    }
}

- (instancetype)initWithBackEnabled:(BOOL)backEnabled block:(void(^)(GNCityModel *model))block {
    self = [super init];
    if (self) {
        self.backEnabled = backEnabled;
        self.block = block;
    }
    return self;
}

- (void)binding {
    
    self.viewModel = [[GNSwitchCityVM alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUICellIdentifier];
    
    __weakify;
    void(^errorHandler)(XBHintViewType type) = ^(XBHintViewType type) {
        __strongify;
        [self.tableView showHintViewWithType:type tapHandler:^(UIView *tapView) {
            __strongify;
            [self.tableView refresh];
            [self.viewModel.cityResponse start];
        }];
        [self.tableView endAllRefresh];
    };
    [self.viewModel.cityResponse start:YES success:^(id response, id model) {
        __strongify;
        
        [self.tableView reloadData];
        [self.tableView endAllRefresh];
    } error:^(id response, NSInteger code) {
        errorHandler(XBHintViewTypeLoadError);
    } failure:^(id req, NSError *error) {
        errorHandler(XBHintViewTypeNetworkError);
    }];
    [self.tableView refresh];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.model.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GNCityModel *model = [self.viewModel.model.cities objectAtIndex:indexPath.row];
    if (kUserCityID == model.id) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = model.name;
    
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    GNCityModel *model = [self.viewModel.model.cities objectAtIndex:indexPath.row];
    if (self.block) {
        self.block(model);
    }
    
    [self.viewModel switchCity:model];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
