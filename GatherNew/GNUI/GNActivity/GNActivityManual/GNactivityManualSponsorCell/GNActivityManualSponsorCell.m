//
//  GNactivityManualSponsorCell.m
//  GatherNew
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualSponsorCell.h"
#import "GNActivityDetailsModel.h"

@interface GNActivityManualSponsorCell ()

@property (weak, nonatomic) IBOutlet UILabel *sponsorLabel;

@end

@implementation GNActivityManualSponsorCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindingModel:(id)model {
    [super bindingModel:model];
    
    GNActivityDetailsModel *manual = model;
    
    NSMutableAttributedString *sponsor = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineSpacing = 8;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: style,
                                 NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorDarkgray)};
    
    if (manual.activity.organizers.count > 0) {
        
        int i = 0;
        for (NSString *s in manual.activity.organizers) {
            if (i==(manual.activity.organizers.count - 1)) {
                [sponsor appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",s] attributes:attributes]];
            }else {
                [sponsor appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",s] attributes:attributes]];
            }
            i += 1;
        }
        self.sponsorLabel.attributedText = sponsor;
        
    }else if(manual) {
        [sponsor appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",manual.activity.team.name] attributes:attributes]];
        self.sponsorLabel.attributedText = sponsor;
    }
}

- (CGFloat)cellHeight {
    
    self.sponsorLabel.backgroundColor = [UIColor blackColor];
    
    UITextView *text = [[UITextView alloc] init];
    text.attributedText = self.sponsorLabel.attributedText;
    
    CGSize size = [text sizeThatFits:CGSizeMake(kUIScreenWidth-30, CGFLOAT_MAX)];
    size.height += 40;

    return size.height;
}

@end
