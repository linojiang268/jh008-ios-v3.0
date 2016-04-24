//
//  GNActivityManageAddNewVC.m
//  GatherNew
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageAddNewVC.h"
#import <Masonry.h>
#import "HMSegmentedControl.h"
#import "GNActivityManageAddNewCell.h"
#import "GNUITextField.h"
#import "UIView+GNExtension.h"
#import "UIControl+GNExtension.h"
#import "NSString+GNExtension.h"
#import "GNActivityManageAddNewVM.h"



@interface GNActivityManageAddNewVC() <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) NSArray *requirements;
@property (nonatomic, strong) NSMutableArray *inputFieldArray;
@property (nonatomic, strong) NSMutableArray *inputRequirements;

@property(nonatomic, strong) GNActivityManageAddNewVM *viewModel;

@property(nonatomic, strong) GNActivityApplySuccessListVC *sucListVC;

@end

@implementation GNActivityManageAddNewVC

+ (instancetype)initWithActivityId:(NSUInteger)activityId requirements:(NSArray *)requirement sucVC:(GNActivityApplySuccessListVC *)sucVC {
    GNActivityManageAddNewVC * vc = [[GNActivityManageAddNewVC alloc]init];
    vc.activityId = activityId;
    vc.requirements = requirement;
    vc.sucListVC = sucVC;
    return vc;
}

- (void)setupUI {
    [super setupUI];
    [self setTitle:@"代报名"];
    [self.view addSubview:[self scrollView]];
    
    _viewModel = [[GNActivityManageAddNewVM alloc] initWithActivity];
    
    [self addSubViewsToScroll];
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat topHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        topHeight += CGRectGetHeight(self.navigationController.navigationBar.frame);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kUIScreenWidth, kUIScreenHeight-topHeight - 20)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(kUIScreenWidth, kUIScreenHeight);
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.tag = 0x1000;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(void) addSubViewsToScroll {
    
    self.inputFieldArray = [[NSMutableArray alloc] initWithCapacity:self.requirements.count];
    
    CGFloat y = 0;
    for (NSString *key in self.requirements) {
        GNUITextField *field = [[GNUITextField alloc] initWithFrame:CGRectMake(0, y, kUIScreenWidth, 44)];
        field.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
        [field addTopAndBottomLineWithDefaultSetting];
        field.key = key;
        field.placeholder = key;
        
        if ([key isEqualToString:@"手机号"]) {
            field.keyboardType = UIKeyboardTypePhonePad;
            field.text = @"";
//            [[[[GNApp userMobile] substringToIndex:3] stringByAppendingFormat:@" %@",[[GNApp userMobile] substringWithRange:NSMakeRange(3, 4)]] stringByAppendingFormat:@" %@",[[GNApp userMobile] substringFromIndex:7]];
           
            field.delegate = self;
        }
        
        [self.scrollView addSubview:field];
        [self.inputFieldArray addObject:field];
        
        y+=43;
    }
    
    y+=65;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    commitButton.frame = CGRectMake(15, y, kUIScreenWidth-30, 44);
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [commitButton setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(commitPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:commitButton];
    
    
    if (self.inputFieldArray.count >= 1) {
        [[self.inputFieldArray objectAtIndex: 0] becomeFirstResponder];
    }
    
    
    self.scrollView.contentSize = CGSizeMake(kUIScreenWidth, commitButton.frame.origin.y + commitButton.frame.size.height + 80);
    [self.view addSubview:self.scrollView];
}

- (void)commitPressed:(UIButton *)button {
    
    self.inputRequirements = [[NSMutableArray alloc] initWithCapacity:self.requirements.count];
    
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
    
    [SVProgressHUD showWithStatus:@"提交新增报名中" maskType:SVProgressHUDMaskTypeBlack];
    self.viewModel.activityId = self.activityId;
    self.viewModel.attributes = self.inputRequirements;
    
    [self.viewModel.addNewResponse start:YES success:^(id response, id model) {
        [SVProgressHUD showInfoWithStatus: [response objectForKey:@"message"]];
        [self performSelector:@selector(shutThisVC) withObject:nil afterDelay:1.5f];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showInfoWithStatus: [response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showInfoWithStatus: error.description];
    } ];
}

-(void)shutThisVC {
    [self.sucListVC refreshTableAfterAddNew];
    [self.navigationController popViewControllerAnimated:YES];
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
