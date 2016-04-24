//
//  GNActivityApplyVerifyListVC.m
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import <Masonry.h>
#import "GNActivityApplyVerifyListVC.h"
#import "GNActivityApplyVM.h"
#import "GNActivitiyApplyVerifyListCell.h"
#import "GNActivityApplyListModel.h"
#import "NSString+Extension.h"

@interface GNActivityApplyVerifyListVC () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UIView* optionView;
@property(nonatomic, strong) UIView* attrsView;
@property(nonatomic, strong) GNActivityApplyVM *viewModel;

@property(nonatomic, assign) NSInteger selectedRef;
@property(nonatomic, assign) BOOL isOptionViewShow;

@property(nonatomic, strong) NSMutableArray* selectedIds;
@property(nonatomic, strong) NSMutableArray* selectedPerson;

@end

@implementation GNActivityApplyVerifyListVC

+(instancetype)initWithActivity:(NSInteger)activityId controller:(UIViewController*)controller {
    GNActivityApplyVerifyListVC* vc = [[GNActivityApplyVerifyListVC alloc]init];
    vc.activityId = activityId;
    vc.controller = controller;
    return vc;
}


- (void)setupUI {
    [super setupUI];
    self.title = @"待审核";
    self.selectedIds = [NSMutableArray array];
    self.selectedPerson = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.tableHeaderView = [self createTotalView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.bottom.equalTo(@0);
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    self.tableView.delaysContentTouches = NO;
    [self createOptionView];
    [self createAttrView];
    
}


- (void)binding {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[GNActivitiyApplyVerifyListCell nib] forCellReuseIdentifier:@"GNActivitiyApplyVerifyListCell"];
    
    [self.tableView addRefreshAndLoadMore];
    self.viewModel = [[GNActivityApplyVM alloc]initWithActivity:self.activityId status:APPLY];
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    [self.viewModel.getApplyListResponse start:NO success:^(id response, GNActivityApplyListModel *model) {
        __strongify;
        [self.tableView reloadData];
        [self.tableView setTotalPage:model.pages];
        [self.tableView endAllRefresh];
        if(self.viewModel.total == 0){
            ((UILabel *)[self.tableView.tableHeaderView viewWithTag:1]).text = @"";
            [self.tableView showHintViewWithType:XBHintViewTypeNoData message:@"待审核列表为空，点击刷新！" tapHandler:^(UIView *tapView) {
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


- (void)createOptionView {
    self.optionView = [[UIView alloc]init];
    self.optionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.optionView];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 1)];
    line.backgroundColor = kUIColorWithHexUint(0xFFC5D2D8);
    [self.optionView addSubview:line];
    
    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"manage_apply_ok"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"manage_apply_ok_pressed"] forState:UIControlStateHighlighted];
    [okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.optionView addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.left.equalTo(@(10));
        make.height.equalTo(@(35));
        make.width.equalTo(@(100));
    }];
    
    UIButton* refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseButton setBackgroundImage:[UIImage imageNamed:@"manage_apply_refuse"] forState:UIControlStateNormal];
    [refuseButton setBackgroundImage:[UIImage imageNamed:@"manage_apply_refuse_pressed"] forState:UIControlStateHighlighted];
    [refuseButton addTarget:self action:@selector(refuseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.optionView addSubview:refuseButton];
    [refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@7);
        make.height.equalTo(@(35));
        make.width.equalTo(@(100));
        make.right.equalTo(@(-10));
    }];

    [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.equalTo(@(0));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
}

