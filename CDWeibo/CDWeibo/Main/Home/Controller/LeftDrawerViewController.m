//
//  LeftDrawerViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/10.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "ThemeImageView.h"
@interface LeftDrawerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@end

@implementation LeftDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createTableView];
}
-(void)_createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    ThemeImageView *imageView = [[ThemeImageView alloc] initWithFrame:tableView.frame];
    imageView.imageName = @"bg_home.jpg";
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = imageView;
    [self.view addSubview:tableView];
}
#pragma mark - UITableViewDataSourse delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    if(indexPath.section == 0)
    {
        NSArray *titleNames = @[@"无",
                                @"偏移",
                                @"偏移&缩放",
                                @"旋转",
                                @"视差"];
        cell.textLabel.text = titleNames[indexPath.row];
        
    }
    else if (indexPath.section == 1)
    {
        NSArray *titleNames = @[@"小图",
                                @"大图"];
        cell.textLabel.text = titleNames[indexPath.row];

    }
    
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return  @"界面切换效果";
    }
    return @"图片浏览模式";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 150;
    }
    return 80;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
