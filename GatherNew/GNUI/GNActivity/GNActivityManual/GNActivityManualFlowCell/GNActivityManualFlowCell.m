//
//  GNActivityManualFlowCell.m
//  GatherNew
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualFlowCell.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityManualFlowCell ()

@property (weak, nonatomic) IBOutlet UIView *noFlowView;
@property (weak, nonatomic) IBOutlet UIImageView *signedImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noSignedTop;

@end

@implementation GNActivityManualFlowCell

- (void)awakeFromNib {
    self.flowLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindingModel:(id)model {
    [super bindingModel:model];
    
    GNActivityDetailsModel *manual = model;
    
    if (manual.activity.activity_check_in_list.count > 0) {
        self.signedNumerLabel.hidden = NO;
        self.signedImageView.hidden = NO;
        NSArray *tempArray = [[manual.activity.activity_check_in_list reverseObjectEnumerator] allObjects];
        BOOL isSigned = NO;
        for (GNActivitySignInItemModel *item in tempArray) {
            if (item.status == 1) {
                isSigned = YES;
                self.signedNumerLabel.text = [kNumber(item.step) stringValue];
                self.signedImageView.highlighted = YES;
                self.noSignedTop.constant = 2;
                break;
            }
        }
        
        if (!isSigned) {
            self.signedNumerLabel.hidden = YES;
            self.signedImageView.highlighted = isSigned;
            self.noSignedTop.constant = -21;
        }
        
    }else {
        self.signedNumerLabel.hidden = YES;
        self.signedImageView.hidden = YES;
    }
    
    if (manual.activity.activity_plans.count > 0) {
        NSMutableAttributedString *flow = [[NSMutableAttributedString alloc] init];
        
        NSMutableParagraphStyle *titleStyle = [[NSMutableParagraphStyle alloc] init];
        titleStyle.alignment = NSTextAlignmentCenter;
        titleStyle.paragraphSpacing = 20;
        
        NSMutableParagraphStyle *itemStyle = [[NSMutableParagraphStyle alloc] init];
        itemStyle.firstLineHeadIndent = 0;
        itemStyle.headIndent = 89;
        itemStyle.lineSpacing = 8;
        itemStyle.paragraphSpacing = 3;
        
        NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                          NSUnderlineStyleAttributeName: kNumber(NSUnderlineStyleSingle),
                                          NSUnderlineColorAttributeName: kUIColorWithHexUint(GNUIColorGray),
                                          NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorBlack),
                                          NSParagraphStyleAttributeName: titleStyle};
        
        NSDictionary *itemAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                         NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorBlack),
                                         NSParagraphStyleAttributeName: itemStyle};
        
        NSString *title = @"";
        NSString *date = @"";
        for (int i = 0;i < manual.activity.activity_plans.count;i++) {
            
            GNActivityFlowModel *item = [manual.activity.activity_plans objectAtIndex:i];
            
            NSString *beginTime = [item.begin_time substringToIndex:10];
            if (![date isEqualToString:beginTime]) {
                title = [[beginTime substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
                title = [title stringByAppendingString:@"日\n"];
                [flow appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:titleAttributes]];
                date = beginTime;
            }
            
            NSString *content = [NSString stringWithFormat:@"%@-%@ : %@\n",[item.begin_time substringWithRange:NSMakeRange(11, 5)],[item.end_time substringWithRange:NSMakeRange(11, 5)],item.plan_text];
            
            NSUInteger nextPlanIndex = i + 1;
            if (nextPlanIndex < manual.activity.activity_plans.count) {
                GNActivityFlowModel *nextItem = [manual.activity.activity_plans objectAtIndex:nextPlanIndex];
                if (![[nextItem.begin_time substringToIndex:10] isEqualToString:beginTime]) {
                    
                    NSMutableDictionary *lastItemAttribute = [[NSMutableDictionary alloc] initWithDictionary:itemAttributes];
                    [lastItemAttribute removeObjectForKey:NSParagraphStyleAttributeName];
                    
                    NSMutableParagraphStyle *itemStyle = [[NSMutableParagraphStyle alloc] init];
                    itemStyle.firstLineHeadIndent = 0;
                    itemStyle.headIndent = 89;
                    itemStyle.lineSpacing = 3;
                    itemStyle.paragraphSpacing = 20;
                    
                    [lastItemAttribute setObject:itemStyle forKey:NSParagraphStyleAttributeName];
                    [flow appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:lastItemAttribute]];
                    
                    continue;
                }
            }
            [flow appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:itemAttributes]];
            
            
            /// 这里有bug 需要多加一行，否则最后一个显示不出来
            if (i == (manual.activity.activity_plans.count-1)) {
                [flow appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:itemAttributes]];
            }
        }
        
        self.flowLabel.attributedText = flow;
        
        self.flowLabel.hidden = NO;
        self.noFlowView.hidden = YES;
    }else {
        self.flowLabel.hidden = YES;
        self.noFlowView.hidden = NO;
    }
}

- (void)hideSignInView {
    self.signedNumerLabel.hidden = YES;
    self.signedImageView.hidden = YES;
}

- (CGFloat)cellHeight {
    return ([self.flowLabel.attributedText boundingRectWithSize:CGSizeMake(kUIScreenWidth - 45, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine context:nil].size.height + 38);
}

@end
