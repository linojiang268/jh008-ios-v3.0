//
//  GNActivityMapLineCell.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/20.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityBaseCell.h"

@interface GNActivityMapLineCell : GNActivityBaseCell
@property (weak, nonatomic) IBOutlet UIButton *btnMapLine;
@property (strong, nonatomic) NSArray *arrayRoadmap;

- (IBAction)btnMapLineAction:(id)sender;
@end
