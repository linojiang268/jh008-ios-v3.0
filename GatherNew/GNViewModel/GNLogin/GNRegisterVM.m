//
//  GNRegisterVM.m
//  GatherNew
//
//  Created by apple on 15/6/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNRegisterVM.h"
#import "GNGetAuthCodeNPS.h"
#import "GNRegisterNPS.h"
#import "GNUpdatePasswordNPS.h"
#import "GNLoginNPS.h"

@interface GNRegisterVM ()

@property (nonatomic, assign) GNVMType vmType;

@property (nonatomic, assign) NSInteger countDown;
@property (nonatomic, strong) NSString *token;

@end

@implementation GNRegisterVM

- (instancetype)initWithVMType:(GNVMType)vmType {
    self.vmType = vmType;
    
    self = [super init];
    if (self) {

    }
    return self;
}



- (void)setCountDown:(NSInteger)countDown {
    _countDown = countDown;
    
    if (countDown == 0) {
        self.getAuthCodeTitle = @"获取验证码";
    }else {
        self.getAuthCodeTitle = [NSString stringWithFormat:@"%ldS后重新获取",(long)countDown];
    }
}

- (void)startCoundDown {
    self.countDown = 60;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSInteger temp = self.countDown;
        temp--;
        if (temp < 0) {
            dispatch_source_cancel(timer);
        }else {
            self.countDown--;
        }
    });
    dispatch_resume(timer);
}

- (void)initModel {
    
    self.countDown = 0;
    
    self.getAuthCodeResponse = [[GNVMResponse alloc] init];
    self.nextResponse = [[GNVMResponse alloc] init];

    RACSignal *signal1 = nil;
    RACSignal *signal = nil;
    
     @weakify(self);
    
    if (self.vmType == GNVMTypeRegister) {

        
        signal1 = [[RACSignal combineLatest:@[RACObserve(self, inputAuthCode)]]
                              reduceEach:^id(NSString *authCode)
                              {
                                  return @(authCode.length == 4);
                              }];
        
        signal = [[RACSignal combineLatest:@[RACObserve(self, perfectInfo.phoneNumber),
                                             RACObserve(self, countDown)]]
                  reduceEach:^id(NSString *phoneNumber, NSNumber *countDown)
                  {
                      return @(phoneNumber.length == 11 && [countDown integerValue] == 0);
                  }];
    }
    else if(self.vmType == GNVMTypeUpdatePassword){

        
        signal1 = [[RACSignal combineLatest:@[RACObserve(self, self.phoneNumber),
                                              RACObserve(self, inputAuthCode),
                                              RACObserve(self, passwordNew),
                                              RACObserve(self, token)]]
                   reduceEach:^id(NSString *phoneNumber,NSString *inputAuthCode,NSString *passwordNew,NSString *token)
                   {
                       return @(phoneNumber.length == 11 && inputAuthCode.length == 4 &&passwordNew.length>=6 && passwordNew.length <=32 &&token.length>0);
                   }];
        
        signal = [[RACSignal combineLatest:@[RACObserve(self, phoneNumber),
                                             RACObserve(self, countDown)]]
                  reduceEach:^id(NSString *phoneNumber, NSNumber *countDown)
                  {
                      return @(phoneNumber.length == 11 && [countDown integerValue] == 0);
                  }];
    }

    self.getAuthCodeCommand = [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal *(id input)
                               {
                                   @strongify(self);
                                   
                                   [self getAuthCode];
                                   
                                   if (self.vmType == GNVMTypeUpdatePassword) {
                                       [self getLoginToken];
                                   }
                                   
                                   return [RACSignal empty];
                               }];
    
    
    self.nextCommand = [[RACCommand alloc] initWithEnabled:signal1 signalBlock:^RACSignal *(id input)
                        {
                            @strongify(self);
                            
                            [self verifyAuthCode];
                            
                            return [RACSignal empty];
                        }];
    
    
    
}

