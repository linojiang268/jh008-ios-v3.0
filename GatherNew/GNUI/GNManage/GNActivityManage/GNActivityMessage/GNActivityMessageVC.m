//
//  GNActivityMessageVC.m
//  GatherNew
//
//  Created by yuanjun on 15/10/12.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityMessageVC.h"
#import "GNActivityManageVM.h"

@interface GNActivityMessageVC () <UITextViewDelegate>

@property(nonatomic, strong) UILabel* leftTimesLabel;
@property(nonatomic, strong) UILabel* recvLabel;
@property(nonatomic, strong) UITextView* recvMessageTextView;
@property(nonatomic, strong) UITextView* recvMessageTextViewPlaceHolder;
@property(nonatomic, strong) UITextField* recvMessageLeftTextField;
@property(nonatomic, strong) GNActivityManageVM* viewModel;


@end

@implementation GNActivityMessageVC


+ (instancetype)initWithActivity:(NSUInteger)activityId {
    GNActivityMessageVC * vc = [[GNActivityMessageVC alloc]init];
    vc.activityId = activityId;
    return vc;
}


- (void)setupUI {
    [super setupUI];
    self.title = @"通知";
    
    UIBarButtonItem *sendButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage)];
    self.navigationItem.rightBarButtonItems = @[sendButtonItem];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, [self heightForRecvLabel] + [self heightForLeftTimesLabel] + [self heightForRecvMessageTextView] + 0.5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    [view addSubview:self.leftTimesLabel];
    [view addSubview:self.recvLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(10, [self heightForLeftTimesLabel] + [self heightForRecvLabel], kUIScreenWidth - 20, 0.5)];
    line.backgroundColor = kUIColorWithHexUint(GNUIColorGray);
    
    [view addSubview: line];
    [view addSubview:self.recvMessageTextViewPlaceHolder];
    [view addSubview:self.recvMessageTextView];
    [view addSubview:self.recvMessageLeftTextField];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.recvMessageTextView becomeFirstResponder];
}


- (void)binding {
    self.viewModel = [[GNActivityManageVM alloc]init];
    __weakify;
    [self.viewModel getLeftMessageForActivity:self.activityId success:^(id response, id model) {
        __strongify;
        NSInteger leftTimes = [[response objectForKey:@"rest_times"] integerValue];
        NSString* string = [NSString stringWithFormat:@"短信发送，还剩 %ld 次",(long)leftTimes];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        [attrString addAttribute:NSForegroundColorAttributeName
                               value:[UIColor redColor]
                               range:[string rangeOfString:[NSString stringWithFormat:@"%ld",(long)leftTimes]]];
        
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:16]
                           range:[string rangeOfString:[NSString stringWithFormat:@"%ld",(long)leftTimes]]];
        
        
        self.leftTimesLabel.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
        self.leftTimesLabel.attributedText = attrString;
        [self.navigationItem.rightBarButtonItems firstObject].enabled = YES;
    } error:^(id response, NSInteger code) {
        __strongify;
        self.leftTimesLabel.text = [response objectForKey:@"message"];
        self.leftTimesLabel.textColor = kUIColorWithHexUint(GNUIColorOrange);
        [self.navigationItem.rightBarButtonItems firstObject].enabled = NO;
    } failure:^(id req, NSError *error) {
        
    }];
}


-(CGFloat)heightForLeftTimesLabel{
    return 32;
}

- (UILabel*)leftTimesLabel {
    if(!_leftTimesLabel){
        _leftTimesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, [self heightForLeftTimesLabel])];
        _leftTimesLabel.backgroundColor = self.view.backgroundColor;
        _leftTimesLabel.textAlignment = NSTextAlignmentCenter;
        _leftTimesLabel.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
        _leftTimesLabel.font = [UIFont systemFontOfSize:14];
        
        NSString* string = @"短信发送，还剩 -- 次";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        //    [attrString addAttribute:NSForegroundColorAttributeName
        //                       value:[UIColor redColor]
        //                       range:[string rangeOfString:@"--"]];
        
        _leftTimesLabel.attributedText = attrString;
        
        return _leftTimesLabel;
    }
    return _leftTimesLabel;
}

-(CGFloat)heightForRecvLabel{
    return 30;
}

