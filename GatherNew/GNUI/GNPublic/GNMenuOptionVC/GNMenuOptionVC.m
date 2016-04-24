//
//  GNMenuOptionVC.m
//  GatherNew
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMenuOptionVC.h"
#import <Masonry.h>


@interface GNMenuOptionVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, copy) void(^block)(NSUInteger index);

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isFirstShow;

@end

@implementation GNMenuOptionVC

- (instancetype)initWithOptions:(NSArray *)options {
    self = [super init];
    if (self) {
        self.options = options;
        self.isShow = NO;
        [self adjustView];
    }
    return self;
}

- (void)adjustView {
    CGRect r = CGRectMake(0, 0, kUIScreenWidth, self.options.count * 44-1);
    self.view.frame = r;
    self.tableView.frame = r;
}

- (void)autoShowOrHide {
    if (self.view.superview) {
        CGFloat value = self.options.count * 44 - 1;
        
        if (self.isFirstShow) {
            [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo([NSNumber numberWithFloat:-value]);
                make.leading.equalTo(@0);
                make.trailing.equalTo(@0);
                make.height.equalTo([NSNumber numberWithFloat:value]);
            }];
            self.isFirstShow = NO;
        }else {
            [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.isShow) {
                    make.top.equalTo([NSNumber numberWithFloat:-value]);
                    self.isShow = NO;
                }else  {
                    make.top.equalTo(@0);
                    self.isShow = YES;
                }
            }];
        }

    }
}

- (void)didSelectOption:(void (^)(NSUInteger))block {
    self.block = block;
}

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUICellIdentifier];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
}

- (void)binding {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isFirstShow = YES;
    self.isShow = NO;
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kUIColorWithHexUint(0xff3f4450);
    cell.backgroundColor = kUIColorWithHexUint(GNUIColorGrayBlack);
    cell.textLabel.textColor = kUIColorWithHexUint(GNUIColorWhite);
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.view.superview) {
        [self autoShowOrHide];
    }
    if (self.block) {
        self.block(indexPath.row);
    }
}

@end
