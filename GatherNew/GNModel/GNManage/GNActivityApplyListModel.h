//
//  GNActivityApplyModel.h
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GNModelBase.h"

@interface GNActivityApplyListModel : GNModelBase


@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pre_id;
@property (nonatomic, assign) NSInteger next_id;
@property (nonatomic, strong) NSArray *applicants;

@property (nonatomic, assign) NSInteger pages;
@end


@interface GNActivityApplyModel : GNModelBase
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger activity_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSArray * attrs;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger enroll_fee;
@property (nonatomic, strong) NSString * applicant_time;
@property (nonatomic, strong) NSString * remark;

- (void)setSelected:(BOOL) selected;
- (BOOL)getSelected;

@end



@interface GNActivityApplyAttrModel : GNModelBase

@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSString * value;


@end



