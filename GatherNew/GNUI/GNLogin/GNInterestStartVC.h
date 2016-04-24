//
//  GNInterestStartVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/7.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"

@interface GNInterestStartVC : GNLoginBaseVC
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

- (IBAction)btnReturnAction:(id)sender;
@end
