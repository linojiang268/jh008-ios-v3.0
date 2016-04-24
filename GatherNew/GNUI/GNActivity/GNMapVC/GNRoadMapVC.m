//
//  GNRoadMapVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/22.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNRoadMapVC.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CustomOverlayView.h"
#import "CustomOverlay.h"
#import "CustomPointAnnotation.h"
#import "GNMapVM.h"
#import "GNMapPersonModel.h"


#define UPDATE_GROUP_MEMBER_TIMER_INTERVAL 30

@interface GNRoadMapVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate> {
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    
    NSUInteger _second;
    BOOL _isFirstAddTeammateAnnotation;
    
    NSArray *_arrayRoadLine;
    CLLocationCoordinate2D _locationCoord;
    BOOL _isFirstGetLocation;
    
    NSMutableArray* members;
}

@property (nonatomic, strong) GNMapVM *viewModelRoad;
@property (nonatomic, strong) NSTimer *updateGroupMemberLocationTimer;
@property (nonatomic, strong) UIImageView *groupLocation;
@property (nonatomic, assign) BOOL isUpdatingMemberLocation;
@end

@implementation GNRoadMapVC

- (instancetype)initRoadArray:(NSArray *)arrayRoadLine
{
    self = [super init];
    if (self) {
        _arrayRoadLine = arrayRoadLine;
    }
    return self;
}

- (GNBackButtonType)backButtonType {
    return GNBackButtonTypePop;
}

-(void)setupUI{
    [super setupUI];
    if (!_mapView) {
        [self initMapView];
    }
    
    _isFirstGetLocation = NO;
    members = [NSMutableArray array];
    self.title =@"现场图示";
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65*2, [UIScreen mainScreen].bounds.size.height-64-65, 50, 50);
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"activity_Map_My_Location"] forState:UIControlStateNormal];
    [btnLocation addTarget:self action:@selector(showUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocation];

    
    self.groupLocation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_Map_disable_group"] highlightedImage:[UIImage imageNamed:@"activity_Map_enable_group"]];
    self.groupLocation.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65, [UIScreen mainScreen].bounds.size.height-64-65, 50, 50);
    self.groupLocation.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGroupLocation:)];
    [self.groupLocation addGestureRecognizer:singleTap];
    [self.view addSubview:self.groupLocation];
}

-(void)binding{
    self.viewModelRoad = [[GNMapVM alloc]init];
    self.viewModelRoad.activityID =[NSString stringWithFormat:@"%ld",(long)self.activityDetails.id];
    __weakify;
    [self.viewModelRoad.getActivityPersonResponse start:NO success:^(id response, GNMapPersonModel *model) {
        __strongify;
        self.isUpdatingMemberLocation = NO;
        [_mapView removeAnnotations:members];
        [members removeAllObjects];
        if(self.groupLocation.highlighted){
            for (GNMembers *member in self.viewModelRoad.arrayMembers) {
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = member.lat;
                coordinate.longitude = member.lng;
                [self addPointAnnotation:coordinate title:member.name imageUrl:member.avatar_url uid:member.user_id];
            }
        }
    } error:^(id response, NSInteger code) {
        __strongify;
        self.isUpdatingMemberLocation = NO;
        if (code != 10301) {
            [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        }
        [self stopUpdateGroupMemberLocationTimer];
    } failure:^(id req, NSError *error) {
        self.isUpdatingMemberLocation = NO;
        //[SVProgressHUD showErrorWithStatus:@"获取成员信息失败!"];
    }];
}

- (void)startUpdateGroupMemberLocationTimer {
    if (!self.updateGroupMemberLocationTimer) {
        self.updateGroupMemberLocationTimer = [NSTimer timerWithTimeInterval:UPDATE_GROUP_MEMBER_TIMER_INTERVAL target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.updateGroupMemberLocationTimer forMode:NSRunLoopCommonModes];
    }
    
    if(!self.isUpdatingMemberLocation){
        [self.updateGroupMemberLocationTimer fire];
    }
}

- (void)stopUpdateGroupMemberLocationTimer {
    if (self.updateGroupMemberLocationTimer) {
        [self.updateGroupMemberLocationTimer invalidate];
        self.updateGroupMemberLocationTimer = nil;
    }
}

- (void)timerEvent:(NSTimer *)timer {
    self.isUpdatingMemberLocation = YES;
    [self.viewModelRoad.getActivityPersonResponse start];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    [self drawRoarmap];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopUpdateGroupMemberLocationTimer];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    
    [_locService stopUserLocationService];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)initMapView {
    _locService = [[BMKLocationService alloc]init];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeight-64)];
    _mapView.zoomLevel = 15;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view addSubview:_mapView];
}

-(void)showUserLocation{
    [_mapView setCenterCoordinate:_locationCoord animated:YES];
}


