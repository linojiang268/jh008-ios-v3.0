//
//  GNAboutUs.m
//  GatherNew
//
//  Created by yuanjun on 15/9/22.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNAboutUs.h"
#import "GNWebViewVC.h"


#define  JH_WEB_PAGE @"www.jh008.com"
#define  JH_COOPERATION_EMAIL @"yds@jh008.com"
#define  JH_CONTACT @"400-876-1176"



@interface GNAboutUs ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyWebPageLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyCooperationLabel;


@end

@implementation GNAboutUs


+ (UIStoryboard *)storyboard{
    return [GNUI publicUI];
}


+ (NSString *)sbIdentifier {
    return @"about_us";
}


-(void)setupUI{
    [super setupUI];
    
    self.scrollView.bounces = YES;
    
    NSString* webPageInfo = [NSString stringWithFormat:@"网址：%@ (社团&活动管理入口)", JH_WEB_PAGE];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:webPageInfo];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:kUIColorWithHexUint(GNUIColorOrange)
                       range:[webPageInfo rangeOfString:JH_WEB_PAGE]];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:kUIColorWithHexUint(0xFF9D9D9D)
                       range:[webPageInfo rangeOfString:@"(社团&活动管理入口)"]];
    
    self.companyWebPageLabel.attributedText = attrString;
    
    
    
    NSString* cooperation = [NSString stringWithFormat:@"商务合作：%@", JH_COOPERATION_EMAIL];
    NSMutableAttributedString *cooperationAttrString = [[NSMutableAttributedString alloc] initWithString:cooperation];
    [cooperationAttrString addAttribute:NSForegroundColorAttributeName
                       value:kUIColorWithHexUint(GNUIColorOrange)
                       range:[cooperation rangeOfString:JH_COOPERATION_EMAIL]];
    self.companyCooperationLabel.attributedText = cooperationAttrString;
    
    
    
    self.companyContactLabel.text = [NSString stringWithFormat:@"电话：%@", JH_CONTACT];;
    self.companyContactLabel.userInteractionEnabled = YES;
    [self.companyContactLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(onCompanyContactLabelClick)]];
    
    self.companyWebPageLabel.userInteractionEnabled = YES;
    [self.companyWebPageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(onCompanyWebPageLabelClick)]];
    
    
    self.companyCooperationLabel.userInteractionEnabled = YES;
    [self.companyCooperationLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(onCompanyCooperationLabelClick)]];
    
    
}


-(void)onCompanyContactLabelClick{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@", JH_CONTACT];
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

-(void)onCompanyWebPageLabelClick{
//    GNWebViewVC *controller = [[GNWebViewVC alloc] initWithTitle:@"集合" url:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",JH_WEB_PAGE]]];
//    [self.navigationController pushVC:controller animated:YES];
}

-(void)onCompanyCooperationLabelClick{
//    NSMutableString *mailUrl = [[NSMutableString alloc]init];
//    //添加收件人
//    [mailUrl appendFormat:@"mailto:%@", JH_COOPERATION_EMAIL];
//    //添加抄送
//    [mailUrl appendFormat:@"?cc=%@", @""];
//    //添加密送
//    [mailUrl appendFormat:@"&bcc=%@", @""];
//    //添加主题
//    [mailUrl appendString:@"&subject="];
//    //添加邮件内容
//    [mailUrl appendString:@"&body="];
//    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

@end
