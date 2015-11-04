//
//  CommentCell.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/16.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CommentModel.h"
@interface CommentCell : UITableViewCell<WXLabelDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) WXLabel *commentTextLabel;
@property (nonatomic, strong) CommentModel *commentModel;


//计算评论单元格的高度
+(CGFloat)getCommentHeight:(CommentModel *)commentModel;

@end
