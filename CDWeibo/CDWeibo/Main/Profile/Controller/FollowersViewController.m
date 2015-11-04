//
//  FollowersViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/22.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "FollowersViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "UserCell.h"
#import "UserListModel.h"
#import "UIImageView+WebCache.h"
#import "UserCollectionView.h"
@interface FollowersViewController ()<SinaWeiboRequestDelegate>
{
    UserCollectionView *_userCollectionView;
    NSMutableArray *_usersData;
}

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注列表";
    [self _loadDta];
    

}
-(void)_createCollectionView
{
    //布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat sizeWidth = (kScreenWidth - 10 * 4) / 3;
    flowLayout.itemSize = CGSizeMake(sizeWidth, sizeWidth);
    
    _userCollectionView = [[UserCollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) collectionViewLayout:flowLayout];
    _userCollectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_userCollectionView];
//    UINib *nib = [[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil] lastObject];
//    [_userCollectionView registerNib:nib forCellWithReuseIdentifier:@"UserCell"];
    [_userCollectionView registerClass:[UserCell class] forCellWithReuseIdentifier:@"UserCell"];
    _userCollectionView.data = _usersData;
    
}
-(void)_loadDta
{
    //正在加载时的提示
    [self showHudWithTitle:@"正在加载..."];
    //获取微博
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:@"friendships/friends.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET" delegate:self];
    _usersData = [NSMutableArray array];
}
#pragma mark - SinaWeiboRequestDelegate
-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error : %@",error);
}
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSLog(@"result: %@",result);//字典
    
    //数据解析
    NSArray *users = result[@"users"];
     _usersData = [NSMutableArray array];
    for(NSDictionary *user in users)
    {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:user];
        [_usersData addObject:weiboModel];
    }
    [self _createCollectionView];

    if(_usersData.count != 0 )
    {
        _userCollectionView.data = _usersData;
        [_userCollectionView reloadData];
    }
    [self completeHudWithTitle:@"加载完成"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
