//
//  GNInterestTagCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNInterestTagCell.h"
#import "GNApp.h"

@implementation GNInterestTagCell

-(void)isSelected:(BOOL)flag selectedId:(NSInteger)sId{
    
    self.lbName.text = [GNApp titleWithInterestId:sId];
    [self.imageIsSelected setImage:[UIImage imageNamed:@"interest_tag_selected"]];

    if (flag) {//选中
        
        switch (sId) {
            case 1:
            case 6:
            case 11:
                [self setBackgroundColor:kUIColorWithHexUint(GNUIColorOrange)];
                break;
            case 2:
            case 7:
            case 12:
                [self setBackgroundColor:kUIColorWithHexUint(GNUIColorYellow)];
                break;
            case 3:
            case 8:
                [self setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen)];
                break;
            case 4:
            case 9:
                [self setBackgroundColor:kUIColorWithHexUint(GNUIColorBlue)];
                break;
            case 5:
            case 10:
                [self setBackgroundColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
                break;
            default:
                [self setBackgroundColor:kUIColorWithHexUint(GNUIColorBlue)];
                break;
        }
        
        [self.imageInteresetTag setImage:[GNApp imageWithInterestIdSelected:sId]];
        self.imageIsSelected.hidden = NO;
        [self.lbName setTextColor:kUIColorWithHexUint(GNUIColorWhite)];
    }else{
        [self setBackgroundColor:kUIColorWithHexUint(GNUIColorPlaceholder)];
        [self.imageInteresetTag setImage:[GNApp imageWithInterestId:sId]];
        self.imageIsSelected.hidden = YES;
        [self.lbName setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    }
}
@end
