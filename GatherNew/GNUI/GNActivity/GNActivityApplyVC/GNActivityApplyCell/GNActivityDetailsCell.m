//
//  GNActivityDetailsCell.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityDetailsCell.h"
#import "GNActivityDetailsModel.h"
#import "NSString+GNExtension.h"

@interface GNActivityDetailsCell ()

@property (weak, nonatomic) IBOutlet UIView *view_Line;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;


@end

@implementation GNActivityDetailsCell


- (void)awakeFromNib {
    self.lineViewHeight.constant = 0.5;
}


-(void)bindingModel:(id)model{
    GNActivityDetailsModel *detailsModel = model;
    [self.lbTitle setTextColor:kUIColorWithHexUint(GNUIColorDarkgray)];
    [self.view_Line setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
  
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[detailsModel.activity.detail  dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.lbContent.attributedText = attrStr;
}

@end
