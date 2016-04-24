//
//  AppDelegate.m
//  GatherNew
//
//  Created by apple on 15/5/25.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "AppDelegate.h"

/// SDK
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <IQKeyboardManager.h>
#import <CoreData+MagicalRecord.h>
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

/// 服务
#import "GNLogService.h"
#import "GNCacheService.h"
#import "GNPushSubscibeService.h"

/// 主页
#import "GNMainVC.h"
#import "GNMeVC.h"
#import "GNClubVC.h"
#import "GNActivityVC.h"
#import "GNMessageVC.h"

/// 登陆
#import "GNLoginVC.h"
#import "GNLoginStartVC.h"

/// 评分
#import "GNActivityScoreVC.h"
#import "GNActivityScoreVM.h"
#import "GNActivityScoreModel.h"

#import "GNActivityRatingVC.h"

/// 通知跳转视图
#import "GNWebViewVC.h"
#import "GNClubHomePageVC.h"
#import "GNActivityDetailsVC.h"
#import "GNActivityApplyVerifyListVC.h"

#import "GNLoginVM.h"

@interface AppDelegate ()<WXApiDelegate,BMKGeneralDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate>
{
    BMKMapManager* _mapManager;
}

@property (nonatomic, strong) GNActivityScoreVM *viewModelScore;

@property (nonatomic, strong) NSMutableArray *ratingArray;

@property (nonatomic, strong) UIView *containView;


@property (nonatomic, strong) GNLoginVM* loginVM;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.viewModelScore =[[GNActivityScoreVM alloc]init];//实例评分功能接口
    
    [self initRemotePush];
    [self initBaiduMap];
    [self initService];
    [self initShareSDK];
    [self setupCommonAppearance];
    [self initUI];
    [self checkPushMessageWithLaunchInfo:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    if (!self.containView) {
        [self requestActivityScoreInfo];
    }
    
    return YES;
}

- (void)initRemotePush {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                                                             UIUserNotificationTypeAlert |
                                                                                             UIUserNotificationTypeBadge )
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                               UIRemoteNotificationTypeSound |
                                                                               UIRemoteNotificationTypeAlert)];
    }
}

- (void)checkPushMessageWithLaunchInfo:(NSDictionary *)launchInfo {
    NSDictionary *message = [launchInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message.count > 0 && [[message allKeys] containsObject:@"aps"]) {
        [self handleRemotePushNotificationWithMessage:[message objectForKey:@"aps"]];
    }
}

- (void)initBaiduMap {
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = NO;
    if (APP_ENVIRONMENT == APP_ENVIRONMENT_TEST) {
        ret = [_mapManager start:@"doM1QVGlV6Pp8Gci5n0uMegM" generalDelegate:self]; // 测试
    }else if (APP_ENVIRONMENT == APP_ENVIRONMENT_INHOUSE) {
        ret = [_mapManager start:@"RciK7Lo5QYcvZSZh3Iwpas3q" generalDelegate:self]; // 企业
    }else if (APP_ENVIRONMENT == APP_ENVIRONMENT_STORE) {
        ret = [_mapManager start:@"v1epimlB0h9NHNik66gKx2G6" generalDelegate:self]; // 正式
    }
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

-(void)onGetNetworkState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"网络连接正常");
    }
    else
    {
        NSLog(@"网络错误:%d",iError);
    }
}
-(void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"授权失败:%d",iError);
    }
}

- (void)initService{
    [GNLogService initService];
    [GNCacheService initService];
    [GNPushSubscibeService initService];
}

- (void)initShareSDK {
    [ShareSDK registerApp:@"4ee82564c8f7"];
    [ShareSDK useAppTrusteeship:YES];
}

- (void)setupCommonAppearance {
    
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    [[UINavigationBar appearance] setBarTintColor:kUIColorWithHexUint(GNUIColorGrayBlack)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize18],
                                                           NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorWhite)}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize14],
                                                           NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorWhite)} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize14],
                                                           NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorDisabled)} forState:UIControlStateDisabled];
    
    [[UITabBar appearance] setBarTintColor:kUIColorWithHexUint(GNUIColorWhite)];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorDarkgray),
                                                        NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize12]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorBlue),
                                                        NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize12]} forState:UIControlStateHighlighted];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorBlue),
                                                        NSFontAttributeName: [UIFont systemFontOfSize:GNUIFontSize12]} forState:UIControlStateSelected];
}

