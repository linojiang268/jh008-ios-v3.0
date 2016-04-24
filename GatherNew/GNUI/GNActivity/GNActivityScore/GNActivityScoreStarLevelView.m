//
//  GNActivityScoreStarLevelView.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreStarLevelView.h"

@implementation GNActivityScoreStarLevelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"GNActivityScoreStarLevelView" owner:nil options:nil];
        self = array[0];
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    self.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    
    [self.viewLine1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.viewLine2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.viewLine3 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.viewLine4 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    [self.lbDate setTextColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.lbActivityInfo setTextColor:kUIColorWithHexUint(GNUIColorGray)];
    
    [self.lbTitle setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    
    self.viewSponsor.layer.borderColor = [kUIColorWithHexUint(GNUIColorGreen) CGColor];
    self.viewSponsor.layer.borderWidth = 1;
    self.viewSponsor.layer.cornerRadius = self.viewSponsor.bounds.size.height/2;
    
    self.viewActivityDetails.layer.borderColor = [kUIColorWithHexUint(GNUIColorGreen) CGColor];
    self.viewActivityDetails.layer.borderWidth = 1;
    self.viewActivityDetails.layer.cornerRadius = self.viewActivityDetails.bounds.size.height/2;

    self.viewPictures.layer.borderColor = [kUIColorWithHexUint(GNUIColorGreen) CGColor];
    self.viewPictures.layer.borderWidth = 1;
    self.viewPictures.layer.cornerRadius  = self.viewPictures.bounds.size.height/2;
    
    self.lbName1.textColor = kUIColorWithHexUint(GNUIColorGreen);
    self.lbName2.textColor = kUIColorWithHexUint(GNUIColorGreen);
    self.lbName3.textColor = kUIColorWithHexUint(GNUIColorGreen);
    self.lbName4.textColor = kUIColorWithHexUint(GNUIColorGreen);
}

@end
