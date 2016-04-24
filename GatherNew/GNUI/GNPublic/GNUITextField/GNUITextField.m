//
//  GNUITextField.m
//  GatherNew
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNUITextField.h"

@implementation GNUITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x = 15;
    bounds.size.width -= 30;
    return bounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
