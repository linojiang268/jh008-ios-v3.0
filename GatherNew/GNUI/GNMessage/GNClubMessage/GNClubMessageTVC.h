//
//  GNClubMessageTVC.h
//  GatherNew
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNTVCBase.h"

@interface GNClubMessageTVC : GNTVCBase

- (void)setReadState:(BOOL)read;

- (void)deleteWithCallback:(void(^)(id model))callback;

@end
