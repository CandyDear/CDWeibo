//
//  ThemeImageView.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/9.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView
@property(nonatomic,copy)NSString *imageName;
@property(nonatomic,assign) CGFloat leftCap;//拉伸点
@property(nonatomic,assign) CGFloat topCap;
@end
