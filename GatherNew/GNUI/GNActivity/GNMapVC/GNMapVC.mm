//
//  GNMapVC.m
//  GatherNew
//
//  Created by wudanfeng on 15/7/15.
//  Copyright (c) 2015年 ZERO TO ALL. All rights reserved.
//

#import "GNMapVC.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "GNMapVM.h"
#import "GNActivityListModel.h"
#import "CustomPointAnnotation.h"
#import "GNActivityDetailsVC.h"

@interface GNMapVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService *_locationService;
    
    BOOL _isSetlocation;
    
    GNMapType _mapType;
}

@property (nonatomic, strong) GNMapVM *mapViewModel;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end


@implementation GNMapVC

+ (NSString *)sbIdentifier {
    return @"baiduMap";
}

- (void)setupUI {
    [super setupUI];
    
    _isSetlocation = NO;
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
     _locationService = [[BMKLocationService alloc]init];
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.zoomLevel=16;

    [self.view addSubview:_mapView];
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65, [UIScreen mainScreen].bounds.size.height-64-65, 50, 50);
    [btnLocation setImage:[UIImage imageNamed:@"activity_Map_My_Location"] forState:UIControlStateNormal];
    [btnLocation addTarget:self action:@selector(showUserLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocation];
    
    
    UIButton *btnNavigation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNavigation.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65-60, [UIScreen mainScreen].bounds.size.height-64-65, 50, 50);
    [btnNavigation setImage:[UIImage imageNamed:@"activity_Map_Nav"] forState:UIControlStateNormal];
    [btnNavigation addTarget:self action:@selector(showNavigation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNavigation];
    
    [self doStart:nil];
    
    if (self.mapType == GNMapType_AllActivity) {
        self.title = @"附近活动";
        btnNavigation.hidden = YES;
    }else if (self.mapType == GNMapType_CurrentActivity){
        self.title = @"路线导航";
    }
}

-(void)binding{
    
    self.mapViewModel = [[GNMapVM alloc]init];

    __weakify;
    [self.mapViewModel.getLocationActivityResponse start:NO success:^(id response, GNActivityListModel *model) {
        __strongify;
        
        for (GNActivities *activity in model.activities) {
            CLLocationCoordinate2D coordicate;
            coordicate.latitude = [activity.location[0] floatValue];
            coordicate.longitude = [activity.location[1] floatValue];
            
            [self addPointAnnotation:coordicate title:activity.title tag:activity.id];
        }
        
    } error:^(id response, NSInteger code) {
        [SVProgressHUD showErrorWithStatus:[response objectForKey:@"message"]];
        
    } failure:^(id req, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取活动数据失败"];
    }];
    
}

#pragma mark 地图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil;
    _locationService.delegate = nil;
    
    [_locationService stopUserLocationService];
}

-(void)showUserLocation{

    [_mapView setCenterCoordinate:self.coordinate animated:YES];
}

#pragma 地图导航

- (void)showNavigation {
    UIActionSheet *action;
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用系统自带地图导航", nil];
    }else {
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用系统自带地图导航",@"使用百度地图导航", nil];
    }
    
    [action showInView:self.view];
    __weakify;
    [[action rac_buttonClickedSignal] subscribeNext:^(id x) {
        __strongify;
        NSUInteger index = [x unsignedIntegerValue];
        if (index == 0) {
            [self appleNav];
        }
        if (index == 1) {
            [self baiduNav];
        }
    }];
}

- (void)appleNav {
    if(self.coordinate.latitude == 0 || self.coordinate.longitude == 0 ){
        [SVProgressHUD showErrorWithStatus:@"未定位到您的位置"];
        return;
    }
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D coord;
    coord.latitude = [self.activityDetails.location[0] floatValue];
    coord.longitude = [self.activityDetails.location[1] floatValue];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil]];
    toLocation.name = self.activityDetails.address;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (void)baiduNav {
    if(self.coordinate.latitude == 0 || self.coordinate.longitude == 0 ){
        [SVProgressHUD showErrorWithStatus:@"未定位到您的位置"];
        return;
    }
    
    BMKNaviPara *para = [[BMKNaviPara alloc] init];
    para.naviType = BMK_NAVI_TYPE_NATIVE;
    para.appScheme = @"gather://gather.zero2all.com";
    
    BMKPlanNode *startNode = [[BMKPlanNode alloc] init];
    startNode.pt = self.coordinate;
    para.startPoint = startNode;
    
    BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
    CLLocationCoordinate2D coord;
    coord.latitude = [self.activityDetails.location[0] floatValue];
    coord.longitude = [self.activityDetails.location[1] floatValue];
    
    endNode.pt = coord;
    endNode.name = self.activityDetails.address;
    para.endPoint = endNode;
    
    [BMKNavigation openBaiduMapNavigation:para];
}

