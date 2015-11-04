//
//  WeiboView.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/12.
//  Copyright (c) 2015年 mac04. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "WeiboViewLayoutFrame.h"
#import "WXLabel.h"
#import "ZoomImageView.h"
@interface WeiboView : UIView<WXLabelDelegate>
@property(nonatomic,strong) WXLabel *textLabel;//微博文字
@property(nonatomic,strong) WXLabel *sourceTextLabel;//如果转发，原微博文字
@property(nonatomic,strong) ZoomImageView *imageView;//微博图片
@property(nonatomic,strong) ThemeImageView *bgImageView;//原微博背景图片

@property(nonatomic,strong) WeiboViewLayoutFrame *layoutFrame;//布局对象

@end
