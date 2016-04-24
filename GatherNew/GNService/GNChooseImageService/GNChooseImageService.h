//
//  GNChooseImageService.h
//  GatherNew
//
//  Created by apple on 15/5/27.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GNChooseImageService : NSObject

+ (void)chooseImageWithController:(UIViewController *)controller finishedBlock:(void(^)(UIImage *image))block;

@end
