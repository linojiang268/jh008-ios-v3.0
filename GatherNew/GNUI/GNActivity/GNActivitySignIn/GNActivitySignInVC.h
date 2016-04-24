//
//  GNActivitySignInVC.h
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVCBase.h"
#import "GNActivitySignInVM.h"

@interface GNActivitySignInVC : GNVCBase

- (instancetype)initWithSigninURL:(NSString *)url
                          success:(void(^)(GNActivitySignInModel *model))success
                  noApplyCallback:(void(^)(void))noApplyCallback
               stepsErrorCallback:(void(^)(void))stepsErrorCallback
                     backCallback:(void(^)(void))callback;


@end
