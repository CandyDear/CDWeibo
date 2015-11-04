//
//  WeiboTableView.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/12.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboViewLayoutFrame.h"
#import "WeiboDetailViewController.h"
#import "UIView+UIViewController.h"
@implementation WeiboTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        self.dataSource = self;
        self.delegate = self;
        //注册cell
//        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WeiboCell"];
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //使用此方法必须先注册
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
//    WeiboModel *model = [[WeiboModel alloc] initWithDataDic:_data[indexPath.row]];
    WeiboViewLayoutFrame *layout = _data[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.layout = layout;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboViewLayoutFrame *layout = _data[indexPath.row];
//    NSLog(@"%f",layout.frame.size.height);
    return layout.frame.size.height + 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboDetailViewController *detailVC = [[WeiboDetailViewController alloc] init];
    WeiboViewLayoutFrame *layout = _data[indexPath.row];
    WeiboModel *model = layout.weiboModel;
    detailVC.model = model;
    //依据响应者链原理找到视图控制器
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}
@end
