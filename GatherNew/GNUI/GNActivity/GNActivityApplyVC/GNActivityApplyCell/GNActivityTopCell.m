//
//  GNGNActivityTopCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityTopCell.h"
#import "BannerView.h"
#import "GNActivityDetailsModel.h"
#import "NSString+GNExtension.h"

@interface GNActivityTopCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfImages;
@property (weak, nonatomic) IBOutlet UILabel *enrolledMembers;


@property (strong, nonatomic) NSArray* arrayLocation;

@end


@implementation GNActivityTopCell

- (void)awakeFromNib {
    self.imageMain.layer.masksToBounds = YES;
}

-(void)bindingModel:(id)model{
    
    GNActivityDetailsModel *detailsModel = model;
    self.arrayLocation = detailsModel.activity.location;
    
    self.lbTitle.textColor = kUIColorWithHexUint(GNUIColorBlack);
    self.lbTitle.font = [UIFont systemFontOfSize:16];
    self.lbTitle.text = detailsModel.activity.title;
    self.lineViewHeight.constant = 0.5;
    [self.lineView setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    if (![NSString isBlank:[detailsModel.activity.images_url firstObject]]) {
        [self.imageMain setImageWithURLString:[detailsModel.activity.images_url firstObject]];
    }
    
    
    NSInteger images  = [detailsModel.activity.images_url count];
    if(images > 1){
        self.viewMain.backgroundColor = kUIColorWithHexUint(GNUIColorDarkgray);
        self.viewMain.layer.masksToBounds = YES;
        self.viewMain.layer.cornerRadius = self.viewMain.bounds.size.width/2;
        self.viewMain.alpha = 0.7;
        self.numberOfImages.text = [NSString stringWithFormat:@"%ld", (long)images];
        self.numberOfImages.textColor = kUIColorWithHexUint(GNUIColorBlack);
        self.viewMain.hidden = NO;
    }
    else{
        self.viewMain.hidden = YES;
    }
    
    self.enrolledMembers.text = [NSString stringWithFormat:@"报名：%ld人", (long)detailsModel.activity.enrolled_num];
    self.enrolledMembers.textColor = kUIColorWithHexUint(GNUIColorOrange);
    
    UITapGestureRecognizer *tapGestShowMembers = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMembers)];
    [self.enrolledMembers addGestureRecognizer:tapGestShowMembers];
    [self.enrolledMembers setUserInteractionEnabled:YES];
    
    
    UITapGestureRecognizer *tapGestShowPicture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture)];
    [self.imageMain addGestureRecognizer:tapGestShowPicture];
    [self.imageMain setUserInteractionEnabled:YES];
    
    
}


-(void)showPicture{
    
    if ([self.delegate respondsToSelector:@selector(showActivityPicture:)]) {
        [self.delegate showActivityPicture:nil];
    }
}


-(void)showLocations{
    if ([self.delegate respondsToSelector:@selector(intoMapShowLocaton:)]) {
        [self.delegate intoMapShowLocaton:self.arrayLocation];
    }
}

-(void)showMembers{
    if ([self.delegate respondsToSelector:@selector(showActivityMembers:)]) {
        [self.delegate showActivityMembers:self.arrayLocation];
    }
}

@end
