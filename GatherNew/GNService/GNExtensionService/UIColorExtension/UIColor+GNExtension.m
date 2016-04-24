//
//  UIColor+GNExtension.m
//  GatherNew
//
//  Created by yuanjun on 15/9/19.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "UIColor+GNExtension.h"

@implementation UIColor (GNExtension)

+(UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
