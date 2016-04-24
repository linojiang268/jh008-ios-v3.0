//
//  CustomOverlay.h
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-5-21.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CustomOverlay : BMKShape<BMKOverlay>
{
    @package
    BMKMapPoint *_points;
    NSInteger _pointCount;
    BMKMapRect _boundingMapRect;
}



@property (nonatomic, readonly) BMKMapRect boundingMapRect;
@property (nonatomic, readonly) BMKMapPoint* points;
@property (nonatomic, readonly) NSInteger pointCount;
-(id)initWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;

+ (CustomOverlay *)customWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;
@end
