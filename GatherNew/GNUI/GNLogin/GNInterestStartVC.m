//
//  GNInterestStartVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNInterestStartVC.h"

@implementation GNInterestStartVC

+(NSString *)sbIdentifier{
    return @"interestStart";
}

-(void)setupUI{
    
    [super setupUI];
    
    self.btnOK.layer.borderWidth = 2;
    self.btnOK.layer.borderColor =[kUIColorWithHexUint(GNUIColorWhite) CGColor];
    self.btnOK.layer.cornerRadius = 20;
    [self.btnOK setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden  = YES;
}

- (IBAction)btnReturnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
	