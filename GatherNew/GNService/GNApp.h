//
//  GNApp.h
//  GatherNew
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "AppDelegate.h"
#import "GNCityModel.h"

#define kApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kUserCityID [GNApp userCity].id
#define kUserId [GNApp userId]
#define kNumber(number) @(number)

@interface GNApp : NSObject

#pragma mark -

+ (NSString *)titleWithInterestId:(NSUInteger)interestId;
+ (UIImage *)imageWithInterestId:(NSUInteger)interestId;
+ (UIImage *)imageWithInterestIdSelected:(NSUInteger)interestId;
#pragma mark -

+ (BOOL)userIsLogin;
+ (void)userDidLogin;
+ (void)userLogout;

#pragma mark -

+ (NSInteger)userId;
+ (void)setUserId:(NSInteger)userId;

#pragma mark -
+ (void)setUserMobile:(NSString *)mobile;
+ (NSString *)userMobile;



+ (void)setUserPassword:(NSString *)password;
+ (NSString *)userPassword;

#pragma mark -

+ (GNCityModel *)userCity;
+ (void)switchUserCity:(GNCityModel *)model;

#pragma mark -

+ (void)setUserLocation:(CLLocation *)location;
+ (CLLocation *)userLocation;
+ (NSString *)distanceWithLon:(double)lon lat:(double)lat;

#pragma mark -

+ (UIImage *)imageWithGender:(GNGender)gender;
+ (UIColor *)colorWithGender:(GNGender)gender;

#pragma mark -

+ (NSString *)ageFromDateString:(NSString *)date;

#pragma mark -

+ (NSString *)messageLastUpdateTime;
+ (void)setMessageLastUpdateTime:(NSString *)time;



+ (BOOL)isTeamOwner;
+ (void)setTeamOwner:(BOOL) isTeamOwner;

@end
