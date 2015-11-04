//
//  WeiboDetailViewController.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/16.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "CommentTableView.h"
#import "SinaWeibo.h"
@interface WeiboDetailViewController : BaseViewController<SinaWeiboRequestDelegate>
{
    CommentTableView *_tableView;
}
//评论的微博model
@property(nonatomic,strong) WeiboModel *model;
//评论列表数据
@property(nonatomic,strong) NSMutableArray *data;
@end
