//
//  NSString+GNExtension.m
//  GatherNew
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "NSString+GNExtension.h"

@implementation NSString (GNExtension)

+ (BOOL)isBlank:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (NSString *)substringYearMonthDay {
    return [self substringToIndex:10];
}

@end
