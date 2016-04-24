//
//  UIImageView+GNExtension.m
//  GatherNew
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "UIImageView+GNExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (GNExtension)

#pragma mark -

- (void)setImageWithURL:(NSURL *)URL {
    [self sd_setImageWithURL:URL];
}

- (void)setImageWithURLString:(NSString *)URLString {
    [self sd_setImageWithURL:[NSURL URLWithString:URLString]];
}

#pragma mark -

- (void)setClubLogoImageWithURL:(NSURL *)URL {
    [self sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_club_logo"]];
}

- (void)setClubLogoImageWithURLString:(NSString *)URLString {
    [self sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:@"default_club_logo"]];
}

#pragma mark -

- (void)setUserAvatarImageWithURL:(NSURL *)URL {
    [self sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
}

- (void)setUserAvatarImageWithURLString:(NSString *)URLString {
    [self sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
}

@end
