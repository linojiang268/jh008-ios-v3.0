//
//  UIImageView+GNExtension.h
//  GatherNew
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GNExtension)

- (void)setImageWithURL:(NSURL *)URL;
- (void)setImageWithURLString:(NSString *)URLString;

- (void)setClubLogoImageWithURL:(NSURL *)URL;
- (void)setClubLogoImageWithURLString:(NSString *)URLString;

- (void)setUserAvatarImageWithURL:(NSURL *)URL;
- (void)setUserAvatarImageWithURLString:(NSString *)URLString;

@end
