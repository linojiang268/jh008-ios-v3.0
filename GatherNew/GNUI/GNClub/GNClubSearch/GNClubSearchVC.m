//
//  GNClubSearchVC.m
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubSearchVC.h"
#import "UIScrollView+XBRefreshExtension.h"

@interface GNClubSearchVC ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIBarButtonItem *searchItem;

@end

@implementation GNClubSearchVC

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypePop;
}

- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender {
    [self.textField resignFirstResponder];
    [self.textField removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    [super setupUI];
    
    self.searchItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:nil action:Nil];
    self.navigationItem.rightBarButtonItem = self.searchItem;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth - 100, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:GNUIFontSize14];
    textField.textColor = kUIColorWithHexUint(GNUIColorGrayBlack);
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    UIImageView *leftContentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_gray_black"]];
    CGRect r = leftContentView.frame;
    r.size.width += 10;
    UIView *leftView = [[UIView alloc] initWithFrame:r];
    [leftView addSubview:leftContentView];
    [leftContentView setCenter:leftView.center];
    
    textField.leftView = leftView;
    kUIRoundCorner(textField, [UIColor clearColor], 0, 3);
    
    self.textField = textField;
    self.navigationItem.titleView = textField;
}

- (void)binding {
    [super binding];
    
    __weakify;
    RAC(self.viewModel,keyword) = self.textField.rac_textSignal;
    self.searchItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        
        [self.tableView silentLoad];
        
        return [RACSignal empty];
    }];
}

@end
