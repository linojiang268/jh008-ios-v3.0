//
//  GNActivityApplyPayListCell.m
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplyPayListCell.h"

@interface GNActivityApplyPayListCell ()

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end


@implementation GNActivityApplyPayListCell


- (void)setName:(NSString*)name phone:(NSString*)phone fee:(NSInteger)fee item:(NSInteger)item OnDetailButtonClicked:(OnDetailButtonClicked) onDetailButtonClicked {
    self.nameLabel.text = name;
    self.phoneNumLabel.text = phone;
    NSString* feeString = @"免费";
    if(fee > 0){
        if(fee % 100 == 0){
            feeString = [NSString stringWithFormat:@"%ld元", (long)(fee/100)];
        }else{
            feeString = [NSString stringWithFormat:@"%.2f元", ((float)fee)/100.0];
        }
    }
    self.feeLabel.text = feeString;
    
    self.item = item;
    self.onDetailButtonClicked = onDetailButtonClicked;
}

- (IBAction)onCallButtonClicked:(UIButton *)sender {
    [self call];
 }


- (void)call {
    if([self.phoneNumLabel.text length] > 0){
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumLabel.text]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.superview addSubview:callWebview];
    }
}

- (void)awakeFromNib {
    self.feeLabel.hidden = YES;
    //self.phoneNumLabel.userInteractionEnabled = YES;
    //[self.phoneNumLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}



- (IBAction)onDetailButtonClicked:(UIButton*)sender {
    if(self.onDetailButtonClicked){
        self.onDetailButtonClicked(self.item);
    }
}




@end
