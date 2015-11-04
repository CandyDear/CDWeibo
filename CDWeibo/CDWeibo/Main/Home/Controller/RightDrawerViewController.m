//
//  RightDrawerViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/10.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "RightDrawerViewController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "SendViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavController.h"
#import "LocViewController.h"
@interface RightDrawerViewController ()

@end

@implementation RightDrawerViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setBackgroundImage];
    [self _createButtons];
}
-(void)_setBackgroundImage
{
    ThemeImageView *imageView = [[ThemeImageView alloc] initWithFrame:self.view.bounds];
    imageView.imageName = @"bg_home.jpg";
    self.view = imageView;
    imageView.userInteractionEnabled = YES;
}
-(void)_createButtons
{
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    for(int i = 0;i < imageNames.count;i++)
    {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(10, 64 + i * 40, 40, 40)];
        button.normalImageName = imageNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonAction:(UIButton *)button
{
    NSLog(@"点击");
    if(button.tag == 0)
    {
        //发送微博
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            //弹出发送微博控制器
            SendViewController *sendVC = [[SendViewController alloc] init];
            sendVC.title = @"发送微博";
            //创建导航控制器
            BaseNavController *baseNaC = [[BaseNavController alloc] initWithRootViewController:sendVC];
            [self.mm_drawerController presentViewController:baseNaC animated:YES completion:nil];

        }];
    }
    if(button.tag == 4)
    {
        //附近商圈
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            //弹出附近商圈视图控制器
            LocViewController *locVC = [[LocViewController alloc] init];
            locVC.title = @"附近商圈";
            //创建导航控制器
            BaseNavController *baseNaC = [[BaseNavController alloc] initWithRootViewController:locVC];
            [self.mm_drawerController presentViewController:baseNaC animated:YES completion:nil];
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
