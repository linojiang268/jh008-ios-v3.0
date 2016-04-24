//
//  GNActivityScoreMessageView.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNActivityScoreMessageView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnTraffic;
@property (weak, nonatomic) IBOutlet UIButton *btnSignin;
@property (weak, nonatomic) IBOutlet UIButton *btnActivityOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnActivityExperience;
@property (weak, nonatomic) IBOutlet UIButton *btnHaveDinner;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;

@property (weak, nonatomic) IBOutlet UITextView *txtContent;

@property (strong, nonatomic) NSMutableArray *mutArray;

- (IBAction)btnScoreAction:(id)sender;

@end
