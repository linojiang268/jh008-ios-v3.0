//
//  GNClubHomePageVC.m
//  GatherNew
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNClubHomePageVC.h"
#import "GNClubHomePageVC.h"
#import "GNClubHomePageCVC.h"
#import "GNClubQRCodeVC.h"
#import "GNMemberVC.h"
#import "GNClubStatusVC.h"
#import "GNStatusVC.h"
#import "GNClubInfoVerifyVC.h"
#import "GNClubPrivacySettingsVC.h"
#import "GNClubActiveAlbumVC.h"
#import "GNClubNewsVC.h"
#import "GNClubNoticeVC.h"
#import "GNActivityVC.h"
#import "GNPushSubscibeService.h"

#import "UIView+GNExtension.h"
#import "UINavigationBar+GNExtension.h"


@interface GNClubHomePageVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topContainView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) GNClubInfoVerifyVC *clubInfoVerifyController;
@property (nonatomic, assign) BOOL isShowingClubInfoVerifyController;
@property (nonatomic, strong) UIView * toastView;

@end

@implementation GNClubHomePageVC

+ (NSString *)sbIdentifier {
    return @"club_home_page";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lineViewHide:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize14],
                                                           NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorOrange)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lineViewHide:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize18],
                                                           NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorWhite)}];
}

- (void)setupUI {
    [super setupUI];
    
    self.topContainView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayBlack);
    kUIRoundCorner(self.imageViewAvatar, [UIColor clearColor], 0, 85/2);
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.imageViewAvatar setClubLogoImageWithURLString:self.viewModel.clubModel.logo_url];
    [self.nameLabel setText:@""];
    [self.numberLabel setText:@""];
    [self.introLabel setText:@""];
    [self.vImageView setHidden:YES];
}

- (void)refreshUI {
    [self.imageViewAvatar setClubLogoImageWithURLString:self.viewModel.clubModel.logo_url];
    [self.nameLabel setText:self.viewModel.clubModel.name];
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld人",(long)self.viewModel.clubModel.member_num]];
    [self.introLabel setText:self.viewModel.clubModel.introduction];
    [self.vImageView setHidden:!self.viewModel.clubModel.certification];
    
    /// 获取到完整信息后才刷新功能块UI
    if (self.viewModel.isFullInfo) {
        [self.collectionView reloadData];
        UIBarButtonItem *item = nil;
        if (!self.viewModel.clubModel.joined) {
            
            if (self.viewModel.clubModel.requested) {
                self.title = @"等待团长审核";
            }else {
                item = [[UIBarButtonItem alloc] initWithTitle:@"申请加入" style:UIBarButtonItemStylePlain target:nil action:Nil];
                if (self.viewModel.clubModel.join_type == GNClubJoinRequirementNeedReview) {
                    if (self.viewModel.clubModel.isNeedInputInfo) {
                        
                        GNClubStatusType status = GNClubStatusTypeJoinClubNeedPerfectInformation;
                        if (self.viewModel.clubModel.in_whitelist) {
                            status = GNClubStatusTypeJoinClubWhiteListUserAndNeedPerfectInformation;
                        }
                        
                        __weakify;
                        item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                            __strongify;
                            if(self.viewModel.clubModel.in_blacklist){
                                [SVProgressHUD showErrorWithStatus:@"你被限制加入"];
                            }else{
                                GNClubStatusVC *controller = [GNClubStatusVC initWithStatusAndAction:status actionHandler:^(GNClubStatusVC *clubStatusVC) {
                                    __strongify;
                                    self.clubInfoVerifyController = [[GNClubInfoVerifyVC alloc] initWithRequirements:self.viewModel.clubModel.join_requirements commitHandler:^(NSDictionary *requirements) {
                                        __strongify;
                                        self.viewModel.joinRequirements = requirements;
                                        [self.viewModel.joinResponse start];
                                    }];
                                    [self.navigationController pushVC:self.clubInfoVerifyController animated:YES];
                                    self.isShowingClubInfoVerifyController = YES;
                                }];
                            [self.navigationController pushVC:controller animated:YES];
                            }
                            return [RACSignal empty];
                        }];
                        
                    }else {
                        item.rac_command = self.viewModel.joinCommand; // 不需要填写信息，就直接调用接口，根据接口返回状态进行展示页面
                    }
                }else {
                    item.rac_command = self.viewModel.joinCommand; // 所有人可直接加入
                }
            }
        }else {
            item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"club_quit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:Nil];
            
            __weakify;
            item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出社团？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                    __strongify;
                    if ([x integerValue] == 1) {
                        [self.viewModel.exitResponse start];
                    }
                }];
                
                return [RACSignal empty];
            }];
        }
        self.navigationItem.rightBarButtonItem = item;
    }
}

-(void)dismissToastView{
    self.toastView.hidden = YES;
}
-(void)showToastView:(UIImage*)image text:(NSString*) text{
    if(!self.toastView){
        self.toastView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight)];
        self.toastView.backgroundColor = kUIColorWithHexUint(0xAA000000);
        
        UIView* contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 5.0f;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        imageView.image = image;
        imageView.tag = 0x1000;
        [contentView addSubview:imageView];
        
        
        UILabel* textInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 20)];
        textInfo.text = text;
        textInfo.tag = 0x1001;
        textInfo.textAlignment = NSTextAlignmentCenter;
        textInfo.font = [UIFont systemFontOfSize:GNUIFontSize14];
        textInfo.textColor = kUIColorWithHexUint(GNUIColorBlack);
        [contentView addSubview:textInfo];
        
        contentView.center = self.toastView.center;
        [self.toastView addSubview:contentView];
        [self.navigationController.view addSubview:self.toastView];
    }else{
        UIImageView *imageView = (UIImageView *)[self.toastView viewWithTag:0x1000];
        imageView.image = image;
        UILabel *textInfo = (UILabel *)[self.toastView viewWithTag:0x1001];
        textInfo.text = text;
    }
    
    self.toastView.hidden = NO;
    
    [self performSelector:@selector(dismissToastView) withObject:nil afterDelay:2];
}

