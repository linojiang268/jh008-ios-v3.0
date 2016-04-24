//
//  GNPerfectInfoVC.h
//  GatherNew
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNLoginBaseVC.h"
#import "GNInterestTagNPS.h"

@interface GNPerfectInfoVC : GNLoginBaseVC

@property (weak, nonatomic) IBOutlet UIImageView *image_headerPic;
@property (weak, nonatomic) IBOutlet UITextField *txt_PhoneNubmerPro;
@property (weak, nonatomic) IBOutlet UITextField *txt_PasswordPro;
@property (weak, nonatomic) IBOutlet UITextField *txt_NamePro;
@property (weak, nonatomic) IBOutlet UILabel *lb_SexPro;
@property (weak, nonatomic) IBOutlet UITextField *txt_AgePro;
@property (weak, nonatomic) IBOutlet UIButton *btnGetImagePro;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong)NSArray *tagIds;
@property(nonatomic, strong) NSString* phone;
@property(nonatomic, strong) NSString* password;

@end
