//
//  UserListModel.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/22.
//  Copyright (c) 2015年 mac04. All rights reserved.
//
/**
 *  {
 "users": [
 {
 "id": 1404376560,
 "screen_name": "zaku",
 "name": "zaku",
 "province": "11",
 "city": "5",
 "location": "北京 朝阳区",
 "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
 "url": "http://blog.sina.com.cn/zaku",
 "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
 "domain": "zaku",
 "gender": "m",
 "followers_count": 1204,
 "friends_count": 447,
 ...
 },
 ..
 ]
 */
#import <Foundation/Foundation.h>
#import "WeiboModel.h"

@interface UserListModel : NSObject
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, retain) NSNumber *followers_count;//粉丝数
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, retain) NSNumber *friends_count;
//@property (nonatomic,strong) WeiboModel *weiboModel;

@end
