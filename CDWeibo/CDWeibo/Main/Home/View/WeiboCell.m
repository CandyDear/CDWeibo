//
//  WeiboCell.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/12.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"

@implementation WeiboCell

- (void)awakeFromNib {

    [self _createSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//复写setModel方法，当model设置的时候重新布局子视图
//-(void)setModel:(WeiboModel *)model
//{
//    if(_model != model)
//    {
//        _model = model;
//        [self setNeedsLayout];
//    }
//}
-(void)setLayout:(WeiboViewLayoutFrame *)layout
{
    if(_layout != layout)
    {
        _layout = layout;
        _weiboView.layoutFrame = _layout;
        [self setNeedsLayout];
    }
}
-(void)_createSubViews
{
    _weiboView = [[WeiboView alloc] init];
    [self.contentView addSubview:_weiboView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    WeiboModel *model = _layout.weiboModel;
    //01 头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.userModel.profile_image_url]];
    //02 昵称
    _nickNameLabel.text = model.userModel.screen_name;
    //03 评论数
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",model.commentsCount];
    //04 转发数
    _repostLabel.text = [NSString stringWithFormat:@"转发:%@",model.repostsCount];
    //05 来源
    _resourseLabel.text = model.source;
    //06微博内容
    _weiboView.layoutFrame = _layout;
    //06 对weiboView进行布局显示
#warning 微博详情：整个weiboView的 x y 在这里设置
    _weiboView.frame = _layout.frame;

}

@end
