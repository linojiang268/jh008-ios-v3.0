//
//  GNApp.m
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNApp.h"
#import "GNPushSubscibeService.h"

@interface GNApp ()

@property (nonatomic, strong) CLLocation *location;

@end

@implementation GNApp

#pragma mark -

+ (NSString *)titleWithInterestId:(NSUInteger)interestId {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@(1) : @"运动户外",
                 @(2) : @"文化艺术",
                 @(3) : @"摄影旅行",
                 @(4) : @"音乐舞蹈",
                 @(5) : @"时尚生活",
                 @(6) : @"读书写作",
                 @(7) : @"美食",
                 @(8) : @"汽车",
                 @(9) : @"创业",
                 @(10) : @"公益",
                 @(11) : @"亲子",
                 @(12) : @"其他"};
    });
    if ([[dict allKeys] containsObject:@(interestId)]) {
        return [dict objectForKey:@(interestId)];
    }
    return @"";
}

+ (NSString *)interestImageNameWithInterestId:(NSUInteger)interestId {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@(1) : @"interest_exercise_outdoors",
                 @(2) : @"interest_culture_art",
                 @(3) : @"interest_photography_travel",
                 @(4) : @"interest_music_dance",
                 @(5) : @"interest_life",
                 @(6) : @"interest_reading_writing",
                 @(7) : @"interest_food",
                 @(8) : @"interest_car",
                 @(9) : @"interest_entrepreneurship",
                 @(10) : @"interest_public_welfare",
                 @(11) : @"interest_parents_children",
                 @(12) : @"interest_other"};
    });
    if ([[dict allKeys] containsObject:@(interestId)]) {
        return [dict objectForKey:@(interestId)];
    }
    return @"";
}

+ (UIImage *)imageWithInterestId:(NSUInteger)interestId {
    return [UIImage imageNamed:[self interestImageNameWithInterestId:interestId]];
}

+ (NSString *)interestImageNameWithInterestIdSelected:(NSUInteger)interestId {
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@(1) : @"interest_exercise_outdoorsSelected",
                 @(2) : @"interest_culture_artSelected",
                 @(3) : @"interest_photography_travelSelected",
                 @(4) : @"interest_music_danceSelected",
                 @(5) : @"interest_life_selected",
                 @(6) : @"interest_reading_writingSelected",
                 @(7) : @"interest_foodSelected",
                 @(8) : @"interest_car_selected",
                 @(9) : @"interest_entrepreneurshipSelected",
                 @(10) : @"interest_public_welfareSelected",
                 @(11) : @"interest_parents_childrenSelected",
                 @(12) : @"interest_otherSelected"};
    });
    if ([[dict allKeys] containsObject:@(interestId)]) {
        return [dict objectForKey:@(interestId)];
    }
    return @"";
}

+ (UIImage *)imageWithInterestIdSelected:(NSUInteger)interestId {
    return [UIImage imageNamed:[self interestImageNameWithInterestIdSelected:interestId]];
}

#pragma mark -

+ (BOOL)userIsLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"is_login"];
}

+ (void)userDidLogin {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)userLogout {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_login"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"msg_last_update_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -

+ (NSInteger)userId {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"user_id"];
}

+ (void)setUserId:(NSInteger)userId {
    [[NSUserDefaults standardUserDefaults] setInteger:userId forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




+ (BOOL)isTeamOwner {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"is_team_owner"];
}

+ (void)setTeamOwner:(BOOL) isTeamOwner{
    [[NSUserDefaults standardUserDefaults] setBool:isTeamOwner forKey:@"is_team_owner"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark -
+ (void)setUserMobile:(NSString *)mobile {
    [[NSUserDefaults standardUserDefaults] setValue:mobile forKey:@"user_mobile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userMobile {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"user_mobile"];
}

+ (void)setUserPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"user_password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userPassword {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"user_password"];
}


#pragma mark -

+ (GNCityModel *)userCity {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"user_city"]];
}

+ (void)switchUserCity:(GNCityModel *)model {
    [GNPushSubscibeService unsubscribeCity:[self userCity].id];
    [GNPushSubscibeService subscribeCity:model.id];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:model] forKey:@"user_city"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

+ (GNApp *)sharedApp {
    static GNApp *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GNApp alloc] init];
    });
    return shared;
}

+ (void)setUserLocation:(CLLocation *)location {
    [self sharedApp].location = location;
}

+ (CLLocation *)userLocation {
    return [self sharedApp].location;
}

+ (NSString *)distanceWithLon:(double)lon lat:(double)lat {
    
    if ([self sharedApp].location) {
        CLLocationCoordinate2D coor = [self sharedApp].location.coordinate;
        CLLocation *orig = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLLocation* dist = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
        
        CLLocationDistance kilometers = [orig distanceFromLocation:dist] / 1000;
        
        return [NSString stringWithFormat:@" %.2f千米",kilometers];
    }
    return @"";
}


#pragma mark -

+ (UIImage *)imageWithGender:(GNGender)gender {
    if (gender == GNGenderMale) {
        return [UIImage imageNamed:@"gender_male"];
    }
    if (gender == GNGenderFemale) {
        return [UIImage imageNamed:@"gender_female"];
    }
    return nil;
}

+ (UIColor *)colorWithGender:(GNGender)gender {
    if (gender == GNGenderMale) {
        return kUIColorWithHexUint(GNUIColorBlue);
    }
    if (gender == GNGenderFemale) {
        return kUIColorWithHexUint(GNUIColorOrange);
    }
    return kUIColorWithHexUint(GNUIColorGrayWhite);
}

#pragma mark -

+ (NSString *)ageFromDateString:(NSString *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *myDate = [formatter dateFromString:date];
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit fromDate:myDate toDate:nowDate options:0];
    
    NSInteger year = [comps year];
    if (year == 0) {
        year++;
    }
    
    return [NSString stringWithFormat:@"%ld岁",(long)year];
}

#pragma mark -

+ (NSString *)messageLastUpdateTime {
    NSString *time = [[NSUserDefaults standardUserDefaults] stringForKey:@"msg_last_update_time"];
    if (!time) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        time = [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:-(((60*60)*24)*7)]];
    }
    return time;
}

+ (void)setMessageLastUpdateTime:(NSString *)time {
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"msg_last_update_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
