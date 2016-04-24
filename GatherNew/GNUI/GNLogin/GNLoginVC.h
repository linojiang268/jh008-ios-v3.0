//
//  GNLoginVC.h
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"

@interface GNLoginVC : GNLoginBaseVC

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *btn_ReturnPro;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdatePWD;

@property (assign,nonatomic) BOOL isHideReturn;

- (IBAction)btn_ReturnAction:(id)sender;
-(void)startLoginWithPhone:(NSString*)phone password:(NSString*)password;

@end
