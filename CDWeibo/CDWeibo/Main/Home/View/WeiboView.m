//
//  WeiboView.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/12.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
@implementation WeiboView
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//当使用该方法创建weiboView的时候要调用而不是用init
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self _createSubViews];
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self _createSubViews];
    }
    return self;
}
-(void)_createSubViews
{
    
    //1.微博内容
    _textLabel = [[WXLabel alloc] init];
    _textLabel.wxLabelDelegate = self;
    _textLabel.linespace = 5;
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    [self addSubview:_textLabel];
    //2.原微博内容
    _sourceTextLabel = [[WXLabel alloc] init];
    _sourceTextLabel.wxLabelDelegate = self;
    _sourceTextLabel.linespace = 5;
    _sourceTextLabel.font = [UIFont systemFontOfSize:14];
    _sourceTextLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    [self addSubview:_sourceTextLabel];
    //3.微博图片
    _imageView = [[ZoomImageView alloc] init];
    [self addSubview:_imageView];
    //4.背景图片
    
    _bgImageView = [[ThemeImageView alloc] init];
    //设置背景图片拉伸点
    _bgImageView.leftCap = 30;
    _bgImageView.topCap = 30;
     _bgImageView.imageName = @"timeline_rt_border_9.png";

    
    [self insertSubview:_bgImageView atIndex:0];
    //5.监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:)name:kThemeNameDidChangeNotification object:nil];
    
    
}
-(void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame
{
    if(_layoutFrame != layoutFrame)
    {
        _layoutFrame = layoutFrame;
        [self setNeedsLayout];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //设置字体
    _textLabel.font = [UIFont systemFontOfSize:FoneSize_Weibo(_layoutFrame.isDetail)];
    _sourceTextLabel.font = [UIFont systemFontOfSize:FontSize_ReWeibo(_layoutFrame.isDetail)];
    
    WeiboModel *model = _layoutFrame.weiboModel;
    //微博文字
    _textLabel.frame = _layoutFrame.textFrame;
    _textLabel.text = model.text;
    
    //判断有无转发微博
    if(model.reWeiboModel != nil)
    {
        _bgImageView.hidden = NO;
        _sourceTextLabel.hidden = NO;
        //被转发的微博
        _sourceTextLabel.frame = _layoutFrame.srTextFrame;
        _sourceTextLabel.text = model.reWeiboModel.text;
        
        //背景图片
        _bgImageView.frame = _layoutFrame.bgImageFrame;
        
        //图片
        NSString *imageString = model.reWeiboModel.thumbnailImage;
        if(imageString == nil)
        {
            _imageView.hidden = YES;
        }
        else
        {
            //大图链接
            _imageView.fullImageUrlStr = model.reWeiboModel.originalImage;
            _imageView.hidden = NO;
            _imageView.frame = _layoutFrame.imgFrame;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
        }
    }
    else
    {
        _bgImageView.hidden = YES;
        _sourceTextLabel.hidden = YES;
        //图片
        NSString *imageString = model.thumbnailImage;
        if(imageString == nil)
        {
            _imageView.hidden = YES;
        }
        else
        {
            //大图链接
            _imageView.fullImageUrlStr = model.originalImage;
            _imageView.hidden = NO;
            _imageView.frame = _layoutFrame.imgFrame;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
        }

        
    }
    //判断图片是否是gif
    if(_imageView.hidden == NO)
    {
        _imageView.iconImageView.frame = CGRectMake(_imageView.width - 24, _imageView.height - 24, 24, 24);
        //后缀
        NSString *extension;
        if(model.reWeiboModel != nil)
        {
            extension = [model.reWeiboModel.thumbnailImage pathExtension];
        }
        else
        {
            extension = [model.thumbnailImage pathExtension];
        }
        if([extension isEqualToString:@"gif"])
        {
            //是gif
            _imageView.isGif = YES;
            _imageView.iconImageView.hidden = NO;
            
        }
        else
        {
            //不是gif
            _imageView.isGif = NO;
            _imageView.iconImageView.hidden = YES;
        }
    }
    
}
#pragma mark - 主题切换通知
- (void)themeDidChange:(NSNotification *)notification
{
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceTextLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Timeline_Content_color"];
    
}
#pragma mark - WXLabel 代理
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    NSLog(@"开始点击");
//    wxLabel.textColor = [UIColor blueColor];
}


//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    return  [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    
    return  [UIColor purpleColor];
}
//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    NSLog(@"点击结束");
//    wxLabel.textColor = [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
}

@end
