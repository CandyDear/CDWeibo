//
//  MoreViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ThemeTableViewController.h"
#import "AppDelegate.h"
#import "SinaWeiboRequest.h"
#import "ThemeImageView.h"
static NSString *moreCellID = @"moreCellID";
@interface MoreViewController ()
{
    UITableView *_tableView;
    MoreTableViewCell *_cell;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createTableView];
    
    
}
//每次出现的时候重新刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}
-(void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:moreCellID];
    
}
#pragma mark - UITableViewDataSource delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:moreCellID forIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            _cell.themeImageView.imageName = @"more_icon_theme.png";
            _cell.themeTextLabel.text = @"主题选择";
            _cell.themeTextLabel.colorName = @"";
            _cell.themeDetailLabel.text = [ThemeManager shareInstance].themeName;
        }
        else if(indexPath.row == 1)
        {
            _cell.themeImageView.imageName = @"more_icon_account.png";
            _cell.themeTextLabel.text = @"账户管理";
        }
    }
    else if (indexPath.section == 1)
    {
        _cell.themeTextLabel.text = @"意见反馈";
        _cell.themeImageView.imageName = @"more_icon_feedback.png";
    }
    else if (indexPath.section == 2)
    {
        _cell.themeTextLabel.textAlignment = NSTextAlignmentCenter;
        _cell.themeTextLabel.center = _cell.contentView.center;
        //设置默认为登出状态  需要登陆
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
        
        if([sinaWeibo isLoggedIn])
        {
            _cell.themeTextLabel.text = @"登出当前账号";
            
        }
        else
        {
            _cell.themeTextLabel.text = @"账号登陆";
            
        }
    }
    //设置箭头
    if(indexPath.section != 2)
    {
        _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        _cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return _cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 2;
    }
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //进入主题选择页面
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        ThemeTableViewController *themeVC = [[ThemeTableViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    //登出或者登陆
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication  sharedApplication].delegate;
        SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
        if([sinaWeibo isLoggedIn])
        {
        //如果登陆状态
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认登出" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alertView show];
            
        }
        else
        {
            //如果登出状态
            [sinaWeibo logIn];
            if ([sinaWeibo isLoggedIn])
            {
                
                _cell.themeTextLabel.text = @"登出当前账号";
            }
            
        }
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.sinaWeibo logOut];
        _cell.themeTextLabel.text = @"账号登陆";
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
