//
//  GNMyPerfectInfoVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/9.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMyPerfectInfoVC.h"
#import "UIControl+GNExtension.h"
#import "GNChooseImageService.h"
#import "GNMyPerfectInfoVM.h"
#import "GNPerfectInfoModel.h"
#import "GNInterestTagVC.h"
#import "GNLoginVC.h"
#import "GNEditOldPasswordVC.h"
#import "GNMyPerfectInfoCell.h"
#import "GNPushSubscibeService.h"

#define kcellIdentifier @"GNMyPerfectInfoCell"

@interface GNMyPerfectInfoVC ()<UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    UIActionSheet *_actionSheet;
    NSString *_strSelectedDataTime;
}

@property (weak, nonatomic) IBOutlet UIView *view_Line1;
@property (weak, nonatomic) IBOutlet UIView *view_Line2;
@property (weak, nonatomic) IBOutlet UIView *view_Line3;
@property (weak, nonatomic) IBOutlet UIView *view_Line4;
@property (weak, nonatomic) IBOutlet UIView *view_Line5;
@property (weak, nonatomic) IBOutlet UIView *view_Line6;
@property (weak, nonatomic) IBOutlet UIView *view_Line7;
@property (weak, nonatomic) IBOutlet UIView *view_Line8;
@property (weak, nonatomic) IBOutlet UIView *view_Line9;

@property (nonatomic, assign) GNGender sex;
@property (nonatomic, strong) UIImage *imageNew;
@property (nonatomic, strong) NSMutableArray *arrayTag;
@property (nonatomic, strong) NSString *selectedAge;
@property (nonatomic, strong) GNMyPerfectInfoVM *viewModel;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) void(^updateCompleteBlock)(void);

@end

@implementation GNMyPerfectInfoVC

+ (NSString *)sbIdentifier {
    return @"myPerfectInfo";
}

- (void)setupUI {
    
    [super setupUI];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self.collctionViewMain registerNib:[UINib nibWithNibName:NSStringFromClass([GNMyPerfectInfoCell class]) bundle:nil] forCellWithReuseIdentifier:@"GNMyPerfectInfoCell"];
    
    self.collctionViewMain.delegate = self;
    self.collctionViewMain.dataSource = self;
    self.collctionViewMain.showsVerticalScrollIndicator = NO;
    self.collctionViewMain.showsHorizontalScrollIndicator = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kUIScreenWidth-(25*4))/3, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 35);
    self.collctionViewMain.collectionViewLayout = layout;
    
    [self.btnExist setTitleColor:kUIColorWithHexUint(GNUIColorWhite) forState:UIControlStateNormal];
    
    [self.btnExist setBackgroundColor:kUIColorWithHexUint(GNUIColorGreen) forState:UIControlStateNormal];
    [self.btnExist setBackgroundColor:kUIColorWithHexUint(GNUIColorGreenPressed) forState:UIControlStateHighlighted];
    [self.btnExist setBackgroundColor:kUIColorWithHexUint(GNUIColorDisabled) forState:UIControlStateDisabled];
    
    UITapGestureRecognizer *gestSex = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexSelectedAction:)];
    [self.lb_SexPro addGestureRecognizer:gestSex];
    
    [self.view_Line1 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line2 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line3 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line4 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line5 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line6 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line7 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line8 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    [self.view_Line9 setBackgroundColor:kUIColorWithHexUint(GNUIColorGray)];
    
    self.datePicker= [[UIDatePicker alloc] init];
    [self.datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.datePicker setDate:[NSDate new] animated:YES];
    [self.datePicker setMaximumDate:[NSDate date]];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.txt_AgePro.inputView = _datePicker;
    
    [self.txt_AgePro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txt_NamePro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txt_PasswordPro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    [self.txt_PhoneNubmerPro setValue:kUIColorWithHexUint(GNUIColorGray) forKeyPath:@"placeholderLabel.textColor"];
    
    [self.lb_SexPro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_AgePro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_NamePro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_PhoneNubmerPro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [self.txt_PasswordPro setTextColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    
    UITapGestureRecognizer *gesPWS = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updatePassword)];
    [self.viewPassword addGestureRecognizer:gesPWS];
    
    
    self.image_headerPic.userInteractionEnabled = YES;
    [self.image_headerPic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)]];
}

-(void)updatePassword{
    GNEditOldPasswordVC *vc = [GNEditOldPasswordVC loadFromStoryboard];
    [self.navigationController pushVC:vc animated:YES];
}

-(void)datePickerValueChanged:(UIDatePicker *)sender{
    
    NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
    [dateFor setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFor stringFromDate:sender.date];
    
    self.viewModel.age = strDate;
    
    NSDateComponents *comp = [self dateChange:sender.date];
    NSDateComponents *compNow = [self dateChange:[NSDate new]];
    
    self.txt_AgePro.text = [NSString stringWithFormat:@"%ld",compNow.year-comp.year];
}

-(NSDateComponents *)dateChange:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    
    return comps;
}

- (void)updateCompleteWithBlock:(void(^)(void))block {
    self.updateCompleteBlock = block;
}

