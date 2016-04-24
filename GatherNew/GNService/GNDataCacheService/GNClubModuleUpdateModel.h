//
//  GNClubModuleUpdateModel.h
//  GatherNew
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GNClubModuleUpdateModel : NSManagedObject

@property (nonatomic) int64_t user_id;
@property (nonatomic) int64_t club_id;
@property (nonatomic) double activity_update_time;
@property (nonatomic) double member_update_time;
@property (nonatomic) double news_update_time;
@property (nonatomic) double album_update_time;
@property (nonatomic) double notice_update_time;

@end
