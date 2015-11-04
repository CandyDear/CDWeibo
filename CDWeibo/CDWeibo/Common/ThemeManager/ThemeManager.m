//
//  ThemeManager.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/9.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

//实现单例 整个程序运行期间 只创建一个 管家对象
+(ThemeManager *)shareInstance
{
    static ThemeManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
//    NSLog(@"%@",instance);
    return instance;
}
//1.png
//路径 + 1.png
//当主题名修改的时候触发的通知
-(void)setThemeName:(NSString *)themeName
{
    if(![_themeName isEqualToString:themeName])
    {
        _themeName = [themeName copy];
        //1.把主题名字存储到plist中NSUserDefaults，持久化保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //当主题名字改变的时候发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeNameDidChangeNotification object:nil];
        
        //2.重新读取颜色配置文件
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //NSLog(@"----------------%@",_colorConfig);
    }
}
-(instancetype)init
{
    self = [super init];
    
    if(self)
    {
        //读取本地持久化存储的主题名字
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if(_themeName.length == 0)
        {
            //如果为空，默认主题名
            _themeName = @"Cat";
        }
        //_themeConfig 字典存储主题名 与主题包对应的关系
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        //读取颜色配置
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self;
}


-(UIColor *)getThemeColor:(NSString *)colorName
{
    if(colorName.length == 0)
    {
        return nil;
    }
    //获取配置文件中 rgb值
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    CGFloat alpha = 1;
    if(rgbDic[@"alpha"] != nil)
    {
        alpha = [rgbDic[@"alpha"] floatValue];
    }
    //通过rgb值创建UIColor对象
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    return color;
}
-(UIImage *)getThemeImage:(NSString *)imageName
{
    //获取 主题包路径
    NSString *themePath = [self themePath];
    //拼接 主题路径 ＋ imageName
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    //得到 UIImage
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

//获取主题包路径
-(NSString *)themePath
{
    //bundle资源根路径即/.../image
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath]; // + /Skins/cat
    //在_themeConfig字典中 获取主题名字 对应的主题包路径后缀即/Skins/cat
    NSString *pathSuffix = [_themeConfig objectForKey:self.themeName];
    //拼接完整的主题包路径
    NSString *path = [resourcePath stringByAppendingPathComponent:pathSuffix];
    return path;
    
}
@end
