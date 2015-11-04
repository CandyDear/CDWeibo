//
//  HeadView.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/14.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboViewLayoutFrame.h"
#import "WeiboModel.h"
#import "ThemeLabel.h"
@interface HeadView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet ThemeLabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet ThemeLabel *baseLabel;
@property (strong, nonatomic) IBOutlet ThemeLabel *introduceLabel;
@property (nonatomic,strong) NSString *location;
@property(nonatomic,retain)NSNumber * followers_count;  //粉丝数
@property(nonatomic,retain)NSNumber * friends_count;   //关注数
- (IBAction)attentionAction:(UIButton *)sender;
- (IBAction)fansAction:(UIButton *)sender;
- (IBAction)dataAction:(UIButton *)sender;
- (IBAction)MoreAction:(UIButton *)sender;
@property(nonatomic,strong) WeiboViewLayoutFrame *layout;
@end
