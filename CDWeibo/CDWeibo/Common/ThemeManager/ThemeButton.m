//
//  ThemeButton.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/9.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //注册通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
        
    }
    return self;
}
//接收到通知
-(void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}
//当图片名字切换的时候 重新向主题管家获取图片
-(void)setNormalImageName:(NSString *)normalImageName
{
    if (![_normalImageName isEqualToString:normalImageName])
    {
        _normalImageName = [normalImageName copy];
        [self _loadImage];
    }
}
-(void)setBgNormalImageName:(NSString *)bgNormalImageName
{
    if (![_bgNormalImageName isEqualToString:bgNormalImageName])
    {
        _bgNormalImageName = [bgNormalImageName copy];
        [self _loadImage];
    }
}
-(void)_loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    if (_normalImageName != nil)
    {
        UIImage *image = [manager getThemeImage:_normalImageName];
        if (image != nil)
        {
            [self setImage:image forState:UIControlStateNormal];
        }
    }
    if (_bgNormalImageName != nil)
    {
        UIImage *image = [manager getThemeImage:_bgNormalImageName];
        if (image != nil)
        {
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
 
    
}


@end
