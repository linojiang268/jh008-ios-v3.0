//
//  GNActivityScoreStarLevelVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreStarLevelVC.h"
#import "GNActivityScoreMessageVC.h"


@interface GNActivityScoreStarLevelVC ()



@end



@implementation GNActivityScoreStarLevelVC

+ (NSString *)sbIdentifier {
    return @"GNActivityScoreStarLevel";
}

-(void)setupUI{
    [super setupUI];
    
    [self.viewLine1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.viewLine2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.viewLine3 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.viewLine4 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    [self.lbDate setTextColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.lbActivityInfo setTextColor:kUIColorWithHexUint(GNUIColorGray)];
    
    [self.lbTitle setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    
}

- (IBAction)btnScoreAction:(id)sender {
    
    [self clearScore];
    UIButton *button = sender;
    switch (button.tag) {
        case 1:
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore4 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            break;
        case 5:
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore4 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore5 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(void)clearScore{
    [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelect"] forState:UIControlStateNormal];
    [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelect"] forState:UIControlStateNormal];
    [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelect"] forState:UIControlStateNormal];
    [self.btnScore4 setImage:[UIImage imageNamed:@"activity_Score_StarSelect"] forState:UIControlStateNormal];
    [self.btnScore5 setImage:[UIImage imageNamed:@"activity_Score_StarSelect"] forState:UIControlStateNormal];
}

-(void)binding{
    
   
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"GNActivityScoreMessage"]) {
       // (GNActivityScoreMessageVC *)(segue.destinationViewController);
    }
    
}
@end
