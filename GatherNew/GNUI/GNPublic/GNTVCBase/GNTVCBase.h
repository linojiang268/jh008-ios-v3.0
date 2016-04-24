//
//  GNTVCBase.h
//  GatherNew
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNModelBase.h"
#import "UIView+GNExtension.h"
#import "UIImageView+GNExtension.h"

@interface GNTVCBase : UITableViewCell

@property (nonatomic, strong) id model;

- (void)bindingModel:(id)model;

@end
