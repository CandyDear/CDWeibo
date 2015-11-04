//
//  UserCollectionView.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/22.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "UserCollectionView.h"
#import "UserCell.h"
#import "UserListModel.h"
#import "UIImageView+WebCache.h"
@implementation UserCollectionView
-(void)setListModel:(UserListModel *)listModel
{
    if(_listModel != listModel)
    {
        _listModel = listModel;
       // _data = _listModel.modelArray;
    }
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self)
    {
        self.dataSource = self;
        self.delegate = self;
        UINib *nib = [[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil] lastObject];
        [self registerNib:nib forCellWithReuseIdentifier:@"UserCell"];
    }
    return self;
}
#pragma mark - UICollectionView 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    //NSLog(@"%@",_data[indexPath.item]);
    UserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    cell.weiboModel = _data[indexPath.item];
    WeiboModel *model = cell.weiboModel;
    cell.backgroundColor = [UIColor redColor];
//    cell.userName.text = model.userModel.screen_name;
//    NSString *imageStr = model.userModel.profile_image_url;
//    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
//    cell.fans.text = [NSString stringWithFormat:@"%li粉丝",[model.userModel.followers_count integerValue]];
    //设置边框颜色
    cell.layer.borderColor = [UIColor purpleColor].CGColor;
    //设置边框宽度
    cell.layer.borderWidth = 3;
    //视图的圆角
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;

    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat itemWidth = (kScreenWidth - 10 * 4)/3;
//    CGFloat itemHeight = itemWidth * 1.3;
//    return CGSizeMake(itemWidth, itemHeight);
//}

#pragma mark - UICollectionViewDelegateFlowLayout
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击跳转到详情页面
}

@end
