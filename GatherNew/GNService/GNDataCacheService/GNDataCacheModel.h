//
//  GNDataCacheModel.h
//  GatherNew
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GNDataCacheModel : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic) int16_t page;

@end
