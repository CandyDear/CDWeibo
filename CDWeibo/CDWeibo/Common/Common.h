//
//  Common.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#ifndef CDWeibo_Common_h
#define CDWeibo_Common_h
//新浪微博SDK
#define kAppKey             @"3507872839"
#define kAppSecret          @"f8060d0e87edf7ddece687b2431f1079"
#define kAppRedirectURI     @"http://sina.com"


#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define unread_count @"remind/unread_count.json"  //未读消息
#define comments  @"comments/show.json"   //评论列表
//微博字体
#define FoneSize_Weibo(isDetail) isDetail?16:15
#define FontSize_ReWeibo(isDetail) isDetail?15:14
#endif
