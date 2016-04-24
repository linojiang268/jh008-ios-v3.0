//
//  GNActivityApplyPayListVC.m
//  GatherNew
//
//  Created by Culmore on 15/10/4.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplyPayListVC.h"
#import "GNActivityApplyPayListCell.h"
#import "GNActivityApplyVM.h"
#import "GNActivityApplyListModel.h"
#import "NSString+Extension.h"

@interface GNActivityApplyPayListVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) GNActivityApplyVM *viewModel;
@property(nonatomic, strong) UIView* attrsView;

@end

@implementation GNActivityApplyPayListVC


+(instancetype)initWithActivity:(NSInteger)activityId controller:(UIViewController*)controller {
    GNActivityApplyPayListVC* vc = [[GNActivityApplyPayListVC alloc]init];
    vc.activityId = activityId;
    vc.controller = controller;
    return vc;
}


- (void)setupUI {
    [super setupUI];
    self.title = @"待支付";
    self.tableView.tableHeaderView = [self createTotalView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerNib:[GNActivityApplyPayListCell nib] forCellReuseIdentifier:@"GNActivityApplyPayListCell"];
    
    [self createAttrView];
}


- (void)binding {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addRefreshAndLoadMore];
    
    self.viewModel = [[GNActivityApplyVM alloc]initWithActivity:self.activityId status:FEE];
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    [self.viewModel.getApplyListResponse start:NO success:^(id response, GNActivityApplyListModel *model) {
        __strongify;
        [self.tableView reloadData];
        [self.tableView setTotalPage:model.pages];
        [self.tableView endAllRefresh];
        
        if(self.viewModel.total == 0){
            ((UILabel *)[self.tableView.tableHeaderView viewWithTag:1]).text = @"";
            [self.tableView showHintViewWithType:XBHintViewTypeNoData message:@"待交费列表为空，点击刷新！" tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showInfoWithStatus: [response objectForKey:@"message"]];
        [self.tableView endAllRefresh];
    } failure:^(id req, NSError *error) {
        [self.tableView endAllRefresh];
        if([self.viewModel.applyList count] == 0){
            ((UILabel *)[self.tableView.tableHeaderView viewWithTag:1]).text = @"";
            [self.tableView showHintViewWithType:XBHintViewTypeNetworkError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
    }];
    
    [self.tableView refresh];
}

- (UIView *)createTotalView{
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 35)];
    containView.backgroundColor = self.view.backgroundColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kUIScreenWidth - 20, 14)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 1;
    label.text = @"共计：--人";
    [containView addSubview:label];
    return containView;
}



- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.attrsView removeFromSuperview];
}

-(UIView*)createAttrView{
    self.attrsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight)];
    self.attrsView.backgroundColor = kUIColorWithHexUint(0xbb000000);
    if(self.controller){
        [self.controller.navigationController.view addSubview:self.attrsView];
    }else{
        [self.navigationController.view addSubview:self.attrsView];
    }
    self.attrsView.hidden = YES;
    self.attrsView.userInteractionEnabled = YES;
    [self.attrsView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAttrView)]];
    return self.attrsView;
}

-(void)hideAttrView {
    self.attrsView.hidden = YES;
}

-(void)showAttrView:(NSString*)applyTime fee:(NSString*)fee attrs:(NSArray*)attrs{
    UIScrollView* scrollView = (UIScrollView*)[self.attrsView viewWithTag:1];
    if(!scrollView){
        scrollView = [[UIScrollView alloc]init];
    }else{
        for (UIView* view in [scrollView subviews]) {
            [view removeFromSuperview];
        }
    }
    
    static float DEFAULT_LINE_SPACE = 10;
    
    float height = 0, offset = DEFAULT_LINE_SPACE;
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] init];
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textColor = kUIColorWithHexUint(GNUIColorBlack);
        
        NSString *info = @"";
        switch (i) {
            case 0:
                info = [NSString stringWithFormat:@"报名时间：%@",applyTime];
                break;
            case 1:
                info = [NSString stringWithFormat:@"报名费用：%@",fee];
                label.textColor = kUIColorWithHexUint(GNUIColorOrange);
                break;
            default:
                break;
        }
        CGSize size  = [info mesure:[UIFont systemFontOfSize:12]];
        height = ceil(size.height);
        [label setFrame:CGRectMake(10, offset, kUIScreenWidth*3/4, height)];
        
        offset += (DEFAULT_LINE_SPACE + height);
        
        label.text = info;
        [scrollView addSubview:label];
    }
    
    for (GNActivityApplyAttrModel* attr in attrs) {
        UILabel *label = [[UILabel alloc] init];
        [label setNumberOfLines:0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        NSString *info = [NSString stringWithFormat:@"%@：%@", attr.key, attr.value];
        
        CGSize size  = [info mesure:[UIFont systemFontOfSize:12]];
        height = ceil(size.height);
        [label setFrame:CGRectMake(10, offset, kUIScreenWidth*3/4, height)];
        
        offset += (DEFAULT_LINE_SPACE + height);
        
        label.text = info;
        label.textColor = kUIColorWithHexUint(GNUIColorBlack);
        [scrollView addSubview:label];
    }
    
    [scrollView setFrame:CGRectMake(0, 0, kUIScreenWidth*3/4+20, MIN(offset, kUIScreenHeight - 200))];
    [scrollView setContentSize:CGSizeMake(kUIScreenWidth*3/4+20, offset)];
    scrollView.center = self.attrsView.center;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.layer.masksToBounds = YES;
    scrollView.layer.cornerRadius = 5.0f;
    
    [self.attrsView addSubview:scrollView];
    self.attrsView.hidden = NO;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ((UILabel*)[tableView.tableHeaderView viewWithTag:1]).text = [NSString stringWithFormat:@"共计：%ld人", (long)self.viewModel.total];
    return [self.viewModel.applyList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityApplyModel* who = [self.viewModel.applyList objectAtIndex:indexPath.row];
    GNActivityApplyPayListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GNActivityApplyPayListCell" forIndexPath:indexPath];
    [cell setName:who.name phone:who.mobile fee:who.enroll_fee item:indexPath.row OnDetailButtonClicked:^(NSInteger item) {
        [self onDetailButtonClicked:item];
    }];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}


-(void)onDetailButtonClicked:(NSInteger)item{
    GNActivityApplyModel* who = [self.viewModel.applyList objectAtIndex:item];
    NSString* feeString = @"免费";
    if(who.enroll_fee > 0){
        if(who.enroll_fee % 100 == 0){
            feeString = [NSString stringWithFormat:@"%ld元", (long)(who.enroll_fee/100)];
        }else{
            feeString = [NSString stringWithFormat:@"%.2f元", ((float)who.enroll_fee)/100.0];
        }
    }
    [self showAttrView:who.applicant_time fee:feeString attrs:who.attrs];
}

@end
