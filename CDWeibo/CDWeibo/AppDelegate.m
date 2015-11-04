//
//  AppDelegate.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "Common.h"
#import "LeftDrawerViewController.h"
#import "RightDrawerViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //左边控制器
    LeftDrawerViewController * leftSideDrawerViewController = [[LeftDrawerViewController alloc] init];
    //中间控制器
    
    BaseTabBarController *tabBarC = [[BaseTabBarController alloc] init];

    //右边控制器
    RightDrawerViewController * rightSideDrawerViewController = [[RightDrawerViewController alloc] init];
    

    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:tabBarC
                                            leftDrawerViewController:leftSideDrawerViewController
                                            rightDrawerViewController:rightSideDrawerViewController];
    [drawerController setMaximumRightDrawerWidth:60];
    [drawerController setMaximumLeftDrawerWidth:120];
    
    //设置手势区域
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    //设置动画效果
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState swingingDoorVisualStateBlock];
    
    [drawerController setDrawerVisualStateBlock:block];
    

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    
    
    
    
    self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    //如果本地存储过令牌信息，则读取出来，表示已经登陆过
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"CDSinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    return YES;
}
//持久化存储
- (void)storeAuthData
{
    SinaWeibo *sinaweibo = self.sinaWeibo;
//    NSLog(NSHomeDirectory());
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"CDSinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
//移除数据
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CDSinaWeiboAuthData"];

}

#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    //登陆完成持久化存储，第二次将不用再次登陆（获得令牌）
    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    //（失去令牌）需要重新登录
    [self removeAuthData];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
