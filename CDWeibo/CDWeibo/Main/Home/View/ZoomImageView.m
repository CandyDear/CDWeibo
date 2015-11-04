//
//  ZoomImageView.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/17.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
@implementation ZoomImageView
{
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_data;
    MBProgressHUD *_hud;
    ALAssetsLibrary *_assetsLibrary;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //01   添加单击手势
        [self initTap];
        //02 添加gif图标
        [self createGifIcon];
        NSLog(@"init");
    }
    return self;
}
-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self initTap];
        [self createGifIcon];
        NSLog(@"initWithImage");
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initTap];
        [self createGifIcon];
        NSLog(@"initWithCoder");
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initTap];
        [self createGifIcon];
        NSLog(@"initWithFrame");
    }
    return self;
}
- (void)initTap{
    //01 打开交互
    self.userInteractionEnabled = YES;
    //02 创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
    //03 修改内容模式
    self.contentMode = UIViewContentModeScaleAspectFit;
    
}
#pragma mark - 保存到相册
-(void)savePhotos:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        //弹出提示框
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alterView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UIImage *image = _fullImageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:) , nil);
    }
}
//保存成功调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}
- (void)zoomIn{
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)])
    {
        [self.delegate imageWillZoomIn:self];
    }
    
    self.hidden = YES;
    //01 创建缩放视图
    [self createView];
    //02 把相对于cell的frame转换成相对于window的frame
    //self.frame --> cell
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    //03 动画
   
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _fullImageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        //04 下载
        [self downLoadImage];
    }];
}
-(void)createGifIcon
{
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"timeline_gif"];
    [self addSubview:_iconImageView];
    _iconImageView.hidden = YES;
}

- (void)createView{
    if (_scrollView == nil) {
        //01 scrollView 添加到window上
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_scrollView];
        
        //02  大图显示
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        //创建单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        //创建长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePhotos:)];
        [_scrollView addGestureRecognizer:longPress];

        
    }
}

- (void)zoomOut{
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)])
    {
        [self.delegate imageWillZoomOut:self];
    }
    //取消网络下载
    [_connection cancel];
    
    self.hidden = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        //如果scroll内容偏移,偏移量也要考虑进去
        _fullImageView.top +=_scrollView.contentOffset.y;
        
        
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        
        
    }];
    
}
-(void)downLoadImage
{
    if(_fullImageUrlStr.length != 0)
    {
        //下载进度显示
        _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        NSURL *url = [NSURL URLWithString:_fullImageUrlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //获取响应头
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headFields = [httpResponse allHeaderFields];
    //NSLog(@"%@",headFields);
    NSString *lengthStr = headFields[@"Content-Length"];
    _length = [lengthStr doubleValue];
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    CGFloat progress = _data.length / _length;
    _hud.progress = progress;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _hud.hidden = YES;
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    //kScreenWidth/length = image.size.width/image.size.height
    CGFloat length = image.size.height/image.size.width * kScreenWidth;
    if(length > kScreenHeight)
    {
       [UIView animateWithDuration:0.3 animations:^{
           _fullImageView.height = length;
           _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
       }];
    }
    if(_isGif)
    {
        [self showGif];
    }
}
-(void)showGif
{
    //方法一  使用WebView播放
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//    webView.userInteractionEnabled = NO;
//    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:webView];
    //方法二 使用三方 sdWebImage
    //_fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    //方法三 用ImageIO
    //创建图片源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    //得到图片个数
    size_t count = CGImageSourceGetCount(source);
    
    //把所有的图片 解析到 数组中
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i++) {
        //获取每一张图片 放到UIImage对象里面
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        duration += 0.1;
        
        [images addObject:[UIImage imageWithCGImage:image]];
        
        CGImageRelease(image);
    }
    
    //播放一
    //    _fullImageView.animationImages = images;
    //    _fullImageView.animationDuration = duration;
    //    [_fullImageView startAnimating];
    //
    //播放二
    
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    _fullImageView.image = animatedImage;
    
    CFRelease(source);
}
@end

