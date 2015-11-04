//
//  BaseTabBarController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavController.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"
@interface BaseTabBarController ()
{
    ThemeImageView *_selectImageView;
    
    ThemeImageView *_badgeImageView;
    ThemeLabel *_badgeLabel;
}


@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //不能改变调用顺序
    [self _createSubControllers];
    
    [self _createTabBar];
    //设置定时器，加载未读信息
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载子控制器
-(void)_createSubControllers
{

    NSArray *names = @[@"Home",@"Discover",@"Profile",@"More"];
    NSMutableArray *navis = [[NSMutableArray alloc] initWithCapacity:names.count];
    for(int i = 0;i < names.count;i++)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        BaseNavController *navi = [storyboard instantiateInitialViewController];
        [navis addObject:navi];
    }
    self.viewControllers = navis;
}
//定制tabBar
-(void)_createTabBar
{
    //1.移除tabBarButton（ 内部的,不可以获取但是可以使用tabBarButton）
    for(UIView *view in self.tabBar.subviews)
    {
        //通过字符串创建类对象
        Class class = NSClassFromString(@"UITabBarButton");
        if([view isKindOfClass:class])
        {
            [view removeFromSuperview];
        }
    }
    //2.设置背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 49)];
    bgImageView.imageName = @"mask_navbar.png";
//    bgImageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    [self.tabBar addSubview:bgImageView];
    //3.设置选中图片
    CGFloat width = kScreenWidth/4;
    _selectImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, width, 49)];
//    _selectImageView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    _selectImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectImageView];
    //4.创建按钮
//    NSArray *imageNames = @[@"Skins/cat/home_tab_icon_1.png",
//                            @"Skins/cat/home_tab_icon_2.png",
//                            @"Skins/cat/home_tab_icon_3.png",
//                            @"Skins/cat/home_tab_icon_4.png",
//                            @"Skins/cat/home_tab_icon_5.png"];
    NSArray *imageNames = @[@"home_tab_icon_1.png",
                            //@"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png"];

    for(int i = 0;i < imageNames.count;i++)
    {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 49)];
//        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        button.normalImageName = imageNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
    
}
-(void)selectAction:(UIButton *)button
{
    //控制器的改变
    self.selectedIndex = button.tag;
    //选中图片跟着按钮改变
    [UIView animateWithDuration:0.35 animations:^{
        _selectImageView.center = button.center;
    }];
}
#pragma mark - 定时器方法 未读消息个数获取
-(void)timerAction
{
    //请求数据
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
}
-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    if(_badgeImageView == nil)
    {
        CGFloat buttonWidth = kScreenWidth / 4;
        _badgeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth - 32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeImageView];
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.colorName = @"Timeline_Notice_color";
        [_badgeImageView addSubview:_badgeLabel];
    }
    if(count > 0)
    {
        _badgeImageView.hidden = NO;
        if(count > 99)
        {
            count = 99;
        }
        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
    }
    else
    {
        _badgeImageView.hidden = YES;
    }
    
}
@end
