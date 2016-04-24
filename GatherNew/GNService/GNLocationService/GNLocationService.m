//
//  GNLocationService.m
//  GatherNew
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLocationService.h"
#import "GNNPSBase.h"
#import "GNNetworkService.h"

@implementation GNLocationService

+ (void)requestCurrentLocationWithBlock:(void(^)(CLLocation *location, INTULocationStatus status))block {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:5 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            DDLogInfo(@"获取地理位置成功");
            block(currentLocation,status);
        }else {
            DDLogError(@"GNLocation error status:%d",(int)status);
            block(nil,status);
        }
    }];
}

+ (void)requestPlacemarkWithBlock:(void(^)(CLPlacemark *placemark, GNCityModel *model, INTULocationStatus status))block {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:5 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                if (placemarks.count > 0) {

                    GNNPSBase *nps = [[GNNPSBase alloc] initWithURL:@"api/city/list"
                                                        parameters:nil
                                                  mappingModelClass:[GNCitiesModel class]];
                    [GNNetworkService GETWithService:nps success:^(id response, GNCitiesModel *model) {
                        
                        CLPlacemark *placemark = [placemarks firstObject];
                        NSString *location = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",location];
                        NSArray *filtered = [model.cities filteredArrayUsingPredicate:predicate];
                        
                        GNCityModel *oldCity = [GNApp userCity];
                        if (filtered.count > 0) {
                            DDLogInfo(@"位置匹配成功");
                            
                            GNCityModel *curCity = [filtered firstObject];
                            
                            if (oldCity && oldCity.id != curCity.id) {
                                block(placemark,curCity,kLSwitchNewCityCode);
                            }else {
                                block(placemark,curCity,status);
                            }
                        }else {
                            DDLogError(@"位置匹配失败");
                            if (oldCity) {
                                block(placemark,oldCity,INTULocationStatusSuccess);
                            }else {
                                block(placemark,nil,INTULocationStatusError);
                            }
                        }
                    } error:^(id response, NSInteger code) {
                        block(nil,nil,INTULocationStatusError);
                    } failure:^(id req, NSError *error) {
                        block(nil,nil,INTULocationStatusError);
                    }];
                }
                if (!error && placemarks.count == 0) {
                    DDLogError(@"反编码地理位置为空（失败）");
                    block(nil,nil,INTULocationStatusError);
                }
                if (error) {
                    DDLogError(@"反编码地理位置失败");
                    block(nil,nil,INTULocationStatusError);
                }
            }];
        }else {
            DDLogError(@"GNLocation error status:%d",(int)status);
            block(nil,nil,status);
        }
    }];
}

@end
