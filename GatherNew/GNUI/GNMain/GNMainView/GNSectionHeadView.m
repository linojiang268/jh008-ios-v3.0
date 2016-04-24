//
//  GNSectionHeadView.m
//  GatherNew
//
//  Created by yuanjun on 15/9/18.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNSectionHeadView.h"

@interface GNSectionHeadView()

@property (weak, nonatomic) IBOutlet UILabel *sectionName;
@property (weak, nonatomic) IBOutlet UIImageView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end

@implementation GNSectionHeadView




-(instancetype)initWithSectionName:(NSString*)name ShowMore:(BOOL)showMore OnSectionClicked:(OnSectionClicked) onSectionClicked
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"GNSectionHeadView" owner:self options:nil] firstObject];
    if (self) {
        self.onSectionClicked = onSectionClicked;
        self.moreView.hidden = !showMore;
        self.moreLabel.hidden = !showMore;
        self.sectionName.text = name;
        if(self.onSectionClicked){
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
            [self addGestureRecognizer:tapGesture];
        }
    }
    return self;
}

-(void)onClick{
    if(self.onSectionClicked){
        self.onSectionClicked(self);
    }
}


@end