- (void)initUI {
    if ([GNApp userIsLogin]) {
        [self showMainUI];
        //TODO:
        [self silenceLogin];
    }else {
        [self showLoginUI];
    }
}


- (void)silenceLogin {
    self.loginVM = [[GNLoginVM alloc]init];
    [self.loginVM silenceLogin];
}



-(void)requestActivityScoreInfo{
    if ([GNApp userIsLogin]) {
        __weakify;
        [self.viewModelScore.getActivityScoreResponse start:YES success:^(id response, GNActivityScoreModel *model) {
            __strongify;
            if (model && model.activities.count>0) {
                if (model.activities.count > 0) {
                    self.ratingArray = [NSMutableArray array];
                    for (int i = 0; i<model.activities.count; i++) {
                        GNActivityRatingVC *ratingController = [[GNActivityRatingVC alloc] initWithActivityModel:[model.activities objectAtIndex:i]];
                        [self.ratingArray addObject:ratingController];
                    }
                    if (self.ratingArray.count > 0) {
                        [self showRatingView];
                    }
                }
            }
        } error:^(id response, NSInteger code) {
            
        } failure:^(id req, NSError *error) {
            
        }];
    }
}

- (void)showRatingView {
    if (!self.window.rootViewController) {
        [self initUI];
    }
    
    UIView *currentView = self.window.rootViewController.view;
    
    if (currentView && self.ratingArray.count > 0) {
        __weak GNActivityRatingVC *ratingController = [self.ratingArray firstObject];
        
        if (ratingController) {
            
            UIView *containView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            containView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            
            ratingController.view.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, kUIScreenHeight);
            ratingController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            [ratingController finlishRatingWithBlock:^{
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    ratingController.view.frame = CGRectMake(0, kUIScreenHeight, kUIScreenWidth, kUIScreenHeight);
                    containView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
                } completion:^(BOOL finished) {
                    [containView removeFromSuperview];
                }];
                
                [self.ratingArray removeObject:[self.ratingArray firstObject]];
                [self showRatingView];
            }];
            [ratingController viewWillAppear:YES];
            [ratingController viewDidAppear:YES];
            
            [containView addSubview:ratingController.view];
            
            [currentView addSubview:containView];
            [self setContainView:containView];
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                ratingController.view.frame = CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight);
                containView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            } completion:^(BOOL finished) {
                
            }];
        }
    }else {
        [self setContainView:nil];
    }
}

- (void)showLoginUI {
    [GNApp userLogout];
    [GNPushSubscibeService unsubscribeUser];
    
    GNLoginVC *loginUI = [GNLoginVC loadFromStoryboard];
    
    //GNActivityApplyVerifyListVC* controller = [GNActivityApplyVerifyListVC initWithActivity:1];
    
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginUI];
    self.window.rootViewController = loginNav;
}

