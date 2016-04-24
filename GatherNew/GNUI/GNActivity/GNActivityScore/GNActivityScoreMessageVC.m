//
//  GNActivityScoreMessageVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityScoreMessageVC.h"

@interface GNActivityScoreMessageVC ()

@end

@implementation GNActivityScoreMessageVC

+ (NSString *)sbIdentifier {
    return @"GNActivityScoreMessage";
}

-(void)setupUI{
    [super setupUI];

    [self setButton:self.btnTraffic];
    [self setButton:self.btnSignin];
    [self setButton:self.btnActivityOrder];
    [self setButton:self.btnActivityExperience];
    [self setButton:self.btnHaveDinner];
    [self setButton:self.btnOther];
    
}

-(void)setButton:(UIButton *)button{
    button.layer.borderColor =[kUIColorWithHexUint(GNUIColorGray) CGColor];
    button.layer.borderWidth = 1;
    [button setTitleColor:kUIColorWithHexUint(GNUIColorGrayBlack) forState:UIControlStateNormal];
    [button setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self colorToImage:kUIColorWithHexUint(GNUIColorGrayBlack)] forState:UIControlStateHighlighted];
}


-(UIImage *)colorToImage:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
