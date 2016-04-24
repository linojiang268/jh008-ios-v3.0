//
//  GNMeActivityVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/8/6.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMeActivityVC.h"
#import "GNMenuOptionVC.h"
#import "GNMeActivityCell.h"
#import <Masonry.h>
#import "GNMeActivityListVM.h"
#import "GNActivityListModel.h"
#import "GNActivityDetailsVC.h"
#import "GNActivityManualVC.h"

#define kUITableViewCellHeader @"tableViewCellActivity"

@interface GNMeActivityVC ()<UITableViewDataSource,UITableViewDelegate,XBTableViewRefreshDelegate>

@property (nonatomic, strong) GNMenuOptionVC *menu;

@property (nonatomic, strong) GNMeActivityListVM *viewModel;

@end

@implementation GNMeActivityVC

+ (UIStoryboard *)storyboard {
    return [UIStoryboard storyboardWithName:@"GNMeUI" bundle:nil];
}

+ (instancetype)loadFromStoryboard {
    return [[self storyboard] instantiateViewControllerWithIdentifier:@"meActivity"];
}

-(void)setupUI{
    [super setupUI];
    
    self.menu = [[GNMenuOptionVC alloc] initWithOptions:@[@"全部", @"待确认",@"即将开始",@"进行中",@"已结束"]];
    [self.view addSubview:self.menu.view];
    [self.menu autoShowOrHide];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:nil action:nil];
    __weakify;
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __strongify;
        [self.menu autoShowOrHide];
        return [RACSignal empty];
    }];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kUIColorWithHexUint(GNUIColorGrayWhite);
    self.tableView.refreshDelegate = self;
    
    [self.tableView addRefreshAndLoadMore];
    [self.tableView registerNib:[GNMeActivityCell nib] forCellReuseIdentifier:kUITableViewCellHeader];
}

-(void)binding{
    self.viewModel = [[GNMeActivityListVM alloc]init];
    self.viewModel.activityListType = GNMeActivityListType_All;
    
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.activityArray.count) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }else {
            [self.tableView showHintViewWithType:XBHintViewTypeLoadError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
        [self.tableView endAllRefresh];
    };
    
    [self.viewModel.getActivityListReponese start:NO success:^(id response, GNActivityListModel *model) {
        __strongify;
        if (!model.activities.count) {
            [self.tableView showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
            
            [self.tableView reloadData];
            [self.tableView setTotalPage:0];
        }else {
            [self.tableView reloadData];
            [self.tableView hideHintView];
            [self.tableView setTotalPage:model.pages];
        }
        [self.tableView endAllRefresh];
    } error:^(id response, NSInteger code) {
        errorHandler();
    } failure:^(id req, NSError *error) {
        errorHandler();
    }];
    
    [self.tableView refresh];
    
    [self.menu didSelectOption:^(NSUInteger index) {
        __strongify;
        [self.viewModel.activityDateArray removeAllObjects];
        [self.viewModel.activityArray removeAllObjects];
        //@"全部", @"待确认",@"即将开始",@"进行中",@"已结束"
        switch (index) {
            case 0:
                self.viewModel.activityListType = GNMeActivityListType_All;
                break;
            case 1:
                self.viewModel.activityListType = GNMeActivityListType_Pending_Confirm;
                break;
            case 2:
                self.viewModel.activityListType = GNMeActivityListType_NotBeginning;
                break;
            case 3:
                self.viewModel.activityListType = GNMeActivityListType_Beginning;
                break;
            case 4:
                self.viewModel.activityListType = GNMeActivityListType_End;
                break;
            default:
                break;
        }
        [self.tableView refresh];
    }];
}

#pragma mark -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.activityDateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.activityArray.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin_time BEGINSWITH %@",self.viewModel.activityDateArray[section]];
        NSArray  *arraySectionData = [self.viewModel.activityArray filteredArrayUsingPredicate:predicate];
        
        return arraySectionData.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNMeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewCellHeader forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin_time BEGINSWITH %@",self.viewModel.activityDateArray[[indexPath section]]];
    NSArray  *arraySectionData = [self.viewModel.activityArray filteredArrayUsingPredicate:predicate];
    GNActivities *activities = arraySectionData[indexPath.row];
    
    cell.activityId = activities.id;
    [cell bindingModel:activities];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDate = [dateformatter stringFromDate:senddate];
    
    NSString *headerStr = @"";
//    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(24 * 60 * 60)];
//    NSString *yesterdayStr = [dateformatter stringFromDate:yesterday];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 200, 30)];
    label.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
    
    if ([currentDate isEqual:[self.viewModel.activityDateArray objectAtIndex:section]]) {
        headerStr = @"  今天";
        label.text = headerStr;
        label.textColor = [UIColor redColor];
    }
    else {
        headerStr = [self.viewModel.activityDateArray objectAtIndex:section];
        
        NSDate *date = [dateformatter dateFromString:headerStr];
        
        NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger weekday = [c components:NSCalendarUnitWeekday fromDate:date].weekday;

        NSString *stringWeekday = @"";
        switch (weekday) {
            case 1:
                stringWeekday = @"星期天";
                break;
            case 2:
                stringWeekday = @"星期一";
                break;
            case 3:
                stringWeekday = @"星期二";
                break;
            case 4:
                stringWeekday = @"星期三";
                break;
            case 5:
                stringWeekday = @"星期四";
                break;
            case 6:
                stringWeekday = @"星期五";
                break;
            case 7:
                stringWeekday = @"星期六";
                break;
            default:
                break;
        }
        
        label.text = [headerStr stringByAppendingFormat:@"   %@",stringWeekday];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    view.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
    
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"begin_time BEGINSWITH %@",self.viewModel.activityDateArray[[indexPath section]]];
    NSArray  *arraySectionData = [self.viewModel.activityArray filteredArrayUsingPredicate:predicate];
    GNActivities *activities = [arraySectionData objectAtIndex:indexPath.row];

    GNActivityDetailsVC *vc = [[GNActivityDetailsVC alloc]initWithId:[NSString stringWithFormat:@"%ld",(long)activities.id]];
    [self.navigationController pushVC:vc animated:YES];
}

@end
