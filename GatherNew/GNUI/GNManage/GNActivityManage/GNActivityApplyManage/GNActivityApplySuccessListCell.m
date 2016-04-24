//
//  GNActivityApplySuccessListCell.m
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplySuccessListCell.h"

@interface GNActivityApplySuccessListCell ()
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@property (nonatomic, assign) NSInteger item;
@property (nonatomic, copy) OnNoteClicked onNoteClicked;

@end

@implementation GNActivityApplySuccessListCell



- (void)setName:(NSString*)name phone:(NSString*)phone note:(NSString*)note fee:(NSInteger)fee item:(NSInteger)item OnNoteClicked:(OnNoteClicked)onNoteClicked {
    self.nameLabel.text = name;
    self.phoneNumLabel.text = phone;
    if(note != NULL && note != nil && [note length]){
        self.noteLabel.text = note;
    }else{
        self.noteLabel.text = @"无备注";
    }
    
    NSString* feeString = @"免费";
    if(fee > 0){
        self.feeLabel.hidden = NO;
        if(fee % 100 == 0){
            feeString = [NSString stringWithFormat:@"%ld元", (long)(fee/100)];
        }else{
            feeString = [NSString stringWithFormat:@"%.2f元", ((float)fee)/100.0];
        }
    }
    else{
        self.feeLabel.hidden = YES;
    }
    
    self.feeLabel.text = feeString;
    self.item = item;
    self.onNoteClicked = onNoteClicked;
}

- (void)call {
    if([self.phoneNumLabel.text length] > 0){
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumLabel.text]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.superview addSubview:callWebview];
    }
}

- (IBAction)onCallButtonClicked:(UIButton *)sender {
    [self call];
}


- (void)onClick {
    if(self.onNoteClicked){
        self.onNoteClicked(self.item);
    }
}


- (void)awakeFromNib {
    self.noteLabel.userInteractionEnabled = YES;
    self.noteImageView.userInteractionEnabled = YES;
    //self.phoneNumLabel.userInteractionEnabled = YES;
    [self.noteLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)]];
    [self.noteImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)]];
    //[self.phoneNumLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

@end
