//
//  GNOptionView.m
//  GatherNew
//
//  Created by yuanjun on 15/9/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNOptionView.h"
#import <Masonry.h>

#define OPTION_ITEM_HEIGHT 44
#define DEFAULT_MARGIN_LEFT 8
#define DEFAULT_MARGIN_RIGTH 8

@interface GNOptionView () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) UIImageView* arrowView;
@property(nonatomic, strong) NSArray* options;
@property(nonatomic, strong) NSArray* icons;
@property(nonatomic, assign) CGPoint position;
@property(nonatomic, assign) CGFloat arrowOffset;
@property(nonatomic, assign) CGSize expectSize;
@property(nonatomic, assign) BOOL isShow;
@property(nonatomic, assign) BOOL isFirstShow;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, strong) NSMutableDictionary* redDotInfo;

@end

@implementation GNOptionView

- (instancetype)initWithOptions:(NSArray*)options icons:(NSArray*)icons position:(CGPoint)position arrowOffset:(CGFloat)offset expectSize:(CGSize)expectSize
{
    self = [super init];
    if (self) {
        self.options = options;
        self.icons = icons;
        self.position = position;
        self.arrowOffset = offset;
        self.expectSize = expectSize;
        self.redDotInfo = [NSMutableDictionary dictionary];
        [self initView];
    }
    return self;
}

-(void)translate
{
    self.height = 0;
    if(self.expectSize.height > 0){
        self.height = self.expectSize.height;
    }
    else{
        self.height = OPTION_ITEM_HEIGHT*[self.options count] + 6;
    }
    
    self.width = 0;
    if(self.expectSize.width > 0){
        self.width = self.expectSize.width;
    }
    else{
        self.width = 100;
    }
    
    if(self.position.x < 0){
        self.position = CGPointMake(DEFAULT_MARGIN_RIGTH, self.position.y);
    }
    
    if(self.position.x + self.width > kUIScreenWidth){
        self.position = CGPointMake(kUIScreenWidth - self.width - DEFAULT_MARGIN_RIGTH, self.position.y);
    }
}

-(void)initView{
    [self translate];
    
    self.frame = CGRectMake(self.position.x, self.position.y, self.expectSize.width, self.height);
    self.backgroundColor = [UIColor clearColor];
    
    self.arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(self.arrowOffset, 0, 10, 5)];
    
    self.arrowView.image = [UIImage imageNamed:@"options_arrow"];
    [self addSubview:self.arrowView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, self.expectSize.width, MAX(OPTION_ITEM_HEIGHT*[self.options count], 88))];
    [self addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayBlack);
    self.tableView.bounces = NO;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 3.0f;
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUICellIdentifier];
    
}

-(void)showRedDotAtRow:(NSInteger)row show:(BOOL)show{
    [self.redDotInfo setValue:(show ? @"1" : @"0") forKey:[NSString stringWithFormat:@"%ld", (long)row]];
    [self.tableView reloadData];
}

-(void)removeAllRedDotAtRow{
    [self.redDotInfo removeAllObjects];
    [self.tableView reloadData];
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.options count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return OPTION_ITEM_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.onItemClick){
        self.onItemClick(indexPath.row, [self.options objectAtIndex:indexPath.row]);
    }
    [self hide];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kUIColorWithHexUint(0xff3f4450);
    cell.backgroundColor = kUIColorWithHexUint(GNUIColorGrayBlack);
    cell.textLabel.textColor = kUIColorWithHexUint(GNUIColorWhite);
    
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[self.options objectAtIndex:indexPath.row]];
    if([[self.redDotInfo valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] boolValue]){
        NSMutableAttributedString *redDot = [[NSMutableAttributedString alloc] initWithString:@"●"];
        [redDot addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:NSMakeRange(0, redDot.length)];
        [attrString appendAttributedString:redDot];
    }
   
    cell.textLabel.attributedText = attrString;
    cell.imageView.image = [UIImage imageNamed:[self.icons objectAtIndex:indexPath.row]];
    
    return cell;
}




-(void)autoShowOrHide {
    if (self.superview) {
        if (self.isShow) {
            [self hide];
        }else  {
            [self show];
        }
    }
}

-(void)show {
    if (self.superview) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(self.position.x));
            make.height.equalTo(@(self.height));
            make.width.equalTo(@(self.width));
            self.isShow = YES;
        }];
    }
}


-(void)hide {
    if (self.superview) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([NSNumber numberWithFloat:-self.height]);
            self.isShow = NO;
        }];
    }
}

@end
