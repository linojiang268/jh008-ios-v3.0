//
//  GNActivityApplyInputInfoVC.m
//  GatherNew
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplyInputInfoVC.h"
#import "UIView+GNExtension.h"
#import "GNUITextField.h"
#import "UIControl+GNExtension.h"
#import "NSString+GNExtension.h"

@interface GNActivityApplyInputInfoVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *requirements;
@property (nonatomic, strong) NSMutableArray *inputFieldArray;
@property (nonatomic, strong) NSMutableArray *inputRequirements;

@property (nonatomic, copy) void(^commitHandler)(NSArray *info);

@end

@implementation GNActivityApplyInputInfoVC

- (NSMutableArray *)inputRequirements {
    if (!_inputRequirements) {
        _inputRequirements = [[NSMutableArray alloc] initWithCapacity:self.requirements.count];
    }
    return _inputRequirements;
}

- (instancetype)initWithRequirements:(NSArray *)requirements
                       commitHandler:(void(^)(NSArray *info))handler
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
    [self setTitle:@"报名信息"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //self.scrollView.delaysContentTouches = NO;
    self.inputFieldArray = [[NSMutableArray alloc] initWithCapacity:self.requirements.count];
    
    CGFloat y = 20;
    for (NSString *key in self.requirements) {
        GNUITextField *field = [[GNUITextField alloc] initWithFrame:CGRectMake(0, y, kUIScreenWidth, 44)];
        field.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
        [field addTopAndBottomLineWithDefaultSetting];
        field.key = key;
        field.placeholder = key;
        
        if ([key isEqualToString:@"手机号"]) {
            NSString* mobile = [GNApp userMobile];
            if ([mobile length] >= 11) {
                field.text = [[[[GNApp userMobile] substringToIndex:3] stringByAppendingFormat:@" %@",[[GNApp userMobile] substringWithRange:NSMakeRange(3, 4)]] stringByAppendingFormat:@" %@",[[GNApp userMobile] substringFromIndex:7]];
            }
            field.delegate = self;
        }
        
        [self.scrollView addSubview:field];
        [self.inputFieldArray addObject:field];
        
        y+=43;
    }
    
    y+=65;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    commitButton.frame = CGRectMake(15, y, kUIScreenWidth-30, 44);
    [commitButton setTitle:@"提交报名" forState:UIControlStateNormal];
    [commitButton setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(commitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:commitButton];
    
    
    if (self.inputFieldArray.count >= 2) {
        [[self.inputFieldArray objectAtIndex:1] becomeFirstResponder];
    }
    
    
    self.scrollView.contentSize = CGSizeMake(kUIScreenWidth, commitButton.frame.origin.y + commitButton.frame.size.height + 80);
    [self.view addSubview:self.scrollView];
}

- (void)commitPressed:(UIButton *)button {
    
    for (GNUITextField *field in self.inputFieldArray) {
        if ([NSString isBlank:field.text]) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@",field.placeholder]];
            return;
        }else {
            if ([field.key isEqualToString:@"手机号"]) {
                [self.inputRequirements addObject:@{@"key": field.key, @"value": [field.text stringByReplacingOccurrencesOfString:@" " withString:@""]}];
            }else {
                [self.inputRequirements addObject:@{@"key": field.key, @"value": field.text}];
            }
        }
    }
    
    if (self.commitHandler) {
        self.commitHandler(self.inputRequirements);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ((textField.text.length == 3 || textField.text.length == 8) && ![string isEqualToString:@""]) {
        textField.text = [textField.text stringByAppendingString:@" "];
    }
    
    if (textField.text.length < 13 || [string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

@end
