//
//  GNInterestTagVC.h
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"

typedef void(^getInterestTag)(NSArray *array);

@interface GNInterestTagVC : GNLoginBaseVC

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (copy, nonatomic) getInterestTag getInterestTagValue;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNext;

- (IBAction)btnNextAction:(id)sender;
@property (nonatomic, strong) NSArray *arrayTags;


+ (instancetype)initPerfectInfoWithPhone:(NSString*)phone password:(NSString*)password;
@end
