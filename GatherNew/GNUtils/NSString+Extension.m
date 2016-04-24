//
//  NSString+Extention.m
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(Extension)

-(CGSize)mesure:(UIFont*)font{
    //设置一个行高上限
    //计算实际frame大小，并将label的frame变成实际大小
    CGRect rect = [self boundingRectWithSize:CGSizeMake(kUIScreenWidth*3/4, 100)
                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    return rect.size;
}


@end
