//
//  GNTableVCBase.h
//  GatherNew
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface GNTableVCBase : GNVCBase

@property (nonatomic, strong) UITableView *tableView;

// The only method of initialization
- (instancetype)initWithStyle:(UITableViewStyle)style;

@property (nonatomic, assign) BOOL isFirstRefresh;

@end
