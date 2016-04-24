//
//  GNPayVM.h
//  GatherNew
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNVMBase.h"
#import "GNModelBase.h"


typedef NS_ENUM(NSUInteger, GNPayType) {
    GNPayTypeAlipay = 1,
    GNPayTypeWeChat = 2,
};

@interface GNAlipayModel : GNModelBase

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *payment_data;

@end

@interface GNWeChatModel : GNModelBase

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *mchid;
@property (nonatomic, strong) NSString *nonce_str;
@property (nonatomic, strong) NSString *prepay_id;

@end

@interface GNPayVM : GNVMBase

@property (nonatomic, assign) GNPayType payType;

- (instancetype)initWithOrderNo:(NSString *)orderNo;

@property (nonatomic, strong) GNVMResponse *getOrderInfoResponse;
@property (nonatomic, strong) GNVMResponse *payResponse;

@end