- (void)showMainUI {
    
    
    GNMainVC *mainVC = [[GNMainVC alloc] initWithStyle:UITableViewStyleGrouped];
    GNClubVC *clubVC = [[GNClubVC alloc] init];
    GNActivityVC *activeVC = [[GNActivityVC alloc] initWithViewModel:[[GNActivityVM alloc] initActiveList]];
    
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *clubNav = [[UINavigationController alloc] initWithRootViewController:clubVC];
    UINavigationController *activeNav = [[UINavigationController alloc] initWithRootViewController:activeVC];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.tabBar.translucent = NO;
    tab.delegate = self;
    tab.viewControllers = @[mainNav, activeNav, clubNav];
    
    self.window.rootViewController = tab;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)clearBadgeAndNotifications {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (UIAlertView *)lostConnectionAlert {
    if (!_lostConnectionAlert) {
        _lostConnectionAlert = [[UIAlertView alloc] initWithTitle:nil message:@"你的帐号已在其他设备登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        __weakify;
        [_lostConnectionAlert.rac_buttonClickedSignal subscribeNext:^(id x) {
            __strongify;
            [self showLoginUI];
        }];
    }
    return _lostConnectionAlert;
}

- (void)showLostConnectionAlertView {
    if (!self.lostConnectionAlert.visible) {
        [self.lostConnectionAlert show];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DDLogInfo(@"get Device Token: %@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [GNPushSubscibeService uploadDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound) {
        DDLogError(@"apns is NOT supported on simulator, run your Application on a REAL device to get device token");
    }
    DDLogError(@"didFailToRegisterForRemoteNotificationsWithError Error: %@", error);
}

- (void)handleRemotePushNotificationWithMessage:(NSDictionary *)message {
    
    DDLogInfo(@"PUSH Msg:%@",message);
    
    if (![GNApp userIsLogin]) {
        return;
    }
    
    if ([[message allKeys] containsObject:@"type"]) {
        NSString *type = [message objectForKey:@"type"];
        if ([type isEqualToString:@"version_upgrade"]) {
            
            if ([[message allKeys] containsObject:@"attributes"]) {
                NSDictionary *attributes = [message objectForKey:@"attributes"];
                
                if ([[attributes allKeys] containsObject:@"version"]) {
                    
                    NSString *onlineVersionString = [attributes objectForKey:@"version"];
                    NSString *currentVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    
                    NSArray *onlineVersionArray = [onlineVersionString componentsSeparatedByString:@"."];
                    NSArray *currentVersionArray = [currentVersionString componentsSeparatedByString:@"."];
                    
                    if ([onlineVersionArray count] > 0 && [currentVersionArray count] > 0) {
                        
                        BOOL haveNewVersion = NO;
                        
                        for (int i = 0; i < onlineVersionArray.count; i++) {
                            
                            if (currentVersionArray.count > i) {
                                
                                NSUInteger onlineNumber = [[onlineVersionArray objectAtIndex:i] integerValue];
                                NSUInteger currentNumber = [[currentVersionArray objectAtIndex:i] integerValue];
                                
                                if (onlineNumber > currentNumber) {
                                    haveNewVersion = YES;
                                    break;
                                }else if (onlineNumber == currentNumber) {
                                    continue;
                                }else {
                                    break;
                                }
                                
                            }else {
                                haveNewVersion = YES;
                                break;
                            }
                        }
                        
                        if (haveNewVersion) {
                            
                            BOOL compulsoryUpdate = NO;
                            if ([[attributes allKeys] containsObject:@"compulsory"]) {
                                compulsoryUpdate = [[attributes objectForKey:@"compulsory"] boolValue];
                            }
                            
                            NSString *updateMessage = @"有新版本更新";
                            if ([[message allKeys] containsObject:@"content"]) {
                                updateMessage = [message objectForKey:@"content"];
                            }
                            
                            if ([[attributes allKeys] containsObject:@"url"]) {
                                NSString *url = [attributes objectForKey:@"url"];
                                if (url && [url isKindOfClass:[NSString class]] && url.length > 0) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:updateMessage delegate:nil cancelButtonTitle:compulsoryUpdate ? nil : @"以后再说" otherButtonTitles:@"立即更新", nil];
                                    [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                                        if ((!compulsoryUpdate && [x intValue]) || compulsoryUpdate) {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                                        }
                                    }];
                                }
                            }else {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:updateMessage delegate:nil cancelButtonTitle:compulsoryUpdate ? nil : @"以后再说" otherButtonTitles:@"立即更新", nil];
                                [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                                    if ((!compulsoryUpdate && [x intValue]) || compulsoryUpdate) {
                                        // https://appsto.re/cn/3FXW3.i
                                        // https://itunes.apple.com/us/app/ji-he-la/id935532535?mt=8&uo=4
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ji-he-la/id935532535?mt=8&uo=4"]];
                                    }
                                }];
                            }
                            
                        }
                    }
                }
            }
            
        }else if ([type isEqualToString:@"kick"]) {
            [self showLostConnectionAlertView];
        }else if ([type isEqualToString:@"text"]) {
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                [[[UIAlertView alloc] initWithTitle:@"推送消息" message:[message objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }else if ([[message allKeys] containsObject:@"attributes"]) {
            
            NSDictionary *attributes = [message objectForKey:@"attributes"];
            
            if (attributes.count > 0) {
                
                if (!self.window.rootViewController) {
                    [self initUI];
                }
                
                void(^jumpAction)(void) = ^{
                    
                    UINavigationController *nav = nil;
                    if ([self.window.rootViewController isMemberOfClass:[UITabBarController class]]) {
                        UITabBarController *tab = (UITabBarController *)self.window.rootViewController;
                        nav = [tab.viewControllers objectAtIndex:tab.selectedIndex];
                    }else {
                        nav = (UINavigationController *)self.window.rootViewController;
                    }
                    
                    if (nav) {
                        if ([type isEqualToString:@"url"] && [[attributes allKeys] containsObject:@"url"]) { /// 网页
                            NSString *url = [[message objectForKey:@"attributes"] objectForKey:@"url"];
                            
                            GNWebViewVC *controller = [[GNWebViewVC alloc] initWithTitle:@"" url:[NSURL URLWithString:url]];
                            [nav pushVC:controller animated:YES];
                        }else if ([type isEqualToString:@"activity"] && [[attributes allKeys] containsObject:@"activity_id"]) { /// 活动
                            NSUInteger activity_id = [[attributes objectForKey:@"activity_id"] unsignedIntegerValue];
                            
                            if (activity_id > 0) {
                                GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[NSString stringWithFormat:@"%ld",(unsigned long)activity_id]];
                                [nav pushVC:controller animated:YES];
                                [GNPushSubscibeService subscribeActivity:activity_id];
                            }
                        }else if ([type isEqualToString:@"team"] && [[attributes allKeys] containsObject:@"team_id"]) { /// 社团
                            NSUInteger team_id = [[attributes objectForKey:@"team_id"] unsignedIntegerValue];
                            
                            if (team_id > 0) {
                                GNClubHomePageVC *controller = [GNClubHomePageVC loadFromStoryboard];
                                controller.viewModel = [[GNClubHomePageVM alloc] initWithClubId:team_id visibility:GNClubMemberVisibilityAll];
                                [nav pushVC:controller animated:YES];
                                [GNPushSubscibeService subscribeClub:team_id];
                            }
                        }
                    }
                };
                
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:[message objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
                    [alert show];
                    [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
                        if ([x intValue]) {
                            jumpAction();
                        }
                    }];
                }else {
                    jumpAction();
                }
            }
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self handleRemotePushNotificationWithMessage:[userInfo objectForKey:@"aps"]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    [self clearBadgeAndNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (!self.containView) {
        [self requestActivityScoreInfo];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self clearBadgeAndNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [GNCacheService uninstallService];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
        void(^callback)(NSDictionary *) = ^(NSDictionary *resultDict) {
            
            DDLogInfo(@"%@______%@",resultDict,[resultDict objectForKey:@"memo"]);
            
            int status = [[resultDict objectForKey:@"resultStatus"] intValue];
            
            switch (status) {
                case 9000:
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    break;
                case 8000:
                    [SVProgressHUD showWithStatus:@"支付中"];
                    break;
                case 4000:
                    [SVProgressHUD showErrorWithStatus:@"支付失败"];
                    break;
                case 6001:
                    [SVProgressHUD showSuccessWithStatus:@"支付取消"];
                    break;
                case 6002:
                    [SVProgressHUD showSuccessWithStatus:@"网络异常"];
                    break;
            }
        };
        
        //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                callback(resultDic);
            }];
        }
        //支付宝钱包快登授权返回 authCode
        if ([url.host isEqualToString:@"platformapi"]) {
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                callback(resultDic);
            }];
        }
        
    }
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - we chat pay delegate

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
            {
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DDLogInfo(@"支付成功");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeChatPayEndNotificationName object:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"result"]];
            }
                break;
            case WXErrCodeUserCancel:
                break;
            default:
            {
                DDLogError(@"支付失败， retcode=%d",resp.errCode);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeChatPayEndNotificationName object:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"result"]];
            }
                break;
        }
    }
}

@end