- (void)getAuthCode {
    
    GNGetAuthCodeNPS *nps = nil;
    if (self.vmType == GNVMTypeRegister) {
        nps = [GNGetAuthCodeNPS NPSWithPhoneNumber:self.perfectInfo.phoneNumber type:GNGetAuthCodeTypeRegister];
    }
    else if (self.vmType == GNVMTypeUpdatePassword)
    {
        nps = [GNGetAuthCodeNPS NPSWithPhoneNumber:self.phoneNumber type:GNGetAuthCodeTypeForgetPassword];
    }
    
    @weakify(self);
    
    [GNNetworkService GETWithService:nps success:^(id response, id model) {
        @strongify(self);
        
        [self startCoundDown];
        
        self.getAuthCodeResponse.success(response,model);
    } error:^(id response, NSInteger code) {
        @strongify(self);
        self.getAuthCodeResponse.error(response,code);
    } failure:^(id req, NSError *error) {
        @strongify(self);
        self.getAuthCodeResponse.failure(req,error);
    }];
}

- (void)verifyAuthCode {
    [self resgister];
}

-(void)getLoginToken{
    
    GNTokenNPS *nps = [GNTokenNPS NPSWithPhoneNumber];
    
    @weakify(self);
    
    [GNNetworkService GETWithService:nps success:^(id response, id model) {
        @strongify(self);
        self.token = response[@"_token"];
    } error:^(id response, NSInteger code) {
        @strongify(self);
        
        self.getAuthCodeResponse.error(response,code);
    } failure:^(id req, NSError *error) {
        @strongify(self);
        
        self.getAuthCodeResponse.failure(req,error);
    }];
    
}

- (void)resgister {
    
     @weakify(self);
    
    if (self.vmType == GNVMTypeRegister) {
        [SVProgressHUD showWithStatus:@"注册中" maskType:SVProgressHUDMaskTypeBlack];
        GNRegisterNPS *nps = [GNRegisterNPS NPSWithPhoneNumber:self.perfectInfo code:self.inputAuthCode];

        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            @strongify(self);
            
            self.nextResponse.success(response,model);
        } error:^(id response, NSInteger code) {
            @strongify(self);
            
            self.nextResponse.error(response,code);
        } failure:^(id req, NSError *error) {
            @strongify(self);
            
            self.nextResponse.failure(req,error);
        }];
        
    }
    else if (self.vmType == GNVMTypeUpdatePassword)
    {
        [SVProgressHUD showWithStatus:@"修改中，请稍等" maskType:SVProgressHUDMaskTypeBlack];
        GNUpdatePasswordNPS *nps = [GNUpdatePasswordNPS NPSWithPhoneNumber:self.phoneNumber password:self.passwordNew code:self.inputAuthCode token:self.token];
        
        [GNNetworkService POSTWithService:nps success:^(id response, id model) {
            @strongify(self);
            
            self.nextResponse.success(response,model);
        } error:^(id response, NSInteger code) {
            @strongify(self);
            
            self.nextResponse.error(response,code);
        } failure:^(id req, NSError *error) {
            @strongify(self);
            
            self.nextResponse.failure(req,error);
        }];
    }

}

- (void)updatePassword {
    
}

- (GNVMResponse *)loginResponse {
    if (!_loginResponse) {
        __weakify;
        _loginResponse = [GNVMResponse responseWithTaskBlock:^{
            __strongify;
            [self login];
        }];
    }
    return _loginResponse;
}

- (void)login {
    
    GNLoginNPS *nps = [GNLoginNPS NPSWithPhoneNumber:self.perfectInfo.phoneNumber password:self.perfectInfo.passWord];
    
    @weakify(self);
    
    [GNNetworkService POSTWithService:nps success:^(id response, id model) {
        @strongify(self);
        self.loginResponse.success(response, model);
    } error:^(id response, NSInteger code) {
        @strongify(self);
        
        self.loginResponse.error(response,code);
    } failure:^(id req, NSError *error) {
        @strongify(self);
        
        self.loginResponse.failure(req,error);
    }];
}


@end