#pragma mark 开始定位
-(void)doStart:(id)sender
{
    [_locationService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
  
}

//添加标注
- (void)addPointAnnotation:(CLLocationCoordinate2D) coordinate title:(NSString *)title tag:(NSUInteger)tag
{
    
    CustomPointAnnotation * pointAnnotation = [[CustomPointAnnotation alloc]init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = title;
    pointAnnotation.tag = tag;
    [_mapView addAnnotation:pointAnnotation];
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        newAnnotationView.annotation = annotation;
        // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.image = [UIImage imageNamed:@"activity_mapnearby"];
        [newAnnotationView setDraggable:NO];
        
        NSString *strTitle =((BMKPointAnnotation *)annotation).title;
        
        
         CGSize sizeContent = CGSizeMake(300, 20000.0f);//注：这个宽：300 是你要显示的宽度既固定的宽度，高度可以依照自己的需求而定
        UIFont *font = [UIFont systemFontOfSize:14];

        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        sizeContent =[strTitle boundingRectWithSize:sizeContent options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
        UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, sizeContent.width, 42)];
        lbTitle.text = strTitle;
        lbTitle.font = [UIFont systemFontOfSize:14];
        [lbTitle setTextColor:kUIColorWithHexUint(GNUIColorWhite)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sizeContent.width+50, 58)];
        [imageView setImage:[UIImage imageNamed:@"map_paopao"]];
        
        [imageView addSubview:lbTitle];
        
        UIImageView *imageJT = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.bounds.size.width-20, 17, 6, 11)];
        [imageJT setImage:[UIImage imageNamed:@"into_Details"]];
        [imageView addSubview:imageJT];
        
        newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:imageView];
        newAnnotationView.paopaoView.tag = ((CustomPointAnnotation *)annotation).tag;
        [newAnnotationView.paopaoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActivity:)]];
        
        return newAnnotationView;
    }
    return nil;
}

- (void)clickActivity:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.view.tag > 0) {
        GNActivityDetailsVC *controller = [[GNActivityDetailsVC alloc] initWithId:[NSString stringWithFormat:@"%d",tapGesture.view.tag]];
        [self.navigationController pushVC:controller animated:YES];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    self.coordinate = userLocation.location.coordinate;
    
    self.mapViewModel.lat = userLocation.location.coordinate.latitude;
    self.mapViewModel.lng = userLocation.location.coordinate.longitude;
    [_mapView updateLocationData:userLocation];
    
    if (!_isSetlocation) {
        _isSetlocation = YES;
        
        [self showUserLocation];

        if (self.mapType == GNMapType_AllActivity) {
            [self.mapViewModel.getLocationActivityResponse start];
        }else if(self.mapType == GNMapType_CurrentActivity){
            CLLocationCoordinate2D coord;
            coord.latitude = [self.activityDetails.location[0] floatValue];
            coord.longitude = [self.activityDetails.location[1] floatValue];
            [self addPointAnnotation:coord title:self.activityDetails.title tag:0];
            [_mapView setCenterCoordinate:coord animated:YES];
        }
    }

    if ([self distanceInMap:self.coordinate b:userLocation.location.coordinate]>20000&&self.mapType == GNMapType_AllActivity) {

        NSString *stringLocation =[NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
        [SVProgressHUD showInfoWithStatus:stringLocation];
        
        [self.mapViewModel.getLocationActivityResponse start];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


-(double)distanceInMap:(CLLocationCoordinate2D)a b:(CLLocationCoordinate2D) b{
    double lat1 = a.latitude;
    double lon1 = a.longitude;
    double lat2 = b.latitude ;
    double lon2 = b.longitude;
    double radLat1 = lat1 * M_PI / 180;
    double radLat2 = lat2 * M_PI / 180;
    double u = radLat1 - radLat2;
    double v = lon1 * M_PI / 180 - lon2 * M_PI / 180;
    
    double s = 2 * asin(sqrt( pow(sin(u/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(v/2), 2) ));
    
    s = s * 6378137.0; // 取WGS84标准参考椭球中的地球长半径(单位:m)
    s = round(s * 10000) / 10000;
    return s;
}


@end