-(void)showGroupLocation:(UITapGestureRecognizer*) sender{
    self.groupLocation.highlighted = !self.groupLocation.highlighted;
    if(self.groupLocation.highlighted){
        [self startUpdateGroupMemberLocationTimer];
    }else{
        [self stopUpdateGroupMemberLocationTimer];
        //TODO:清理队友位置
        [_mapView removeAnnotations:members];
    }
}

- (void)addPointAnnotation:(CLLocationCoordinate2D) coordinate title:(NSString *)title imageUrl:(NSString *)url uid:(NSInteger)uid
{
    
    CustomPointAnnotation* pointAnnotation;
    if (pointAnnotation == nil) {
        pointAnnotation = [[CustomPointAnnotation alloc]init];
        pointAnnotation.coordinate = coordinate;
        pointAnnotation.title = title;
        pointAnnotation.image_Url = url;
        pointAnnotation.tag = uid;
    }
    [_mapView addAnnotation:pointAnnotation];
    [members  addObject:pointAnnotation];
}

- (void)drawRoarmap {
    CustomPointAnnotation* startPointAnnotation = [[CustomPointAnnotation alloc]init];
    startPointAnnotation.tag = -1;
    startPointAnnotation.coordinate = CLLocationCoordinate2DMake([_arrayRoadLine[0][0] floatValue], [_arrayRoadLine[0][1] floatValue]);
    [_mapView addAnnotation:startPointAnnotation];
    
    CustomPointAnnotation* endPointAnnotation = [[CustomPointAnnotation alloc]init];
    endPointAnnotation.tag = -2;
    endPointAnnotation.coordinate = CLLocationCoordinate2DMake([_arrayRoadLine[_arrayRoadLine.count-1][0] floatValue], [_arrayRoadLine[_arrayRoadLine.count-1][1] floatValue]);
    [_mapView addAnnotation:endPointAnnotation];
    
    BMKMapPoint points[_arrayRoadLine.count];
    for (int i=0;i<_arrayRoadLine.count;i++) {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([_arrayRoadLine[i][0] floatValue],[_arrayRoadLine[i][1] floatValue]);
        BMKMapPoint point = BMKMapPointForCoordinate(coor);
        points[i] = point;
    }
    
    CustomOverlay *custom = [[CustomOverlay alloc] initWithPoints:points count:_arrayRoadLine.count];
    [_mapView addOverlay:custom];
    [_mapView setVisibleMapRect:custom.boundingMapRect edgePadding:UIEdgeInsetsMake(0, 0, 0, 0) animated:YES];
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:@"xidanMark"];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"xidanMark"];
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    CustomPointAnnotation *customAnnotation = (CustomPointAnnotation *)annotation;
    if (customAnnotation.tag >= 0) {
        ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"activity_mapnearby"];
        NSString *strTitle =((BMKPointAnnotation *)annotation).title;
        CGSize sizeContent = CGSizeMake(300, 20000.0f);//注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
        UIFont *font = [UIFont systemFontOfSize:14];
        
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        sizeContent =[strTitle boundingRectWithSize:sizeContent options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60+sizeContent.width, 70)];
        [imageView setImage:[UIImage imageNamed:@"map_paopao"]];
        
        
        UIImageView *imageJT = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 30, 30)];
        imageJT.layer.masksToBounds = YES;
        imageJT.layer.cornerRadius = 15;
        [imageJT setUserAvatarImageWithURLString:customAnnotation.image_Url];
        [imageView addSubview:imageJT];
        
        UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, sizeContent.width, 50)];
        lbTitle.text = strTitle;
        lbTitle.font = [UIFont systemFontOfSize:14];
        [lbTitle setTextColor:kUIColorWithHexUint(GNUIColorWhite)];
        
        [imageView addSubview:lbTitle];
        annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:imageView];
    }else {
        if (customAnnotation.tag == -1) {
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"activity_MapRoadStart"];
        }
        if (customAnnotation.tag == -2) {
            ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"activity_MapRoadEnd"];
        }
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    
    //CustomPointAnnotation* annotation = (CustomPointAnnotation *)view.annotation;
    
    
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [UIColor colorWithHex:0x03A9F4];
        cutomView.fillColor = [UIColor blackColor];
        cutomView.lineWidth = 4;
        return cutomView;
    }
    return nil;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    [SVProgressHUD showWithStatus:@"正在获取当前位置"];
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [SVProgressHUD dismiss];
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.viewModelRoad.lat = userLocation.location.coordinate.latitude;
    self.viewModelRoad.lng = userLocation.location.coordinate.longitude;
    
    [_mapView updateLocationData:userLocation];
    _locationCoord = userLocation.location.coordinate;
    
    if (!_isFirstGetLocation) {
        _isFirstGetLocation = YES;
        
        if (self.activityDetails.sub_status == GNApplyStatusSuccess) {
            //TODO:
        }
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    [SVProgressHUD showSuccessWithStatus:@"停止定位"];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"位置获取失败，请重试"];
}


@end
