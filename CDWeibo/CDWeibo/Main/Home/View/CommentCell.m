//
//  CommentCell.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/16.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"

#import "WeiboModel.h"
@implementation CommentCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        _commentTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _commentTextLabel.font = [UIFont systemFontOfSize:14];
        _commentTextLabel.linespace = 5;
        _commentTextLabel.wxLabelDelegate = self;
        [self.contentView addSubview:_commentTextLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    NSString *urlString = _commentModel.user.profile_image_url;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    //昵称
    _nameLabel.text = _commentModel.user.screen_name;
    //评论内容
    CGFloat height = [WXLabel getTextHeight:14 width:240 text:_commentModel.text linespace:5];
    _commentTextLabel.frame = CGRectMake(_headImageView.right + 10, _nameLabel.bottom + 5, kScreenWidth - 70, height);
    _commentTextLabel.text = _commentModel.text;

    
}
//返回一个正则表达式，通过此正则表达式查找出需要添加超链接的文本
-(NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#^#+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    UIColor *linkColor = [[ThemeManager shareInstance] getThemeColor:@"Link_color"];
    return linkColor;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}


//计算评论单元格的高度
+(CGFloat)getCommentHeight:(CommentModel *)commentModel {
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:kScreenWidth-70
                                       text:commentModel.text
                                  linespace:5];
    
    
    
    return height+40;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
