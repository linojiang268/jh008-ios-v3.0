//
//  GNActivityScoreStarLevelView.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNActivityScoreStarLevelView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewLine1;
@property (weak, nonatomic) IBOutlet UIView *viewLine2;
@property (weak, nonatomic) IBOutlet UIView *viewLine3;
@property (weak, nonatomic) IBOutlet UIView *viewLine4;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbActivityInfo;
@property (weak, nonatomic) IBOutlet UIView *viewSponsor;
@property (weak, nonatomic) IBOutlet UIView *viewActivityDetails;
@property (weak, nonatomic) IBOutlet UIView *viewPictures;

@property (weak, nonatomic) IBOutlet UILabel *lbName1;
@property (weak, nonatomic) IBOutlet UILabel *lbName2;
@property (weak, nonatomic) IBOutlet UILabel *lbName3;
@property (weak, nonatomic) IBOutlet UILabel *lbName4;

@end