- (void)binding {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kUIScreenWidth/3-1, kUIScreenWidth/3);
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 1;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[GNClubHomePageCVC nib] forCellWithReuseIdentifier:kUICellIdentifier];
    
    __weakify;
    [self.viewModel.clubInfoResponse start:YES success:^(id response, id model) {
        __strongify;
        [self refreshUI];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:@"社团更新信息获取失败"];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"社团更新信息获取失败"];
    }];
    
    [self.viewModel.joinResponse start:NO success:^(id response, id model) {
        __strongify;
        [self.viewModel.clubInfoResponse start];
        
        /// 通知主页面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshMainPageUINotificationName object:nil];
        
        GNClubStatusType status = 0;
        if ([[response objectForKey:@"result"] intValue] == 1) {
            status = GNClubStatusTypeJoinClubWaiting;
            if(self.clubInfoVerifyController && self.isShowingClubInfoVerifyController){
                self.isShowingClubInfoVerifyController = NO;
                //[self.clubInfoVerifyController.navigationController popToViewController:self animated:YES];
                GNStatusVC * controller = [GNStatusVC initWithStatusFromClub:GNStatusTypeClubJoinVerify backEnabled:YES clubName:self.viewModel.clubModel.name backEventHandler:^(GNStatusVC *statusVC) {
                    [statusVC.navigationController popToViewController:self animated:YES];
                }];
                [self.navigationController pushVC:controller animated:YES];
            }else{
                [self showToastView:[UIImage imageNamed:@"enroll_wait"] text:@"等待审核"];
            }
            
            
        }else if ([[response objectForKey:@"result"] intValue] == 2){
            status = GNClubStatusTypeJoinClubWaiting;
            [GNPushSubscibeService subscribeClub:self.viewModel.clubId];
            //[self showToastView:[UIImage imageNamed:@"enroll_ok"] text:@"等待审核"];
            
            if(self.clubInfoVerifyController && self.isShowingClubInfoVerifyController){
                GNStatusVC * controller = [GNStatusVC initWithStatusFromClub:GNStatusTypeClubJoinOK backEnabled:YES clubName:self.viewModel.clubModel.name backEventHandler:^(GNStatusVC *statusVC) {
                    [statusVC.navigationController popToViewController:self animated:YES];
                }];
                [self.navigationController pushVC:controller animated:YES];
            }else{
                [self showToastView:[UIImage imageNamed:@"enroll_ok"] text:@"成功"];
            }
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发生错误"];
    }];
    
    [self.viewModel.exitResponse start:NO success:^(id response, id model) {
        __strongify;
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"发生错误"];
    }];
    
    [self.viewModel.updatePrivacyResponse start:NO success:^(id response, id model) {
        __strongify;
        self.viewModel.visibility = self.viewModel.updateVisibility;
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"修改隐私设置出错"];
    }];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewModel.isFullInfo) {
        return self.viewModel.moduleArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GNClubHomePageCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [self.viewModel.moduleArray objectAtIndex:indexPath.item];
    
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"image_name"]];
    cell.titleLabel.text = [dict objectForKey:@"title"];

    switch (indexPath.item) {
        case 0:
            [cell setIsUpdated:self.viewModel.activityUpdated];
            break;
        case 1:
            [cell setIsUpdated:self.viewModel.newsUpdated];
            break;
        case 2:
            [cell setIsUpdated:self.viewModel.memberUpdated];
            break;
        case 3:
            [cell setIsUpdated:self.viewModel.albumUpdated];
            break;
        default:
            [cell setIsUpdated:NO];
            break;
    }
    
    return cell;
}

#pragma mark -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GNClubHomePageCVC *cell = (GNClubHomePageCVC *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsUpdated:NO];
    
    switch (indexPath.item) {
        case 0:
        {
            [self.viewModel refreshActivityUpdateTime];
            [self.navigationController pushVC:[[GNActivityVC alloc] initWithViewModel:[[GNActivityVM alloc] initClubActiveListWithClubId:self.viewModel.clubId]] animated:YES];
        }
            break;
        case 1:
        {
            [self.viewModel refreshNewsUpdatedTime];
            GNClubNewsVC *controller = [[GNClubNewsVC alloc] initWithClubModel:self.viewModel.clubModel];
            
            [self.navigationController pushVC:controller animated:YES];
        }
            break;
        case 2:
        {
            [self.viewModel refreshMemberUpdatedTime];
            GNMemberVC *controller = [[GNMemberVC alloc] initWithType:GNMemberTypeClub typeId:self.viewModel.clubId];
            [self.navigationController pushVC:controller animated:YES];
        }
            break;
        case 3:
        {
            [self.viewModel refreshAlbumUpdatedTime];
            GNClubActiveAlbumVC *controller = [[GNClubActiveAlbumVC alloc] initWithClubId:self.viewModel.clubId];
            [self.navigationController pushVC:controller animated:YES];
        }
            break;
        case 4:
        {
            [self.navigationController pushVC:[[GNClubQRCodeVC alloc] initWithClubModel:self.viewModel.clubModel] animated:YES];
        }
            break;
        case 5:
        {
            __weakify;
            [self.navigationController pushVC:[[GNClubPrivacySettingsVC alloc] initWithVisibility:self.viewModel.visibility changeHandler:^(GNClubMemberVisibility visibility) {
                __strongify;
                self.viewModel.updateVisibility = visibility;
                [self.viewModel.updatePrivacyResponse start];
            }] animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
