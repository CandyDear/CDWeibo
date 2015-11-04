//
//  MoreTableViewCell.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/9.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell
-(void)dealloc
{
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self _createSubViews];
        [self themeChangeAction];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}
-(void)_createSubViews
{
    _themeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    _themeTextLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(_themeImageView.right + 5, 11, 200, 20)];
    _themeTextLabel.font = [UIFont boldSystemFontOfSize:16];
    _themeTextLabel.backgroundColor = [UIColor clearColor];
    _themeTextLabel.colorName = @"More_Item_Text_color";
    
    _themeDetailLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(self.right - 95 - 30, 11, 95, 20)];
    _themeDetailLabel.font = [UIFont boldSystemFontOfSize:14];
//    [_themeDetailLabel sizeToFit];
    _themeDetailLabel.backgroundColor = [UIColor clearColor];
    _themeDetailLabel.colorName = @"More_Item_Text_color";
    _themeDetailLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_themeImageView];
    [self.contentView addSubview:_themeTextLabel];
    [self.contentView addSubview:_themeDetailLabel];
    
    
}
-(void)themeChangeAction
{
    //接收到通知 改变cell背景颜色
    self.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
}
-(void)layoutSubviews
{
    _themeDetailLabel.frame = CGRectMake(self.right - 95 - 30, 11, 95, 20);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
