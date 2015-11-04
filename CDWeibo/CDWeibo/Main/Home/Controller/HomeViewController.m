//
//  HomeViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeViewController ()
{
    WeiboTableView *_tableView;
    NSMutableArray *_data;//接收总的数据，下拉，上拉，原来
    ThemeImageView *_notiImageView;
    ThemeLabel *_notiLabel;
}

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    [self _createTableView];
    [self _loadData];
    [self _setRefresh];
}
//加载设置Refresh
-(void)_setRefresh
{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
}
#pragma mark - 加载数据
//下拉刷新
-(void)_loadNewData
{
    //NSLog(@"下拉刷新");
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //[params setObject:@"10" forKey:@"count"];
    //设置since_id
    if(_data.count > 0)
    {
        WeiboViewLayoutFrame *layout = _data[0];
        WeiboModel *model = layout.weiboModel;
        [params setObject:model.weiboIdStr forKey:@"since_id"];
        
    }
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 99;
    
}
//上拉加载
-(void)_loadMoreData
{
    //NSLog(@"上拉加载");
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //[params setObject:@"10" forKey:@"count"];
    //设置maxId
    if(_data.count > 0)
    {
        WeiboViewLayoutFrame *layout = [_data lastObject];
        WeiboModel *model = layout.weiboModel;
        [params setObject:model.weiboIdStr forKey:@"max_id"];
    }
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 101;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_createTableView
{
    _tableView  = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(void)_loadData
{
    //获取微博
    //开始加载数据时的提示
    //[self showLoading:YES];
    [self showHudWithTitle:@"正在加载..."];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = delegate.sinaWeibo;
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 100;

}
#pragma mark - SinaWeiboRequest Delegate
-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
//    NSLog(@"result:%@",result);
    //数据解析
    
    NSArray *statuses = result[@"statuses"];

    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in statuses)
    {
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        layout.weiboModel = model;
        [layoutFrameArray addObject:layout];
    }
    //_data 数据顺序 99-》100-》101
    if(request.tag == 100)
    {
        //初始化的数据
        _data = layoutFrameArray;
        //提示加载完成
        [self completeHudWithTitle:@"加载完成"];
        //[self showLoading:NO];
        
    }
    else if (request.tag == 99)
    {
        if(_data == nil)
        {
            _data = layoutFrameArray;
        }
        else
        {
        //[layoutFrameArray addObjectsFromArray:_data];
        //_data = layoutFrameArray;

        //下拉刷新的数据
        NSRange range = NSMakeRange(0, layoutFrameArray.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [_data insertObjects:layoutFrameArray atIndexes:indexSet];
        //弹出提示
        [self showWeiboCount:layoutFrameArray.count];
        }
        
    }
    else if (request.tag == 101)
    {
        if(_data == nil)
        {
            _data = layoutFrameArray;
        }
        //上拉加载的数据
        else
        {
        [_data removeLastObject];
        [_data addObjectsFromArray:layoutFrameArray];
        //弹出提示
        //[self showWeiboCount:layoutFrameArray.count];
        }
    }
    if(_data.count != 0)
    {
        
        _tableView.data = _data;
        [_tableView reloadData];
    }
    //数据加载完成后，refresh完成
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}
#pragma mark - 提示刷新
-(void)showWeiboCount:(NSInteger)count
{
    if(_notiImageView == nil)
    {
        _notiImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth - 10, 40)];
        _notiImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_notiImageView];
        _notiLabel = [[ThemeLabel alloc] initWithFrame:_notiImageView.bounds];
        _notiLabel.colorName = @"Timeline_Notice_color";
        _notiLabel.backgroundColor = [UIColor clearColor];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        [_notiImageView addSubview:_notiLabel];
    }
    if(count > 0)
    {
        _notiLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];

        [self notifyInfo:count];
    }
    else
    {
        _notiLabel.text = [NSString stringWithFormat:@"已经到头了"];
        [self notifyInfo:count];
    }
    //播放声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //注册系统声音
    SystemSoundID soundId;// 0
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlaySystemSound(soundId);
    
}
-(void)notifyInfo:(NSInteger)count
{
        [UIView animateWithDuration:0.6 animations:^{
        _notiImageView.transform = CGAffineTransformMakeTranslation(0, 40 + 64 + 5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            
            [UIView setAnimationDelay:1];
            _notiImageView.transform = CGAffineTransformIdentity;
        }];
    }];

}
@end
