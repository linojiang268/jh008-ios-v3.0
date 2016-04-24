//
//  CustomPointAnnotation.h
//  Gather
//
//  Created by apple on 15/2/10.
//  Copyright (c) 2015年 zero2all. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CustomPointAnnotation : BMKPointAnnotation

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) NSString *image_Url;

@end
