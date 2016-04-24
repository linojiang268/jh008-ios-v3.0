//
//  GNActivityManualFileVC.m
//  GatherNew
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNActivityManualFileVC.h"
#import "GNActivityManualFileCell.h"
#import "GNActivityManualFileVM.h"
#import "GNFileDownloaderVC.h"

@interface GNActivityManualFileVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GNActivityManualFileVM *viewModel;

@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, strong) NSMutableDictionary *group;

@end

@implementation GNActivityManualFileVC

- (instancetype)initWithActivityId:(NSUInteger)activityId {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"文件";
        self.viewModel = [[GNActivityManualFileVM alloc] initWithActivityId:activityId];
    }
    return self;
}

- (void)binding {
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[GNActivityManualFileCell nib] forCellReuseIdentifier:kUICellIdentifier];
    [self.tableView addRefreshAndLoadMore];
    
    self.group = [[NSMutableDictionary alloc] init];
    
    RAC(self.viewModel,page) = RACObserve(self.tableView, page);
    
    __weakify;
    
    void(^errorHandler)(void) = ^{
        __strongify;
        if (self.viewModel.fileArray.count) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }else {
            [self.tableView showHintViewWithType:XBHintViewTypeLoadError tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
        }
    };
    [self.viewModel.refreshResponse start:NO success:^(id response, GNActivityManualFileModel *model) {
        __strongify;
        
        if (!model.files.count) {
            [self.tableView showHintViewWithType:XBHintViewTypeNoData tapHandler:^(UIView *tapView) {
                __strongify;
                [self.tableView hideHintView];
                [self.tableView refresh];
            }];
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
}

#pragma mark -

- (void)req:(XBRefreshType)refreshType page:(NSUInteger)page tableView:(UIScrollView *)tableView {
    self.viewModel.page = page;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.dateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"created_at BEGINSWITH %@",[self.viewModel.dateArray objectAtIndex:section]];
    NSArray *files = [self.viewModel.fileArray filteredArrayUsingPredicate:predicate];
    if (files) {
        [self.group setObject:files forKey:[kNumber(section) stringValue]];
    }
    return files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNActivityManualFileCell *cell = [tableView dequeueReusableCellWithIdentifier:kUICellIdentifier forIndexPath:indexPath];
    
    NSArray *files = [self.group objectForKey:[kNumber(indexPath.section) stringValue]];
    if (files && files.count > indexPath.row) {
        [cell bindingModel:[files objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, kUIScreenWidth-10, 30)];
    label.textColor = kUIColorWithHexUint(GNUIColorDarkgray);
    
    NSString *dateString = [self.viewModel.dateArray objectAtIndex:section];
    
    NSDate *date = [dateformatter dateFromString:dateString];
    
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
        
    label.text = [[dateString substringWithRange:NSMakeRange(5, 5)] stringByAppendingFormat:@" %@",stringWeekday];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
    view.backgroundColor = kUIColorWithHexUint(GNUIColorWhite);
    
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kUICellIdentifier configuration:^(id cell) {
        NSArray *files = [self.group objectForKey:[kNumber(indexPath.section) stringValue]];
        if (files && files.count > indexPath.row) {
            [cell bindingModel:[files objectAtIndex:indexPath.row]];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *files = [self.group objectForKey:[kNumber(indexPath.section) stringValue]];
    GNActivityManualFileItemModel *file = [files objectAtIndex:indexPath.row];
 
    GNFileDownloaderVC *controller = [[GNFileDownloaderVC alloc] initWithFileModel:file];
    
    [self.navigationController pushVC:controller animated:YES];
}


@end
