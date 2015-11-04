//
//  BaseViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "LeftDrawerViewController.h"
#import "RightDrawerViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeButton.h"
#import "MBProgressHUD.h"
#import "UIProgressView+AFNetworking.h"
@interface BaseViewController ()
{
    MBProgressHUD *_hud;
    UIView *_tipView;
    UIWindow *_tipWindow;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _loadImage];


}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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
    UIImage *bgIamge = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgIamge];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏左右按钮
-(void)setNavItem
{
    //左边按钮
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
    leftButton.bgNormalImageName = @"button_m.png";
    leftButton.normalImageName = @"group_btn_all_on_title.png";
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];


    //右边按钮
    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightButton.bgNormalImageName = @"button_m.png";
    rightButton.normalImageName = @"button_icon_plus.png";
    [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
-(void)setAction
{
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)editAction
{
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer  openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
#pragma mark - 数据加载完成前后的提示 第三方
-(void)showHudWithTitle:(NSString *)title
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;//阴影
}
-(void)completeHudWithTitle:(NSString *)title
{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    [_hud hide:YES afterDelay:1.5];
}
#pragma mark - 加载提示，自己实现
- (void)showLoading:(BOOL)show{
    
    
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-30, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];
        
        //01 activity
        UIActivityIndicatorView *activiyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activiyView.tag = 100;
        [_tipView addSubview:activiyView];
        
        
        //02 label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"正在加载...";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_tipView addSubview:label];
        
        label.left = (kScreenWidth-label.width)/2;
        activiyView.right = label.left-5;
        
    }
    
    
    if (show) {
        
        UIActivityIndicatorView *activiyView =(UIActivityIndicatorView*) [_tipView viewWithTag:100];
        [activiyView startAnimating];
        [self.view addSubview:_tipView];
    }else{
        if (_tipView.superview) {
            UIActivityIndicatorView *activiyView = (UIActivityIndicatorView*)[_tipView viewWithTag:100];
            [activiyView stopAnimating];
            [_tipView removeFromSuperview];
        }
    }
    
}
#pragma mark - 发送提示
-(void)showTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation
{
    if(_tipWindow == nil)
    {
        _tipWindow  = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        //显示文字
        UILabel *label = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        label.tag = 100;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_tipWindow addSubview:label];
        //实现进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 0)];
        progressView.progress = 0.0;
        progressView.tag = 101;
        [_tipWindow addSubview:progressView];
    }
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:100];
    label.text = title;
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    if(show)
    {
        _tipWindow.hidden = NO;
        if(operation != nil)
        {
            [progressView setProgressWithUploadProgressOfOperation:operation animated:YES];
        }
    }
    else
    {
        [self performSelector:@selector(delayHide) withObject:nil afterDelay:1.5];
    }
}
//延迟调用
-(void)delayHide
{
    _tipWindow.hidden = YES;
    _tipWindow = nil;//释放掉
}
@end
