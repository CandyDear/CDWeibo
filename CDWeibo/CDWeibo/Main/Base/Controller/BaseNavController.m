//
//  BaseNavController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseNavController.h"
#import "ThemeManager.h"

@interface BaseNavController ()

@end

@implementation BaseNavController
//写完通知对象后及时加上，移除对象
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//当导航控制器在storyboard中时调用的init方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}
-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}
-(void)_loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:@"mask_titlebar64.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : color
                                               };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //页面开始时就调用
    [self _loadImage];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
