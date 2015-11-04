//
//  UserCell.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/22.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "UserCell.h"
#import "UIImageView+WebCache.h"
@implementation UserCell

//- (void)awakeFromNib
//{
//    
//}
-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    if(_weiboModel != weiboModel)
    {
        _weiboModel = weiboModel;
        
        _userName.text = _weiboModel.userModel.screen_name;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_weiboModel.userModel.profile_image_url]];
        
        _fans.text = [NSString stringWithFormat:@"%li粉丝",[_weiboModel.userModel.followers_count integerValue]];
    }
}
@end
