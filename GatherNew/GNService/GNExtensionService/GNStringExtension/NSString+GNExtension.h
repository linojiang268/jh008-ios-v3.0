//
//  NSString+GNExtension.h
//  GatherNew
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (GNExtension)

+ (BOOL)isBlank:(NSString *)string;

- (NSString *)substringYearMonthDay;

@end
