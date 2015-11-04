//
//  HeadView.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/14.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "HeadView.h"
#import "UIImageView+WebCache.h"
@implementation HeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//-(void)awakeFromNib
//{
//    WeiboModel *model = _layout.weiboModel;
//    //1.头像
//    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userModel.profile_image_url]];
//    //2.昵称
//    _nickNameLabel.text = model.userModel.screen_name;
//    //3.性别 地点
//    _baseLabel.text = model.userModel.gender;
//    //4.简介
//    _introduceLabel.text = model.userModel.description;
//    
//
//}




//-(void)setLayout:(WeiboViewLayoutFrame *)layout
//{
//    if(_layout != layout)
//    {
//        _layout = [layout copy];
//        [self setNeedsLayout];
//    }
//}
- (IBAction)attentionAction:(UIButton *)sender {
}

- (IBAction)fansAction:(UIButton *)sender {
}

- (IBAction)dataAction:(UIButton *)sender {
}

- (IBAction)MoreAction:(UIButton *)sender {
}
@end
