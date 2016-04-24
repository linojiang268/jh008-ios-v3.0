//
//  GNActivityScoreVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreVC.h"
#import "GNActivityScoreStarLevelView.h"
#import "GNActivityScoreMessageView.h"
#import "GNActivityScoreVM.h"

@interface GNActivityScoreVC ()

@property (nonatomic, strong) GNActivityScoreVM *viewModelScore;

@property (nonatomic, strong) GNActivityScoreStarLevelView *scoreLevelView;
@property (nonatomic, strong) GNActivityScoreMessageView *scoreMessageView;
@property (nonatomic, assign) NSUInteger score;

@end

@implementation GNActivityScoreVC

+ (NSString *)sbIdentifier {
    return @"GNActivityScoreVC";
}

- (GNBackButtonType)backButtonType{
    return GNBackButtonTypeNone;
}

-(void)setupUI{
    [super setupUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:Nil];
    
    _scoreLevelView = [[GNActivityScoreStarLevelView alloc]init];
    _scoreLevelView.frame = self.viewContent.frame;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *date = [formatter dateFromString:self.activity.end_time];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    NSString *strDate = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)[dateComponent year],(long)[dateComponent month],(long)[dateComponent day]];
    _scoreLevelView.lbDate.text = strDate;
    _scoreLevelView.lbTitle.text = self.activity.title;
    
    _scoreMessageView = [[GNActivityScoreMessageView alloc]init];
    _scoreMessageView.frame = self.viewContent.frame;
    _scoreMessageView.txtContent.text = nil;
    [self initLevelView];
}

-(void)binding{
    
    self.viewModelScore = [[GNActivityScoreVM alloc]init];
    
    RAC(self.viewModelScore,activity) = RACObserve(self.activity, id);
    RAC(self.viewModelScore, score) = RACObserve(self, score);
    RAC(self.viewModelScore, attributes) = RACObserve(self.scoreMessageView, mutArray);
    RAC(self.viewModelScore,memo) = RACObserve(self.scoreMessageView.txtContent, text);

    self.btnOk.rac_command = self.viewModelScore.commitCommand;
    
    [self.viewModelScore.commitResponse start:NO success:^(id response, id model) {
        
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
    
    
}

- (IBAction)btnScoreAction:(id)sender {

    [self clearScore];
    UIButton *button = sender;
    switch (button.tag) {
        case 1:
            self.score = 1;
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self initMessageView];
            break;
        case 2:
            self.score = 2;
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self initMessageView];
            break;
        case 3:
            self.score = 3;
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self initMessageView];
            break;
        case 4:
            self.score = 4;
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore4 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self initLevelView];
            
            break;
        case 5:
            self.score = 5;
            [self.btnScore1 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore2 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore3 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore4 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self.btnScore5 setImage:[UIImage imageNamed:@"activity_Score_StarSelected"] forState:UIControlStateNormal];
            [self initLevelView];
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

-(void)initLevelView{
    [_scoreMessageView removeFromSuperview];
    [_scoreLevelView removeFromSuperview];
    
    _scoreLevelView.frame = self.viewContent.frame;
    [self.viewContent addSubview:_scoreLevelView];
}

-(void)initMessageView{
    [_scoreLevelView removeFromSuperview];
    [_scoreMessageView removeFromSuperview];
    
    _scoreMessageView.frame = self.viewContent.frame;
    [self.viewContent addSubview:_scoreMessageView];
}

@end
