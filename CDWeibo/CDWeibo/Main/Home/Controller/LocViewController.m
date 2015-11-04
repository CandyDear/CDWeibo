//
//  LocViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/20.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "LocViewController.h"
#import "DataService.h"
#import "PositionModel.h"
#import "UIImageView+WebCache.h"
@interface LocViewController ()

@end

@implementation LocViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createTableView];
    [self _location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)_location
{
    //定位
    _manager = [[CLLocationManager alloc] init];
    if(kVersion >= 8.0)
    {
        //请求允许定位
        [_manager requestWhenInUseAuthorization];
    }
    //设置请求精度
    [_manager setDesiredAccuracy:kCLLocationAccuracyBest];
    _manager.delegate = self;
    //开始定位
    [_manager startUpdatingLocation];
}
-(void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UITableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *locCellID = @"locCell";
    UITableViewCell *locCell = [tableView dequeueReusableCellWithIdentifier:locCellID];
    if(locCell == nil)
    {
        locCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locCellID];
    }
    //获取当前单元格对应的商圈对象
    PositionModel *poi = _dataList[indexPath.row];
    [locCell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    locCell.textLabel.text = poi.title;
    locCell.backgroundColor = [UIColor clearColor];
    return locCell;
}
#pragma mark - CLLocationManager 代理
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [_manager stopUpdatingLocation];
    //获取当前请求位置
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D cootdinate = location.coordinate;
    NSString *longitude = [NSString stringWithFormat:@"%f",cootdinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",cootdinate.latitude];
    [self loadNearByPositionWithLongitude:longitude latitude:latitude];
    
}
//开始加载网络
-(void)loadNearByPositionWithLongitude:(NSString *)lon latitude:(NSString *)lat
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    [params setObject:@50 forKey:@"count"];
    //请求数据 获取附近商家
    [DataService requestUrl:nearby_pois httpMethod:@"GET" params:params block:^(id result) {
        NSArray *pois = result[@"pois"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            // 创建商圈模型对象
            PositionModel *poi = [[PositionModel alloc]initWithDataDic:dic];
            [dataList addObject:poi];
            
        }
        _dataList = dataList;
        [_tableView reloadData];
        
    }];
    
    
}
@end