- (UILabel*)recvLabel {
    if(!_recvLabel){
        _recvLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, [self heightForLeftTimesLabel], kUIScreenWidth, [self heightForRecvLabel])];
        _recvLabel.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
        _recvLabel.textAlignment = NSTextAlignmentLeft;
        _recvLabel.textColor = kUIColorWithHexUint(0xFF6E7076);
        _recvLabel.font = [UIFont systemFontOfSize:14];
        _recvLabel.text = @"收件人：报名成功人员";
        
        return _recvLabel;
    }
    
    return _recvLabel;
}


-(CGFloat)heightForRecvMessageTextView{
    return 188;
}

- (UITextView*)recvMessageTextView {
    if(!_recvMessageTextView){
        _recvMessageTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, [self heightForLeftTimesLabel] + [self heightForRecvLabel] + 0.5, kUIScreenWidth-20, [self heightForRecvMessageTextView])];
        _recvMessageTextView.backgroundColor = [UIColor clearColor];
        _recvMessageTextView.textAlignment = NSTextAlignmentLeft;
        _recvMessageTextView.textColor = kUIColorWithHexUint(GNUIColorBlack);
        _recvMessageTextView.font = [UIFont systemFontOfSize:14];
        _recvMessageTextView.delegate = self;
        
        return _recvMessageTextView;
    }
    
    return _recvMessageTextView;
}

- (UITextView*)recvMessageTextViewPlaceHolder {
    if(!_recvMessageTextViewPlaceHolder){
        _recvMessageTextViewPlaceHolder = [[UITextView alloc]initWithFrame:CGRectMake(10, [self heightForLeftTimesLabel] + [self heightForRecvLabel] + 0.5, kUIScreenWidth - 20, [self heightForRecvMessageTextView])];
        _recvMessageTextViewPlaceHolder.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
        _recvMessageTextViewPlaceHolder.textAlignment = NSTextAlignmentLeft;
        _recvMessageTextViewPlaceHolder.textColor = kUIColorWithHexUint(0xFFD0D0D2);
        _recvMessageTextViewPlaceHolder.font = [UIFont systemFontOfSize:14];
        _recvMessageTextViewPlaceHolder.text = @"编辑文字信息";
        _recvMessageTextViewPlaceHolder.editable = NO;
        
        return _recvMessageTextViewPlaceHolder;
    }
    
    return _recvMessageTextViewPlaceHolder;
}


- (UITextField*)recvMessageLeftTextField {
    if(!_recvMessageLeftTextField){
        _recvMessageLeftTextField = [[UITextField alloc]initWithFrame:CGRectMake(kUIScreenWidth-100-12, [self heightForRecvLabel] + [self heightForLeftTimesLabel] + [self heightForRecvMessageTextView] + 0.5 - 20 - 12, 100, 20)];
        _recvMessageLeftTextField.textAlignment = NSTextAlignmentRight;
        _recvMessageLeftTextField.textColor = kUIColorWithHexUint(0xFFD0D0D2);
        _recvMessageLeftTextField.font = [UIFont systemFontOfSize:14];
        _recvMessageLeftTextField.enabled = NO;
        _recvMessageLeftTextField.text = @"0/60";
        
        return _recvMessageLeftTextField;
    }
    
    return _recvMessageLeftTextField;
}



-(void)textViewDidChange:(UITextView *)textView {
    NSInteger length = [textView.text length];
    self.recvMessageTextViewPlaceHolder.text = (length == 0 ? @"编辑文字信息" : @"");
    self.recvMessageLeftTextField.text = [NSString stringWithFormat:@"%ld/60", (long)length];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return ![text isEqualToString:@"\n"];
}


- (void)sendMessage {
    NSInteger length = [self.recvMessageTextView.text length];
    if(length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入信息内容"];
    }else if (length > 60){
        [SVProgressHUD showErrorWithStatus:@"信息内容\n超过最大字符限制60"];
    }
    else{
        [SVProgressHUD showWithStatus:@"发送中，请稍后" maskType:SVProgressHUDMaskTypeBlack];
        [self.viewModel sendMessageForActivity:self.activityId content:self.recvMessageTextView.text success:^(id response, id model) {
            [SVProgressHUD dismiss];
            [self.viewModel.getActivityLeftMessageResponse start];
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } error:^(id response, NSInteger code) {
            [SVProgressHUD dismiss];
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } failure:^(id req, NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"发送失败，请检查网络连接！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    }

}


@end
