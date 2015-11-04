//
//  WeiboCell.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/12.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "WeiboView.h"

@interface WeiboCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel *repostLabel;
@property (strong, nonatomic) IBOutlet UILabel *resourseLabel;
//@property (nonatomic,strong) WeiboModel *model;
@property (nonatomic,strong) WeiboViewLayoutFrame *layout;
@property (nonatomic,strong) WeiboView *weiboView;
@end
