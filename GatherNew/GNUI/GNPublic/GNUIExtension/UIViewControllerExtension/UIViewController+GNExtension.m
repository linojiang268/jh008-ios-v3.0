//
//  UIViewController+GNExtension.m
//  GatherNew
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "UIViewController+GNExtension.h"

@implementation GNUI

+ (GNUI *)loginUI {
    return (GNUI *)[GNUI storyboardWithName:@"GNLoginUI" bundle:nil];
}

+ (GNUI *)meUI {
    return (GNUI *)[UIStoryboard storyboardWithName:@"GNMeUI" bundle:nil];
}
+ (GNUI *)clubUI {
    return (GNUI *)[[self class] storyboardWithName:@"GNClubUI" bundle:nil];
}

+ (GNUI *)publicUI {
    return (GNUI *)[[self class] storyboardWithName:@"GNPublicUI" bundle:nil];
}

@end

@implementation UIViewController (GNExtension)

+ (UIStoryboard *)storyboard {
    NSAssert(0, @"Please Override");
    return nil;
}

+ (NSString *)sbIdentifier {
    NSAssert(0, @"Please Override");
    return nil;
}

+ (instancetype)loadFromStoryboard {
    return [[self storyboard] instantiateViewControllerWithIdentifier:[self sbIdentifier]];
}

+ (instancetype)loadFromStoryboardWithSbIdentifier:(NSString *)sbIdentifier {
   return [[self storyboard] instantiateViewControllerWithIdentifier:sbIdentifier];
}

+ (instancetype)loadFromGNUI:(GNUI *)GNUI {
    return [GNUI instantiateViewControllerWithIdentifier:[self sbIdentifier]];
}

@end
