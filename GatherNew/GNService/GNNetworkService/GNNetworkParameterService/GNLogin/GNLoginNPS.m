//
//  GNLoginNPS.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginNPS.h"

@implementation GNLoginNPS

+ (instancetype)NPSWithPhoneNumber:(NSString *)phoneNumber
                          password:(NSString *)password
{
    GNLoginNPS *nps =[[GNLoginNPS alloc] initWithURL:@"/api/login" requestType:GNNetworkRequestTypeRequestAfterCache mappingModelClass:NSClassFromString(@"GNPerfectInfoModel") localCacheIdentifier:@"user_info"];
    nps.phoneNumber = phoneNumber;
    nps.password = password;
    
    return nps;
}

- (void)assemblyParameters {
    self.parameters = [NSMutableDictionary dictionary];
    [self.parameters setObject:@"true" forKey:@"remember"];
    [self.parameters setObject:self.phoneNumber forKey:@"mobile"];
    [self.parameters setObject:self.password forKey:@"password"];
    [self.parameters setObject:[self createSign:self.parameters] forKey:@"sign"];
}

@end
