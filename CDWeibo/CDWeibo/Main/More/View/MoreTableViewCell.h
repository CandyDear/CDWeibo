//
//  MoreTableViewCell.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/9.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
@interface MoreTableViewCell : UITableViewCell
//为了实现 主题的切换
@property(nonatomic,strong) ThemeImageView *themeImageView;
@property(nonatomic,strong) ThemeLabel *themeTextLabel;
@property(nonatomic,strong) ThemeLabel *themeDetailLabel;
@end
