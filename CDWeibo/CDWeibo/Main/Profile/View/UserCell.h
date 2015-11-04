//
//  UserCell.h
//  CDWeibo
//
//  Created by CandyDear on 15/10/22.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
@interface UserCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *fans;
@property (nonatomic, strong) WeiboModel *weiboModel;
@end