-(void)approveSelectedApplicants:(BOOL) yesOrNo {
    if(self.selectedRef > 0){
        [SVProgressHUD showWithStatus:@"提交中" maskType:SVProgressHUDMaskTypeBlack];
        __weakify;
        [self.viewModel setApplyApplicantApprove:self.selectedIds status:yesOrNo success:^(id response, id model) {
            __strongify;
            [self.viewModel.applyList removeObjectsInArray:self.selectedPerson];
            [self.selectedIds removeAllObjects];
            [self.selectedPerson removeAllObjects];
            self.selectedRef = 0;
            [self adjustOptionView];
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            
            if ([self.viewModel.applyList count] < (DEFAULT_APPLY_LIST_SIZE/3)){
                [self.tableView refresh];
            }
        } error:^(id response, NSInteger code) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        } failure:^(id req, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)okButtonClicked {
    [self approveSelectedApplicants:YES];
}


- (void)refuseButtonClicked {
    [self approveSelectedApplicants:NO];
}

- (UIView *)createTotalView {
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
    
    CGFloat frameHeight = MIN(offset, kUIScreenHeight - 200);
    
    [scrollView setFrame:CGRectMake(0, 0, kUIScreenWidth*3/4+20, frameHeight)];
    [scrollView setContentSize:CGSizeMake(kUIScreenWidth*3/4+20, offset)];
    scrollView.center = self.attrsView.center;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.layer.masksToBounds = YES;
    scrollView.layer.cornerRadius = 5.0f;
    
    [self.attrsView addSubview:scrollView];
    self.attrsView.hidden = NO;
}

- (void)setTotal:(NSString*)fmt count:(NSInteger)count {
    ((UILabel*)[self.tableView.tableHeaderView viewWithTag:1]).text = [NSString stringWithFormat:fmt, (long)count];
}

- (void)adjustOptionView {
    if(self.selectedRef > 0){
        [self setTotal:@"已选择：%ld人" count:[self.selectedPerson count]];
        if(!self.isOptionViewShow){
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(0));
                make.bottom.equalTo(@-49);
                make.left.equalTo(@(0));
                make.right.equalTo(@(0));
            }];
            [self.optionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.height.equalTo(@(49));
                make.left.equalTo(@(0));
                make.right.equalTo(@(0));
            }];
        }
        self.isOptionViewShow = YES;
    }else{
        [self setTotal:@"共计：%ld人" count:self.viewModel.total];
        if(self.isOptionViewShow){
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(0));
                make.bottom.equalTo(@0);
                make.left.equalTo(@(0));
                make.right.equalTo(@(0));
            }];
            [self.optionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.height.equalTo(@(0));
                make.left.equalTo(@(0));
                make.right.equalTo(@(0));
            }];
        }
        self.isOptionViewShow = NO;
    }
}

- (void)onSelected:(NSInteger)item selected:(BOOL)selected {
    GNActivityApplyModel* who = [self.viewModel.applyList objectAtIndex:item];
    [who setSelected:selected];
    if(selected){
        [self.selectedIds addObject:[NSString stringWithFormat:@"%ld", who.id]];
        [self.selectedPerson addObject:who];
        self.selectedRef++;
    }else{
        [self.selectedIds removeObject:[NSString stringWithFormat:@"%ld", who.id]];
        [self.selectedPerson removeObject:who];
        self.selectedRef--;
    }
    
    [self adjustOptionView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self setTotal:@"共计：%ld人" count:self.viewModel.total];
    return [self.viewModel.applyList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityApplyModel* who = [self.viewModel.applyList objectAtIndex:indexPath.row];
    GNActivitiyApplyVerifyListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GNActivitiyApplyVerifyListCell" forIndexPath:indexPath];
    
    __weakify;
    [cell setName:who.name phone:who.mobile fee:who.enroll_fee item:indexPath.row selected:[who getSelected] OnSelected:^(NSInteger item, BOOL selected) {
        __strongify;
        [self onSelected:item selected:selected];
    } OnDetailButtonClicked:^(NSInteger item) {
        __strongify;
        [self onDetailButtonClicked:item];
    }];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    [self onDetailButtonClicked:indexPath.row];
     */
}


- (void)onDetailButtonClicked:(NSInteger)item {
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
