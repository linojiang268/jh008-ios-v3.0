//
//  GNMyPerfectInfoVC.h
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"

@interface GNMyPerfectInfoVC : GNLoginBaseVC
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;

@property (weak, nonatomic) IBOutlet UIImageView *image_headerPic;
@property (weak, nonatomic) IBOutlet UITextField *txt_PhoneNubmerPro;
@property (weak, nonatomic) IBOutlet UITextField *txt_PasswordPro;
@property (weak, nonatomic) IBOutlet UITextField *txt_NamePro;
@property (weak, nonatomic) IBOutlet UILabel *lb_SexPro;
@property (weak, nonatomic) IBOutlet UITextField *txt_AgePro;
@property (weak, nonatomic) IBOutlet UIButton *btnGetImagePro;
@property (weak, nonatomic) IBOutlet UICollectionView *collctionViewMain;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSavePro;
@property (weak, nonatomic) IBOutlet UIButton *btnExist;
@property (weak, nonatomic) IBOutlet UIView *viewPassword;

- (IBAction)btnExistAction:(id)sender;

- (void)updateCompleteWithBlock:(void(^)(void))block;

@end
