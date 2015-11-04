//
//  CommentModel.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/16.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "CommentModel.h"
#import "Utils.h"
@implementation CommentModel
-(void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    self.user = user;
    NSDictionary *status = [dataDic objectForKey:@"status"];
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:status];
    self.weibo = weibo;
    NSDictionary *commenDic = [dataDic objectForKey:@"reply_comment"];
    if(commenDic != nil)
    {
        CommentModel *sourceComment = [[CommentModel alloc] initWithDataDic:commenDic];
        self.sourceComment = sourceComment;
    }
    //处理评论中的表情
    self.text = [Utils parseTextImage:_text];
}
@end
