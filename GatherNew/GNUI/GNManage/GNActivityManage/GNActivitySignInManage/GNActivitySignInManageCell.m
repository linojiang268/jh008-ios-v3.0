//
//  GNActivitySignInManageCell.m
//  GatherNew
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySignInManageCell.h"
#import "GNActivityCheckInListModel.h"

@interface GNActivitySignInManageCell ()

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;

@property (nonatomic, strong) GNActivityCheckInModel* who;
@property (nonatomic, copy) void(^onCheckInClick)(GNActivityCheckInModel *who);

@end


@implementation GNActivitySignInManageCell


- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    
    self.nameLabel.text = @"";
    self.numberLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)bindingModel:(GNActivityCheckInModel*)model subStatus:(NSUInteger)subStatus OnCheckInClick:(void(^)(GNActivityCheckInModel * who))onCheckInClick {
    self.who = (GNActivityCheckInModel*)model;
    self.nameLabel.text = self.who.name;
    self.numberLabel.text = self.who.mobile;
    self.onCheckInClick = onCheckInClick;
    
    if(subStatus < 5) {
        if (self.who.status == 0) { // 未签到
            [self.checkInButton setImage:[UIImage imageNamed:@"manage_manual_check_in"] forState:UIControlStateNormal];
            [self.checkInButton setImage:[UIImage imageNamed:@"manage_manual_check_in_pressed"] forState:UIControlStateHighlighted];
            self.checkInButton.hidden = false;
        } else { // 已签到
            if(self.who.check_by_user == 1) { //  用户自己签到
                self.checkInButton.hidden = true;
            } else {
                [self.checkInButton setImage:[UIImage imageNamed:@"manage_manual_not_check_in"] forState:UIControlStateNormal];
                [self.checkInButton setImage:[UIImage imageNamed:@"manage_manual_not_check_in_pressed"] forState:UIControlStateHighlighted];
                self.checkInButton.hidden = false;
            }
        }
    }
    else {
        self.checkInButton.hidden = true;
    }
}


- (IBAction)onCallButtonClicked:(id)sender {
    UIWebView *webview =[[UIWebView alloc] init];
    NSString *url = [NSString stringWithFormat:@"tel:%@", self.who.mobile];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self addSubview:webview];
}


- (IBAction)onCheckInButtonClicked:(id)sender {
    if(self.onCheckInClick){
        self.onCheckInClick(self.who);
    }
}





@end
