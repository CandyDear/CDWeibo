//
//  ThemeManager.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/9.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeNameDidChangeNotification @"kThemeNameDidChangeNotification"
//字典中的一个key值
#define kThemeName @"kThemeName"
@interface ThemeManager : NSObject
@property(nonatomic,strong)NSDictionary *themeConfig;//theme.plist的内容
@property(nonatomic,copy)NSString *themeName;//主题名字
@property(nonatomic,strong)NSDictionary *colorConfig;//每个主题目录下config.plist内容 颜色值
+(ThemeManager *)shareInstance;//单例方法
-(UIImage *)getThemeImage:(NSString *)imageName;//根据图片名字获得对应主题包下的图片
-(UIColor *)getThemeColor:(NSString *)colorName;

@end
