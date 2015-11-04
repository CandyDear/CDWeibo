//
//  BaseViewController.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/8.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
@interface BaseViewController : UIViewController
-(void)setNavItem;
-(void)showHudWithTitle:(NSString *)title;
-(void)completeHudWithTitle:(NSString *)title;
-(void)showLoading:(BOOL)show;
-(void)showTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation;
@end
