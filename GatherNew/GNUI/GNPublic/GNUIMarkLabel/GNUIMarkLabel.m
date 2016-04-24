//
//  GNUIMarkLabel.m
//  GatherNew
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNUIMarkLabel.h"

@implementation GNUIMarkLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = kUIColorWithHexUint(GNUIColorBlue).CGColor;
        self.layer.cornerRadius = 1.0;
        self.textColor = kUIColorWithHexUint(GNUIColorBlue);
        self.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(2, 2, 2, 2))];
}

@end
