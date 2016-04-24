//
//  GNSignInCVC.m
//  GatherNew
//
//  Created by apple on 15/7/31.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNSignInCVC.h"

@interface GNSignInCVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GNSignInCVC

- (void)awakeFromNib {
    self.numberLabel.textColor = kUIColorWithHexUint(GNUIColorGreen);
    self.titleLabel.textColor = kUIColorWithHexUint(GNUIColorGreen);
}

@end
