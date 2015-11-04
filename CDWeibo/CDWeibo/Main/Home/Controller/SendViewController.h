//
//  SendViewController.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/19.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>

@interface SendViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate>
{
    //文本编辑框
    UITextView *_textView;
    //工具栏
    UIView *_editBar;
    //缩略图
    ZoomImageView *_zoomImageView;
    //位置管理
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;

}
@end
