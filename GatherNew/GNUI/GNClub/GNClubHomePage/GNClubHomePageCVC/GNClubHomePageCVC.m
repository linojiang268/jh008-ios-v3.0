//
//  GNClubHomePageCVC.m
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubHomePageCVC.h"

@interface GNClubHomePageCVC ()

@property (weak, nonatomic) IBOutlet UIImageView *redPointView;

@end

@implementation GNClubHomePageCVC

- (void)awakeFromNib {
    
    self.titleLabel.textColor = kUIColorWithHexUint(GNUIColorBlack);
    
    [self setIsUpdated:NO];
}

- (void)setIsUpdated:(BOOL)updated {
    self.redPointView.hidden = !updated;
}

@end
