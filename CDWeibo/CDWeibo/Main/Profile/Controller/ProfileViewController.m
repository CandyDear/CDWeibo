//
//  ProfileViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "ProfileViewController.h"
#import "WeiboTableView.h"
#import "AppDelegate.h"
#import "HeadView.h"
#import "WeiboCell.h"
#import "WeiboViewLayoutFrame.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "FollowersViewController.h"
@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate,SinaWeiboRequestDelegate>
{
    WeiboTableView *_tableView;
    HeadView *_headView;
    NSMutableArray *_dataArray;//接收总数据，原来，上拉，下拉
    UIView *_buttonView;
//    WeiboModel *model;
}


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createSubView];
    
    [self _loadData];
    [self _setRefresh];
    
}
#pragma mark - refresh
-(void)_setRefresh
{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
}
-(void)_createSubView
{
    
    
    //设置头视图
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:self options:nil]lastObject];
    _headView.backgroundColor = [UIColor clearColor];
    
    
    //创建buttonView
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 100)];
    //创建按钮
    NSArray *titles = @[@"关注",
                        @"粉丝",
                        @"资料",
                        @"更多"];
    for (int i = 0; i < titles.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + (kScreenWidth / titles.count) * i, 0, 80, 80);
        button.tag = i + 1000;

        
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 3;
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.backgroundColor = [UIColor lightGrayColor];
        [button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
        {
            //分两行显示title
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [button setTitle:[NSString stringWithFormat:@"%@\n%li",titles[i],[_headView.friends_count integerValue]] forState:UIControlStateNormal];
        }
        else if (i == 1)
        {
            //分两行显示title
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [button setTitle:[NSString stringWithFormat:@"%@\n%li",titles[i],[_headView.followers_count integerValue]] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:titles[i] forState:UIControlStateNormal];
        }
        [_buttonView addSubview:button];
    }

    [_headView addSubview:_buttonView];
    _tableView  = [[WeiboTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
  
    _tableView.tableHeaderView = _headView;



}
-(void)_loadData
{
    [self showHudWithTitle:@"正在加载..."];
    //获取微博
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
   SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 100;
}
//上拉加载
-(void)_loadMoreData
{
    //获取微博
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //[params setObject:@"10" forKey:@"count"];
    //设置max_id
    if(_dataArray.count > 0)
    {
        WeiboViewLayoutFrame *layout = [_dataArray lastObject];
        WeiboModel *model = layout.weiboModel;
        [params setObject:model.weiboIdStr forKey:@"max_id"];
    }
        
   SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/user_timeline.json" params:params httpMethod:@"GET" delegate:self];
    request.tag = 101;
}
//下拉刷新
-(void)_loadNewData
{
    //获取微博
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params setObject:@"10" forKey:@"count"];
    //设置since_id
    if(_dataArray > 0)
    {
        WeiboViewLayoutFrame *layout = _dataArray[0];
        WeiboModel *model = layout.weiboModel;
        [params setObject:model.weiboIdStr forKey:@"since_id"];
    }
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses_user/timeline.json" params:params httpMethod:@"GET" delegate:self];
    request.tag = 99;
}
#pragma mark - UITableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableView.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiboCell"];
    }
    WeiboViewLayoutFrame *layout = _tableView.data[indexPath.row];cell.layout = layout;
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeiboRequest Delegate
-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //    NSLog(@"result:%@",result);
    [self completeHudWithTitle:@"加载完成"];
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
    //_tableView.data = layoutFrameArray;
    //刷新 或者加载 更多数据
    if (request.tag == 100)
    {
        _dataArray = layoutFrameArray;
        //提示加载完成
        [self completeHudWithTitle:@"加载完成"];
    }
    else if (request.tag == 99)
    {
        if (_dataArray == nil)
        {
            _dataArray = layoutFrameArray;
        }
        else
        {
            //下拉刷新数据
            NSRange rang = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:rang];
            [_dataArray insertObjects:layoutFrameArray atIndexes:indexSet];
        }
    }
    else if (request.tag == 101)
    {
        if (_dataArray == nil)
        {
            _dataArray = layoutFrameArray;
        }
        else
        {
            [_dataArray removeLastObject];
            [_dataArray addObjectsFromArray:layoutFrameArray];
        }
    }
    if (_dataArray.count != 0)
    {
        _tableView.data = _dataArray;
        [_tableView reloadData];
    }
    for(WeiboViewLayoutFrame *layout in _tableView.data)
    {
        WeiboModel *model = layout.weiboModel;
        //1.头像
        [_headView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.userModel.profile_image_url]];
        //2.昵称
        _headView.nickNameLabel.colorName = @"Mask_Title_color";
        _headView.nickNameLabel.text = model.userModel.screen_name;
        //3.性别 地点
        _headView.location = model.userModel.location;
        _headView.baseLabel.colorName = @"Mask_Title_color";
        if([model.userModel.gender isEqualToString:@"m"])
        {
            
            _headView.baseLabel.text = [NSString stringWithFormat:@"性别:男 %@",_headView.location];
        }
        if([model.userModel.gender isEqualToString:@"f"])
        {
            _headView.baseLabel.text = [NSString stringWithFormat:@"性别:女 %@",_headView.location];
        }
        if([model.userModel.gender isEqualToString:@"n"])
        {
            _headView.baseLabel.text =[NSString stringWithFormat:@"无 %@",_headView.location];
        }
        //4.简介
        _headView.introduceLabel.text = model.userModel.userDescription;
        _headView.introduceLabel.colorName = @"Mask_Title_color";
        //NSLog(@"%@",model.userModel.userDescription);

        //关注数
        _headView.friends_count = model.userModel.friends_count;
        //粉丝数
        _headView.followers_count = model.userModel.followers_count;
        UIButton *friendsBtn = (UIButton *)[_buttonView viewWithTag:1000];
        [friendsBtn setTitle:[NSString stringWithFormat:@"关注\n%li",[_headView.friends_count integerValue]] forState:UIControlStateNormal];
        [_buttonView addSubview:friendsBtn];
        UIButton *fansBtn = (UIButton *)[_buttonView viewWithTag:1001];
        [fansBtn setTitle:[NSString stringWithFormat:@"粉丝\n%li",[_headView.followers_count integerValue]] forState:UIControlStateNormal];
        [_buttonView addSubview:fansBtn];

        }

    //数据加载完成后，refresh完成
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];

}
-(void)selectButtonAction:(UIButton *)button
{
    NSLog(@"%li",button.tag);
    if(button.tag == 1000)
    {
        FollowersViewController *followsVC = [[FollowersViewController alloc] init];
        [self.navigationController pushViewController:followsVC animated:YES];
    }
    
}
@end