- (void)binding {
    
    self.viewModel = [[GNMyPerfectInfoVM alloc]init];
    
    self.arrayTag = [[NSMutableArray alloc] init];
    
    [self getData];
    
    RAC(self.viewModel,phoneNumber) = self.txt_PhoneNubmerPro.rac_textSignal;
    RAC(self.viewModel,passWord) = self.txt_PasswordPro.rac_textSignal;
    RAC(self.viewModel,name) = self.txt_NamePro.rac_textSignal;
    RAC(self.viewModel,sex) = RACObserve(self, sex);
    RAC(self.viewModel,age) = RACObserve(self, selectedAge);
    RAC(self.viewModel,headPortrait) = RACObserve(self.image_headerPic, image);
    RAC(self.viewModel,arrayTag) = RACObserve(self, arrayTag);
    
    self.btnSavePro.rac_command = self.viewModel.saveCommand;
    
    
    [self saveData];
    [self exist];
    
    __weakify;
    [RACObserve(self.lb_SexPro, text) subscribeNext:^(id x) {
        __strongify;
        if ([x isEqual:@"男"]) {
            self.sex = GNGenderMale;
        }
        else if ([x isEqual:@"女"]){
            self.sex = GNGenderFemale;
        }
        
    }];
    
    self.btnGetImagePro.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        __strongify;
        
        [self chooseImage];
        
        return [RACSignal empty];
    }];
    
}

-(void)getData{
    __weakify;
    [self.viewModel.getPerfectInfoResponse start:YES success:^(id response, id model) {
        __strongify;
        GNPerfectInfoModel *perfectInfo = model;
        
        [self.image_headerPic setImageWithURL:perfectInfo.avatar_url];
        
        self.viewModel.age = perfectInfo.birthday;
        self.viewModel.name = perfectInfo.nick_name;
        
        if (perfectInfo.mobile && perfectInfo.mobile.length >= 11) {
            self.txt_PhoneNubmerPro.text = [NSString stringWithFormat:@"%@ %@ %@",[perfectInfo.mobile substringToIndex:3],[perfectInfo.mobile substringWithRange:NSMakeRange(3, 4)],[perfectInfo.mobile substringFromIndex:7]];;
        }
        
        self.txt_PasswordPro.text = @"123456";
        self.txt_NamePro.text = perfectInfo.nick_name;
        self.txt_AgePro.text = perfectInfo.birthday;
        
        NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
        [dateFor setDateFormat:@"yyyy-MM-dd"];
        NSDateComponents *comp = [self dateChange:[dateFor dateFromString:perfectInfo.birthday]];
        NSDateComponents *compNow = [self dateChange:[NSDate new]];
        
        [self.datePicker setDate:[dateFor dateFromString:perfectInfo.birthday]];
        
        self.txt_AgePro.text = [NSString stringWithFormat:@"%d",compNow.year-comp.year];
        
        if (perfectInfo.gender == 1) {
            self.lb_SexPro.text = @"男";
        }else{
            self.lb_SexPro.text = @"女";
        }
        
        [self.arrayTag setArray:perfectInfo.tag_ids];
        
        [self.collctionViewMain reloadData];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取资料失败!"];
    }];
}

-(void)saveData{
    __weakify;
    [self.viewModel.saveResponse start:NO success:^(id response, id model) {
        __strongify;
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.updateCompleteBlock) {
            self.updateCompleteBlock();
        }
    } error:^(id response, NSInteger code) {
        
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"保存个人资料失败!"];
    }];
}

-(void)exist{
    [self.viewModel.existResponse start:NO success:^(id response, id model) {
        
        GNLoginVC *loginVC = [GNLoginVC loadFromStoryboard];
        loginVC.isHideReturn = YES;
        [GNApp userLogout];
        [GNPushSubscibeService unsubscribeUser];
        [kApp showLoginUI];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"退出失败"];
    }];
}


- (void)chooseImage {
    @weakify(self);
    [GNChooseImageService chooseImageWithController:self finishedBlock:^(UIImage *image) {
        @strongify(self);
        
        self.image_headerPic.image = image;
        self.imageNew = image;
    }];
}


-(void)sexSelectedAction:(id)sender{
    //    _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女",nil];
    //    [_actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
/*
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 
 if (buttonIndex==0) {
 self.lb_SexPro.text = @"男";
 }
 else if(buttonIndex==1)
 {
 self.lb_SexPro.text= @"女";
 }
 
 }
 */

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayTag.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = @"GNMyPerfectInfoCell";
    GNMyPerfectInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
 
    NSString *strName =[GNApp titleWithInterestId:[self.arrayTag[indexPath.row]integerValue]];
    
    cell.lbTag.layer.borderWidth = 1;
    cell.lbTag.layer.borderColor =[kUIColorWithHexUint(GNUIColorGray) CGColor];
    cell.lbTag.text = strName;
    cell.lbTag.font = [UIFont systemFontOfSize:14];
    cell.lbTag.textAlignment = NSTextAlignmentCenter;
    cell.lbTag.textColor = kUIColorWithHexUint(GNUIColorDarkgray);

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"into_InterestTagVC"]) {

        NSMutableArray *mutArray = [NSMutableArray array];
        for (int i = 0; i<self.arrayTag.count; i++) {
            [mutArray addObject:[NSString stringWithFormat:@"%@",self.arrayTag[i]]];
        }
        
        ((GNInterestTagVC *)segue.destinationViewController).arrayTags = mutArray;
        
        ((GNInterestTagVC *)segue.destinationViewController).getInterestTagValue = ^(id sender){
            NSArray *array = sender;
            self.arrayTag = [NSMutableArray array];
            [self.arrayTag addObjectsFromArray:array];
            [self.collctionViewMain reloadData];
        };

    }
}

- (IBAction)btnExistAction:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                       message:@"是否退出？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.viewModel.existResponse start];
    }
}
@end
