//
//  GNMessageModel.h
//  GatherNew
//
//  Created by apple on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GNMessageModel : NSManagedObject

@property (nonatomic) int64_t activity_id;
@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * create_at;
@property (nonatomic) int64_t id;
@property (nonatomic) BOOL is_read;
/// 对应 GNMessageType
@property (nonatomic) int16_t message_type;
@property (nonatomic) int64_t team_id;
@property (nonatomic, retain) NSString * team_name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic) int64_t user_id;

@end
