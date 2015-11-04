//
//  BaseTabBarController.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
@interface BaseTabBarController : UITabBarController<SinaWeiboRequestDelegate,SinaWeiboDelegate>

@end
