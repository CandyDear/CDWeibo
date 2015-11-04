//
//  ZoomImageView.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/17.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>
@optional
-(void)imageWillZoomIn:(ZoomImageView *)imageView;
-(void)imageWillZoomOut:(ZoomImageView *)imageView;
-(void)imageDidZoomIn:(ZoomImageView *)imageView;
-(void)imageDidZoomOut:(ZoomImageView *)imageView;
@end
@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
}
@property (nonatomic,weak) id<ZoomImageViewDelegate> delegate;
@property (nonatomic,strong) NSString *fullImageUrlStr;
@property (nonatomic,strong) UIImageView *iconImageView;
//判断是否是gif
@property (nonatomic,assign) BOOL isGif;
@end
