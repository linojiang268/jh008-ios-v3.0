//
//  GNActivitiyApplyVerifyListCell.m
//  GatherNew
//
//  Created by Culmore on 15/10/3.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitiyApplyVerifyListCell.h"

@interface GNActivitiyApplyVerifyListCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *selectAreaView;


@end


@implementation GNActivitiyApplyVerifyListCell

- (void)setName:(NSString*)name phone:(NSString*)phone fee:(NSInteger)fee item:(NSInteger)item selected:(BOOL) selected  OnSelected:(OnSelected) onSelected OnDetailButtonClicked:(OnDetailButtonClicked) onDetailButtonClicked{
    self.nameLabel.text = name;
    self.phoneLabel.text = phone;
    NSString* feeString = @"免费";
    if(fee > 0){
        if(fee % 100 == 0){
            feeString = [NSString stringWithFormat:@"%ld元", (long)(fee/100)];
        }else{
            feeString = [NSString stringWithFormat:@"%.2f元", ((float)fee)/100.0];
        }
    }
    self.item = item;
    self.selectButton.selected = selected;
    self.onSelected = onSelected;
    self.onDetailButtonClicked = onDetailButtonClicked;
}

-(void)onSelect{
    self.selectButton.selected = !self.selectButton.selected;
    if(self.onSelected){
        self.onSelected(self.item, self.selectButton.selected);
    }
}

- (IBAction)selectButtonClicked:(UIButton *)sender {
    [self onSelect];
}


- (void)call {
    if([self.phoneLabel.text length] > 0){
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneLabel.text]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.superview addSubview:callWebview];
    }
}

- (void)awakeFromNib {
    [self.selectButton setImage:[UIImage imageNamed:@"manage_unchecked"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"manage_checked"] forState:UIControlStateSelected];
    [self.selectButton setSelected:NO];
    
    self.phoneLabel.userInteractionEnabled = YES;
    [self.phoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)]];
    
    self.selectAreaView.userInteractionEnabled = YES;
    [self.selectAreaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelect)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

- (IBAction)onDetailButtonClicked:(UIButton *)sender {
    if(self.onDetailButtonClicked){
        self.onDetailButtonClicked(self.item);
    }
}
@end
