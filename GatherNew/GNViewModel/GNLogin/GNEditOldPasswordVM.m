//
//  GNEditOldPasswordVM.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/8.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNEditOldPasswordVM.h"
#import "GNUpdatePasswordNPS.h"

@implementation GNEditOldPasswordVM
- (void)initModel {
    
    self.nextResponce = [[GNVMResponse alloc] init];
    
    __weakify;
    
    RACSignal *signal = [[RACSignal combineLatest:@[RACObserve(self, oldPassword),
                                                    RACObserve(self, firstPassword)]]
                         reduceEach:^id(NSString *oldPassword, NSString *firstPassword)
                         {
                             return @(firstPassword.length <= 17 && firstPassword.length >=6);
                         }];
    
    self.nextCommand = [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal *(id input)
                        {
                            __strongify;
                            
                            [SVProgressHUD showWithStatus:@"修改中，请稍等" maskType:SVProgressHUDMaskTypeBlack];
                            GNUpdateOldPasswordNPS *nps = [GNUpdateOldPasswordNPS NPSWithOldPassword:self.oldPassword newPassword:self.firstPassword];
                            
                            
                            [GNNetworkService POSTWithService:nps success:^(id response, id model) {
                                [SVProgressHUD dismiss];
                                self.nextResponce.success(response, model);
                                
                            } error:self.nextResponce.error failure:self.nextResponce.failure];
                            
                            return [RACSignal empty];
                        }];
}
@end
