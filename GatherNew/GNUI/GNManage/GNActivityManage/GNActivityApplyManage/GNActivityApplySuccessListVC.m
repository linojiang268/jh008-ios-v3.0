//
//  GNActivityApplySuccessListVC.m
//  GatherNew
//
//  Created by yuanjun on 15/9/30.
//  Copyright © 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityApplySuccessListVC.h"
#import "GNActivityApplySuccessListCell.h"
#import "GNActivityApplyVM.h"
#import "GNActivityApplyListModel.h"


@interface GNActivityApplySuccessListVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UIAlertView *noteDialog;
@property(nonatomic, strong) GNActivityApplyVM *viewModel;


@end

@implementation GNActivityApplySuccessListVC

+(instancetype)initWithActivity:(NSInteger) activityId {
    GNActivityApplySuccessListVC* vc = [[GNActivityApplySuccessListVC alloc]init];
    vc.activityId = activityId;
    return vc;
}

- (void)setupUI {
    [super setupUI];
    self.title = @"已成功";
    self.tableView.tableHeaderView = [self createTotalView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerNib:[GNActivityApplySuccessListCell nib] forCellReuseIdentifier:@"GNActivityApplySuccessListCell"];
    
    self.noteDialog = [[UIAlertView alloc] initWithTitle:@"" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"备注", nil];
    [self.noteDialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[self.noteDialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
}

-(void)refreshTableAfterAddNew {//手动添加报名后要刷新列表数据
    [self.tableView refresh];
}

- (void)binding {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView addRefreshAndLoadMore];
    
    self.viewModel = [[GNActivityApplyVM alloc]initWithActivity:self.activityId status:SUCCESS];
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    [self.viewModel.getApplyListResponse start:NO success:^(id response, GNActivityApplyListModel *model) {
        __strongify;
        [self.tableView reloadData];
        [self.tableView setTotalPage:model.pages];
        [self.tableView endAllRefresh];
        
        if(self.viewModel.total == 0){
            ((UILabel *)[self.tableView.tableHeaderView viewWithTag:1]).text = @"";
            [self.tableView showHintViewWithType:XBHintViewTypeNoData message:@"已成功列表为空，点击刷新！" tapHandler:^(UIView *tapView) {
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ((UILabel *)[self.tableView.tableHeaderView viewWithTag:1]).text = [NSString stringWithFormat:@"共计：%ld人", (long)self.viewModel.total];
    return [self.viewModel.applyList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        UITextField *textField=[alertView textFieldAtIndex:0];
        if([textField.text length] == 0){
            return;
        }
        
//        if([textField.text length] > 10){
//            [SVProgressHUD showInfoWithStatus: @"最多10个字"];
//            return;
//        }
        
         GNActivityApplyModel* who = [self.viewModel.applyList objectAtIndex:self.noteDialog.tag];
        __weakify;
        [self.viewModel setApplyApplicant:who.id note:textField.text success:^(id response, id model) {
            __strongify;
            who.remark = [NSString stringWithString:textField.text];
            [self.tableView reloadData];
        } error:^(id response, NSInteger code) {
            [SVProgressHUD showInfoWithStatus: [response objectForKey:@"message"]];
        } failure:^(id req, NSError *error) {
            
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityApplySuccessListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GNActivityApplySuccessListCell"];
    
    GNActivityApplyModel* who = [self.viewModel.applyList objectAtIndex:indexPath.row];
    
    __weakify;
    [cell setName:who.name phone:who.mobile note:who.remark fee:who.enroll_fee item:indexPath.row OnNoteClicked:^(NSInteger item) {
        __strongify;
        UITextField *textField=[self.noteDialog textFieldAtIndex:0];
        textField.text = @"";
        self.noteDialog.tag = item;
        [self.noteDialog show];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITextField *textField=[self.noteDialog textFieldAtIndex:0];
    textField.text = @"";
    self.noteDialog.tag = indexPath.row;
    [self.noteDialog show];
}


@end
