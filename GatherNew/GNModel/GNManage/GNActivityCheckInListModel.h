//
//  GNActivityCheckInListModel.h
//  GatherNew
//
//  Created by Culmore on 15/10/2.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNModelBase.h"

@interface GNActivityCheckInListModel : GNModelBase

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, strong) NSArray* checkins;

@end



@interface GNActivityCheckInModel : GNModelBase

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, assign) NSInteger check_by_user;
@property(nonatomic, strong) NSString* mobile;
@property(nonatomic, assign) NSInteger status;
@property(nonatomic, assign) NSInteger user_id;
@property(nonatomic, strong) NSString* name;

@end