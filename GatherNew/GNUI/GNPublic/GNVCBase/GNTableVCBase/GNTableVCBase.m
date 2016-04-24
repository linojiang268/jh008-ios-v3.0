//
//  GNTableVCBase.m
//  GatherNew
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTableVCBase.h"
#import <Masonry.h>

@interface GNTableVCBase ()

@property (nonatomic, assign) UITableViewStyle style;

@end

@implementation GNTableVCBase

- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat topPadding = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat bottomPadding = self.hidesBottomBarWhenPushed ? 0 : 49;
        CGRect r = [[UIScreen mainScreen] bounds];
        r.size.height -= (topPadding + bottomPadding);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];
        _tableView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstRefresh = YES;
}


@end
