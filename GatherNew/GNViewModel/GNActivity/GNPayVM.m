//
//  GNPayVM.m
//  GatherNew
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNPayVM.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonDigest.h>

@implementation GNAlipayModel

@end

@implementation GNWeChatModel

@end

#pragma mark - WeChat Pay
/// 微信商户API密钥
#define kWeChatSecretID @"9bfe7c6249f79ab1012e726fd84d872b"

@interface GNPayVM ()

@property (nonatomic, strong) NSString *orderNo;

@property (nonatomic, strong) GNAlipayModel *alipayInfo;
@property (nonatomic, strong) GNWeChatModel *weChatInfo;

@end

@implementation GNPayVM

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeChatPayEndNotificationName object:nil];
}

- (instancetype)initWithOrderNo:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.orderNo = orderNo;
    }
    return self;
}

- (void)initModel {
    
    __weakify;
    self.getOrderInfoResponse = [GNVMResponse responseWithTaskBlock:^{
        __strongify;
        GNNPSBase *nps = nil;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.orderNo forKey:@"order_no"];
        
        if (self.payType == GNPayTypeAlipay) {
            nps = [[GNNPSBase alloc] initWithURL:@"/api/payment/alipay/app/prepay"
                                      parameters:nil
                               mappingModelClass:[GNAlipayModel class]];
        }else {
            nps = [[GNNPSBase alloc] initWithURL:@"/api/payment/wxpay/app/prepay"
                                      parameters:nil
                               mappingModelClass:[GNWeChatModel class]];
        }
        
        [dict setObject:[nps createSign:dict] forKey:@"sign"];
        [nps setParameters:dict];
        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            if (self.payType == GNPayTypeAlipay) {
                self.alipayInfo = model;
            }else {
                self.weChatInfo = model;
            }
            self.getOrderInfoResponse.success(response,model);
        } error:self.getOrderInfoResponse.error failure:self.getOrderInfoResponse.failure];
    }];
    
    self.payResponse = [GNVMResponse responseWithTaskBlock:^{
        if (self.payType == GNPayTypeAlipay) {
            [self alipay];
        }else {
            [self weChatPay];
        }
    }];
}

- (void)alipay {
    __weakify;
    [[AlipaySDK defaultService] payOrder:self.alipayInfo.payment_data fromScheme:@"comzero2allgather" callback:^(NSDictionary *resultDic) {
        __strongify;
        DDLogInfo(@"%@______%@",resultDic,[resultDic objectForKey:@"memo"]);
        
        int status = [[resultDic objectForKey:@"resultStatus"] intValue];
        
        switch (status) {
            case 9000:/// 成功
                self.payResponse.success(nil,nil);
                break;
            case 8000:/// 支付中
                break;
            case 4000:/// 支付失败
                self.payResponse.error(@{@"message":@"支付失败"},4000);
                break;
            case 6001:/// 支付取消
                break;
            case 6002:/// 网络异常
                self.payResponse.error(@{@"message":@"支付失败"},6002);
                break;
        }
    }];
}

- (void)weChatPayEnd:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    if (dict.count > 0) {
        BOOL result = [[dict objectForKey:@"result"] boolValue];
        if (result) {
            self.payResponse.success(dict,dict);
        }else {
            self.payResponse.success(noti,noti);
        }
    }
}

- (void)weChatPay {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayEnd:) name:kWeChatPayEndNotificationName object:nil];
    
    time_t now;
    time(&now);
    NSString *time_stamp  = [NSString stringWithFormat:@"%ld", now];
    
    //调起微信支付
    PayReq *req             = [[PayReq alloc] init];
    req.openID              = self.weChatInfo.appid;
    req.partnerId           = self.weChatInfo.mchid;
    req.prepayId            = self.weChatInfo.prepay_id;
    req.nonceStr            = self.weChatInfo.nonce_str;
    req.timeStamp           = time_stamp.intValue;
    req.package             = @"Sign=WXPay";
    
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:self.weChatInfo.appid forKey:@"appid"];
    [signParams setObject:self.weChatInfo.nonce_str forKey:@"noncestr"];
    [signParams setObject:@"Sign=WXPay" forKey:@"package"];
    [signParams setObject:self.weChatInfo.mchid forKey:@"partnerid"];
    [signParams setObject:time_stamp forKey:@"timestamp"];
    [signParams setObject:self.weChatInfo.prepay_id forKey:@"prepayid"];
    
    req.sign = [self createMd5Sign:signParams];
    
    [WXApi sendReq:req];
    //日志输出
    DDLogInfo(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}

/// 创建package签名
- (NSString *) createMd5Sign:(NSMutableDictionary *)dict {
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", kWeChatSecretID];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

/// md5 encode
- (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}










@end
