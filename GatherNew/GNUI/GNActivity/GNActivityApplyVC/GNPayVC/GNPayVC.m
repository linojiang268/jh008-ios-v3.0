//
//  GNPayVC.m
//  GatherNew
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNPayVC.h"
#import "GNPayTVC.h"
#import "GNPayVM.h"
#import "WXApi.h"
#import "UIView+GNExtension.h"
#import "GNStatusVC.h"

@interface GNPayVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *priceContainView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *paymentTips;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *expireAt;
@property (nonatomic, strong) NSString *enrollEndAt;

@property (nonatomic, strong) GNPayVM *viewModel;
@property (nonatomic, copy) void(^backEventHandler)(GNPayVC *payVC);
@end

@implementation GNPayVC

+ (NSString *)sbIdentifier {
    return @"pay";
}

- (void)setupUI {
    [super setupUI];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.priceContainView addTopAndBottomLineWithDefaultSetting];
    
    NSAttributedString *attrPrice = [[NSAttributedString alloc] initWithString:[self.price stringByAppendingString:@"元"] attributes:@{NSForegroundColorAttributeName: kUIColorWithHexUint(GNUIColorOrange)}];
    self.priceLabel.attributedText = attrPrice;
    
    if(![self.enrollEndAt isEqualToString:self.expireAt]){
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * expireDateTime = [formatter dateFromString:self.expireAt];
        NSTimeInterval diff = [expireDateTime timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
        
        NSString * expire = [NSString stringWithFormat:@"--分钟"];
        if(diff > 0){
            expire = [NSString stringWithFormat:@"%d分钟", (int)ceil(diff/60)];
        }
        
        NSString * tips =[NSString stringWithFormat:@"您还剩 %@ 完成支付，获得参与资格", expire];
        NSMutableAttributedString *attrTips = [[NSMutableAttributedString alloc]initWithString:tips];
        NSRange range = [tips rangeOfString:expire];
        [attrTips addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        self.paymentTips.attributedText = attrTips;
    }else{
        self.paymentTips.text = @"请在活动开始前完成支付，获得参与资格";
    }
}

- (instancetype)initWithOrderNumber:(NSString *)orderNumber price:(NSString *)price expireAt:(NSString *) expireAt enrollEndAt:(NSString *) enrollEndAt backEventHandler:(void(^)(GNPayVC *payVC))handler{
    self = [self.class loadFromStoryboard];
    if (self) {
        self.price = price;
        self.expireAt = expireAt;
        self.enrollEndAt = enrollEndAt;
        self.viewModel = [[GNPayVM alloc] initWithOrderNo:orderNumber];
        self.backEventHandler = handler;
    }
    return self;
}

- (void)backBarButtonPressedEvent:(void(^)(GNPayVC *payVC))handler {
    self.backEventHandler = handler;
}

- (void)backBarButtonItemPressed:(UIBarButtonItem *)sender {
    if (self.backEventHandler) {
        self.backEventHandler(self);
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)binding {
    __weakify;;
    [self.viewModel.getOrderInfoResponse start:NO success:^(id response, id model) {
        __strongify;
        [self.viewModel.payResponse start];
    } error:^(id response, NSInteger code) {
        [[[UIAlertView alloc] initWithTitle:nil message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
    }];
    
    [self.viewModel.payResponse start:NO success:^(id response, id model) {
        __strongify;
        [self backToActivity];
    } error:^(id response, NSInteger code) {
        NSString *message = @"支付失败";
        if (response) {
            message = [response objectForKey:@"message"];
        }
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    } failure:^(id req, NSError *error) {

    }];
}

- (void)backToActivity {
    [SVProgressHUD dismiss];
    
    __weakify;
    GNStatusVC *controller = [GNStatusVC statusWithStatus:GNStatusTypeSignUpForActiveSuccess backEnabled:YES needPayment:YES backEventHandler:^(GNStatusVC *statusVC) {
        __strongify;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPayEndRefreshUINotificationName object:nil];
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isMemberOfClass:NSClassFromString(@"GNActivityDetailsVC")]) {
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
        //[statusVC.navigationController popToViewController:self animated:YES];
    }];
    [self.navigationController pushVC:controller animated:YES];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNPayTVC *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"pay_wechat"];
        cell.titleLabel.text = @"微信支付";
    }else {
        cell.iconImageView.image = [UIImage imageNamed:@"pay_alipay"];
        cell.titleLabel.text = @"支付宝支付";
    }
    
    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if (![WXApi isWXAppInstalled]) {
            [SVProgressHUD showInfoWithStatus:@"请先安装微信"];
        }else if (![WXApi isWXAppSupportApi]) {
            [SVProgressHUD showInfoWithStatus:@"当前版本的微信不支持支付"];
        }else {
            self.viewModel.payType = GNPayTypeWeChat;
            [self.viewModel.getOrderInfoResponse start];
        }
    }else {
        self.viewModel.payType = GNPayTypeAlipay;
        [self.viewModel.getOrderInfoResponse start];
    }
}

@end
