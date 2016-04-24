//
//  GNLocationService.h
//  GatherNew
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "INTULocationManager.h"

#define kLSwitchNewCityCode 65
#define kLSGetCitiesErrorCode 66
#define kLSNoMatchingCityErrorCode 67
#define kLSReverseGeocodeLocationErrorCode 68

@interface GNLocationService : INTULocationManager

+ (void)requestCurrentLocationWithBlock:(void(^)(CLLocation *location, INTULocationStatus status))block;
+ (void)requestPlacemarkWithBlock:(void(^)(CLPlacemark *placemark, GNCityModel *city, INTULocationStatus status))block;

@end
