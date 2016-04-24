//
//  GNActivityDetailVC.m
//  GatherNew
//
//  Created by yuanjun on 15/9/21.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityDetailVC.h"
#import "BannerView.h"
#import "UIColor+GNExtension.h"

@interface GNActivityDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation GNActivityDetailVC


+ (NSString *)sbIdentifier {
    return @"activity_detail";
}

-(void)viewWillDisappear:(BOOL)animated{
    [self showCustomerNavigationBar:NO];
    [super viewWillDisappear:animated];
}


-(void)showCustomerNavigationBar:(BOOL)show{
    if(show){
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor blueColor]] forBarMetrics:UIBarMetricsDefault];
        
        self.navigationController.navigationBar.alpha = 0.5;
        
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }else{
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}


- (void)setupUI {
    [super setupUI];
    [self showCustomerNavigationBar:YES];
    
    //TODO: make tableview edge insets to fit navigation bar
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    BannerView *headerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth*1/2)];
    headerView.backgroundColor = [UIColor redColor];
//    NSMutableArray *urls = [[NSMutableArray alloc] init];
//    for (GNMainBannerItemModel *item in self.viewModel.bannerArray) {
//        [urls addObject:item.image_url];
//    }
//    
//    headerView.imageItems = urls;
    
    self.tableView.tableHeaderView = headerView;
    
    
}







- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
