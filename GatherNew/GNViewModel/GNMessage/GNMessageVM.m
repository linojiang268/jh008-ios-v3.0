//
//  GNClubMessageVM.m
//  GatherNew
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMessageVM.h"
#import "GNPrivateMessageModel.h"
#import <CoreData+MagicalRecord.h>
#import "GNMessageService.h"

@interface GNMessageVM ()

@property (nonatomic, assign) GNMessageType type;

@end

@implementation GNMessageVM

- (instancetype)initWithType:(GNMessageType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)initModel {
    
    self.messageArray = [[NSMutableArray alloc] init];
    
    __weakify;
    self.refreshResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"/api/message/list"
                                             parameters:@{@"type": kNumber(self.type),
                                                          @"last_requested_time": [GNApp messageLastUpdateTime]}
                                      mappingModelClass:[GNPrivateMessageListModel class]];
        [GNNetworkService GETWithService:nps success:^(id response, GNPrivateMessageListModel *model) {
            [GNApp setMessageLastUpdateTime:model.last_requested_time];
            if (model.messages.count > 0) {
                [GNMessageService setHaveUpdate:YES];
                NSUInteger count = model.messages.count;
                for (int i=0;i<count;i++) {
                    
                    GNPrivateMessageModel *item = [model.messages objectAtIndex:i];
                    NSArray *olds = [GNMessageModel MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"id==%d and user_id == %d",item.id,kUserId]];
                    if (olds.count == 0) {
                        GNMessageModel *msg = [GNMessageModel MR_createEntity];
                        msg.id = item.id;
                        msg.team_name = item.team_name;
                        msg.content = item.content;
                        msg.create_at = item.created_at;
                        msg.attribute = [item.attributes JSONString];
                        msg.type = item.type;
                        msg.is_read = NO;
                        msg.message_type = self.type;
                        msg.user_id = kUserId;
                        if ([item.type isEqualToString:@"url"] && [[item.attributes allKeys] containsObject:@"url"]) {
                            msg.url = [item.attributes objectForKey:@"url"];
                        }else if ([item.type isEqualToString:@"activity"] && [[item.attributes allKeys] containsObject:@"activity_id"]) {
                            msg.activity_id = [[item.attributes objectForKey:@"activity_id"] unsignedIntegerValue];
                        }else if ([item.type isEqualToString:@"team"] && [[item.attributes allKeys] containsObject:@"team_id"]) {
                            msg.team_id = [[item.attributes objectForKey:@"team_id"] unsignedIntegerValue];;
                        }
                        
                        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                            if ((i+1) == count) {
                                [self getMessage];
                            }
                        }];
                    }
                    if ((i+1) == count) {
                        [self getMessage];
                    }
                }
            }else {
                [self getMessage];
            }
        } error:^(id response, NSInteger code) {
            [self getMessage];
        } failure:^(id req, NSError *error) {
            [self getMessage];
        }];
    }];
}

- (void)getMessage {
    NSArray *messages = [GNMessageModel MR_findAllSortedBy:@"create_at" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"message_type == %d and user_id == %d",self.type, kUserId]];
    [self.messageArray setArray:messages];
    self.refreshResponse.success(messages, messages);
}

- (NSString *)badgeValue {
    NSArray *unreads = [GNMessageModel MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"is_read == NO and user_id == %d",kUserId]];
    if (unreads.count > 0) {
        return @"";
    }
    return nil;
}


















@end
