//
//  NearByViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/20.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "DataService.h"
#import "WeiboDetailViewController.h"
/**
 *  1.定义（遵循 MKAnnotation协议）annotation类－－>Model
    2.创建annotation对象 并且把对象加到mapView上
    3.实现mapView的协议方法，创建标注视图
  */
@interface NearByViewController ()
{
    MKMapView *_mapView;
}

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createViews];
//    CLLocationCoordinate2D coordinate = {30.326943,120.368069};
//    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
//    annotation.title = @"下沙";
//    annotation.subTitle = @"中国计量学院";
//    annotation.coordinate = coordinate;
//    [_mapView addAnnotation:annotation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_createViews
{
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图类型 混合，卫星，标准
    _mapView.mapType = MKMapTypeStandard;
    //设置代理
    _mapView.delegate = self;
    //用户跟踪
    //_mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:_mapView];
                
}
#pragma mark - mapView代理
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //选中
    if(![view.annotation isKindOfClass:[WeiboAnnotation class]])
    {
        return;
    }
    WeiboAnnotation *weiboAnnotation = view.annotation;
    WeiboModel *model = weiboAnnotation.model;
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}
/**
 *  mapView位置更新后被调用
 //http://open.weibo.com/wiki/2/place/nearby_timeline  附近动态（微博）
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{


    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;

    NSLog(@"纬度  %lf,经度 %lf",coordinate.latitude,coordinate.longitude);
    //设置地图的显示区域
    CLLocationCoordinate2D center = coordinate;
    //数值越小越精确
    MKCoordinateSpan span = {0.5,0.5};
    MKCoordinateRegion region = {center,span};
    mapView.region = region;

    //网络获取附近微博
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat: @"%f",coordinate.latitude];
    
    [self _loadNearbyData:lon lat:lat];


}
//用大头针显示
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    //如果是用户定位则用默认的标注图标
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//    {
//        return nil;
//    }
//    //复用池 获取标注图标
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
//    if (pinView == nil)
//    {
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
//    }
//    //设置大头针颜色
//    pinView.pinColor = MKPinAnnotationColorPurple;
//    //设置从天而降效果
//    pinView.animatesDrop = YES;
//    //设置标题显示
//    pinView.canShowCallout = YES;
//    //设置辅助视图
//    pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    return pinView;
//}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    if([annotation isKindOfClass:[WeiboAnnotation class]])
    {
        WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if(view == nil)
        {
            view = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        }
        view.annotation = annotation;
        [view setNeedsLayout];
        
        return view;
    }
    return nil;
}
#pragma mark - 网络获取微博
-(void)_loadNearbyData:(NSString *)lon lat:(NSString *)lat
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
        for(NSDictionary *dic in statuses)
        {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            //[_mapView addAnnotation:annotation];//或者
            [annotationArray addObject:annotation];
        }
        [_mapView addAnnotations:annotationArray];
    }];
}
@end
