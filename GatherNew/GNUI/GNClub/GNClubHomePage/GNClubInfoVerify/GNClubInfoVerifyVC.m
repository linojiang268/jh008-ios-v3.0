//
//  GNClubInfoVerifyVC.m
//  GatherNew
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubInfoVerifyVC.h"
#import "GNClubListModel.h"
#import "UIView+GNExtension.h"
#import "GNUITextField.h"
#import "UIControl+GNExtension.h"
#import "NSString+GNExtension.h"

@interface GNClubInfoVerifyVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *requirements;
@property (nonatomic, strong) NSMutableArray *inputFieldArray;
@property (nonatomic, strong) NSMutableDictionary *inputRequirements;

@property (nonatomic, copy) void(^commitHandler)(NSDictionary *requirements);

@end

@implementation GNClubInfoVerifyVC

- (NSMutableDictionary *)inputRequirements {
    if (!_inputRequirements) {
        _inputRequirements = [[NSMutableDictionary alloc] initWithCapacity:self.requirements.count];
    }
    return _inputRequirements;
}

- (instancetype)initWithRequirements:(NSArray *)requirements
                       commitHandler:(void(^)(NSDictionary *requirements))handler
{
    self = [super init];
    if (self) {
        self.requirements = requirements;
        self.commitHandler = handler;
    }
    return self;
}

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"信息验证"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delaysContentTouches = NO;
    self.inputFieldArray = [[NSMutableArray alloc] initWithCapacity:self.requirements.count];
    
    CGFloat y = 20;
    for (GNClubJoinRequirementModel *model in self.requirements) {
        
        GNUITextField *field = [[GNUITextField alloc] initWithFrame:CGRectMake(0, y, kUIScreenWidth, 44)];
        field.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
        [field addTopAndBottomLineWithDefaultSetting];
        field.tag = model.id;
        field.placeholder = model.requirement;
        
        [self.scrollView addSubview:field];
        [self.inputFieldArray addObject:field];
        
        y+=43;
    }
    y+=65;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    commitButton.frame = CGRectMake(15, y, kUIScreenWidth-30, 44);
    [commitButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [commitButton setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(commitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:commitButton];
    [self.view addSubview:self.scrollView];
}

- (void)commitPressed:(UIButton *)button {
    
    for (GNUITextField *field in self.inputFieldArray) {
        if ([NSString isBlank:field.text]) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@",field.placeholder]];
            return;
        }else {
            [self.inputRequirements setObject:field.text forKey:[kNumber(field.tag) stringValue]];
        }
    }
    
    if (self.commitHandler) {
        self.commitHandler(self.inputRequirements);
    }
}

@end
