//
//  GNActivitySignInSearchVC.m
//  GatherNew
//
//  Created by yuanjun on 15/10/20.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivitySignInManageSearchVC.h"
#import "GNActivitySignInManageCell.h"
#import "GNActivitySignInManageVM.h"
#import "GNActivityManageNPS.h"
#import "GNNetworkService.h"
#import "UIScrollView+XBRefreshExtension.h"
#import "GNActivitySignInManageVC.h"

@interface GNActivitySignInManageSearchVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UITextField* searchTextField;
@property(nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) GNActivitySignInManageVM *viewModel;

@end

@implementation GNActivitySignInManageSearchVC


+ (instancetype)initWithActivityId:(NSUInteger)activityId subStaus:(NSUInteger)subStaus manageVC:(GNActivitySignInManageVC *)manageVC {
    GNActivitySignInManageSearchVC * vc = [[GNActivitySignInManageSearchVC alloc]init];
    vc.activityId = activityId;
    vc.subStaus = subStaus;
    vc.manageVC = manageVC;
    return vc;
}

- (void) setupUI {
    [super setupUI];
    self.title = @"搜索签到列表";
    [self.view addSubview:[self searchTextField]];
    [self.view addSubview:[self tableView]];
}

- (void)binding {
    self.viewModel = [GNActivitySignInManageVM initWithActivity:self.activityId];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
}


- (UITextField *)searchTextField {
    if(!_searchTextField){
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kUIScreenWidth - 40, 40)];
        _searchTextField.backgroundColor = [UIColor whiteColor];
        _searchTextField.font = [UIFont systemFontOfSize:GNUIFontSize14];
        _searchTextField.textColor = kUIColorWithHexUint(GNUIColorGrayBlack);
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeUnlessEditing;
        _searchTextField.placeholder = @"请输入姓名或手机号";
        
        
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.enablesReturnKeyAutomatically = YES;
        _searchTextField.delegate = self;
        
        UIImageView *leftContentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_gray_black"]];
        CGRect r = leftContentView.frame;
        r.size.width += 10;
        
        UIView *leftView = [[UIView alloc] initWithFrame:r];
        [leftView addSubview:leftContentView];
        [leftContentView setCenter:leftView.center];
        
        _searchTextField.leftView = leftView;
        kUIRoundCorner(_searchTextField, [UIColor clearColor], 0, 3);
    }
    
    return _searchTextField;
}


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kUIScreenWidth, self.view.bounds.size.height - 60) style:UITableViewStylePlain];
        _tableView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        
        [_tableView registerNib:[GNActivitySignInManageCell nib] forCellReuseIdentifier:kUICellIdentifier];
    }
    
    return _tableView;
}


-(void) seachText: (NSString*) searchText{
    [self.viewModel searchSignInList:self.activityId search:searchText
     success:^(id response, GNActivityCheckInListModel *model) {
        
         self.viewModel.searchList = model.checkins;
         [self.tableView reloadData];
         [self.tableView endAllRefresh];
     }
     error:^(id response, NSInteger code) {
         
         [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
         [self.tableView endAllRefresh];
         
     } failure:^(id req, NSError *error) {
         
         [self.tableView endAllRefresh];
     }];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self seachText:textField.text];
    [textField resignFirstResponder];
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.searchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivitySignInManageCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GNActivityCheckInModel* who = [self.viewModel.searchList objectAtIndex:indexPath.row];
    __weakify;
    [cell bindingModel:who subStatus:self.subStaus OnCheckInClick:^(GNActivityCheckInModel *who) {
        __strongify;
        NSString* message;
        
        if(who.status == 0){
            message = [NSString stringWithFormat:@"确定为 %@ 签到", who.name];
        }else{
            message = [NSString stringWithFormat:@"确定为 %@ 取消签到", who.name];
        }
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        objc_setAssociatedObject(alertView, @"GNActivityCheckInModel", who, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        alertView.tag = 0x100;
        [alertView show];
    }];
    return cell;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1 && alertView.tag == 0x100){
        GNActivityCheckInModel* who = objc_getAssociatedObject(alertView, @"GNActivityCheckInModel");
        [self setCheckIn:who];
    }
}


-(void)setCheckIn:(GNActivityCheckInModel *)who{
    __weakify;
    [SVProgressHUD showWithStatus:@"正在更改状态，请稍后" maskType:SVProgressHUDMaskTypeBlack];
    [self.viewModel manualCheckIn:self.activityId setp:1 userId:who.user_id approve:!who.status success:^(id response, id model) {
        __strongify;
        [SVProgressHUD dismiss];
        if(who.status == 0){
            who.status = 1;
        }else{
            who.status = 0;
        }
        
        [self.tableView reloadData];
        
        NSString* message = [NSString stringWithFormat:@"%@ %@", who.name, (who.status ? @"已签到" : @"已取消签到")];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        [self.manageVC refreshDataAfterSearch];
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD dismiss];
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:(who.status ? @"取消签到失败" : @"签到失败") message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } failure:^(id req, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
@end
