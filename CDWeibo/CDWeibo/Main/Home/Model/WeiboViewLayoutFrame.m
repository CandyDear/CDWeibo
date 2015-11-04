//
//  WeiboViewLayoutFrame.m
//  XSWeibo
//
//  Created by gj on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboViewLayoutFrame.h"
#import "WXLabel.h"
@implementation WeiboViewLayoutFrame

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {

        _weiboModel = weiboModel;
        //计算各个frame
        [self _layoutFrames];
    
    }
}

//- (void)_layoutFrames{
//    //实际数据中，根据微博文字内容计算高度，这里先用假设数值
//    _textFrame = CGRectMake(5, 5, 280, 60);
//    _srTextFrame = CGRectMake(5, 70, 280, 70);
//    _imgFrame = CGRectMake(5, 145, 80, 80);
//    _bgImageFrame = CGRectMake(5, 65, 280, 160);
//    
//    _frame = CGRectMake(60, 50, 280, 230);
//
//   
//}

- (void)_layoutFrames{
    //01微博字体的设置
    CGFloat weiboFontSize = FoneSize_Weibo(self.isDetail);
    CGFloat reWeiboFontSize = FontSize_ReWeibo(self.isDetail);
    //02整个weiboView 的宽度
    if(self.isDetail)
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }
    else
    {
        //1.微博视图的frame
        self.frame = CGRectMake(55, 40, kScreenWidth-65, 0);
    }
    //根据 weiboModel计算
    //2.微博内容的frame
    //1>计算微博内容的宽度
    CGFloat textWidth = CGRectGetWidth(self.frame)-20;
    
    //2>计算微博内容的高度
    NSString *text = self.weiboModel.text;
    CGFloat textHeight = [WXLabel getTextHeight:weiboFontSize width:textWidth text:text linespace:5.0];
    
    self.textFrame = CGRectMake(10, 0, textWidth, textHeight);
    
    //3.原微博的内容frame
    if (self.weiboModel.reWeiboModel != nil)
    {
        NSString *reText = self.weiboModel.reWeiboModel.text;
        
        //1>宽度
        CGFloat reTextWidth = textWidth-20;
        //2>高度
        
        CGFloat textHeight = [WXLabel getTextHeight:reWeiboFontSize width:reTextWidth text:reText linespace:5.0];
        
        //3>Y坐标
        CGFloat Y = CGRectGetMaxY(self.textFrame)+10;
        self.srTextFrame = CGRectMake(20, Y, reTextWidth, textHeight);
        
        //4.原微博的图片
        NSString *thumbnailImage = self.weiboModel.reWeiboModel.thumbnailImage;
        if (thumbnailImage != nil)
        {
            CGFloat Y = CGRectGetMaxY(self.srTextFrame)+10;
            CGFloat X = CGRectGetMinX(self.srTextFrame);
            if(self.isDetail)
            {
                self.imgFrame = CGRectMake(X, Y, self.frame.size.width - 40, 160);
            }
            else
            {
                self.imgFrame = CGRectMake(X, Y, 80, 80);
            }
            
        }
        
        //4.原微博的背景
        CGFloat bgX = CGRectGetMinX(self.textFrame);
        CGFloat bgY = CGRectGetMaxY(self.textFrame);
        CGFloat bgWidth = CGRectGetWidth(self.textFrame);
        CGFloat bgHeight = CGRectGetMaxY(self.srTextFrame);
        if (thumbnailImage != nil) {
            bgHeight = CGRectGetMaxY(self.imgFrame);
        }
        bgHeight -= CGRectGetMaxY(self.textFrame);
        bgHeight += 10;
        
        self.bgImageFrame = CGRectMake(bgX, bgY, bgWidth, bgHeight);
        
    }
    else
    {
        //微博图片
        NSString *thumbnailImage = self.weiboModel.thumbnailImage;
        if (thumbnailImage != nil)
        {
            
            CGFloat imgX = CGRectGetMinX(self.textFrame);
            CGFloat imgY = CGRectGetMaxY(self.textFrame)+10;
            if(self.isDetail)
            {
                self.imgFrame = CGRectMake(imgX, imgY,self.frame.size.width - 40, 160);
            }
            else
            {
                self.imgFrame = CGRectMake(imgX, imgY, 80, 80);
            }
        }
        
    }
    
    //计算微博视图的高度：微博视图最底部子视图的Y坐标
    CGRect f = self.frame;
    if (self.weiboModel.reWeiboModel != nil) {
        f.size.height = CGRectGetMaxY(_bgImageFrame);
    }
    else if(self.weiboModel.thumbnailImage != nil) {
        f.size.height = CGRectGetMaxY(_imgFrame);
    }
    else {
        f.size.height = CGRectGetMaxY(_textFrame);
    }
    self.frame = f;
    
}



@end
