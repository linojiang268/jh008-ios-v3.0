//
//  GNActivityManageAddNewCell.m
//  GatherNew
//
//  Created by apple on 15/10/23.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManageAddNewCell.h"

@implementation GNActivityManageAddNewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
        self.inputView = [[UITextField alloc] initWithFrame:CGRectMake(frame.size.width/3, 0, frame.size.width/3*2, frame.size.height)];
        
        [self.titleView setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
        [self.inputView setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
        
        self.inputView.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
        
        [self addSubview:self.titleView];
        [self addSubview:self.inputView];
        
        self.backgroundColor = [UIColor greenColor];
    }
    
    return self;
}

-(void)setTitleText:(NSString *) title {
    
    self.titleView.text = title;
}

-(NSString *)getInputedValue {
    
    return self.inputView.text;
}

@end
