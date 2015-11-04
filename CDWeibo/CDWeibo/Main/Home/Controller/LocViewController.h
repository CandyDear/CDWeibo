//
//  LocViewController.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/20.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface LocViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_manager;
}
//用来存放 返回服务器的地理位置信息
@property (nonatomic, strong) NSArray *dataList;
@end
