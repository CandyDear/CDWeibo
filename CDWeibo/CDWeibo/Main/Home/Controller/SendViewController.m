//
//  SendViewController.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/19.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeButton.h"
#import "DataService.h"

@interface SendViewController ()
{
    //发送的图片
    UIImage *_sendImage;
}

@end

@implementation SendViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self _setNaviItem];
    [self _createSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //导航栏不透明，当导航栏不透明的时候 子视图的y的0位置在导航栏的下面
//    self.navigationController.navigationBar.translucent = NO;
//    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
    //弹出键盘
    [_textView becomeFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: animated ];
    //弹出键盘
    [_textView becomeFirstResponder];
}
#pragma mark - 导航栏
-(void)_setNaviItem
{
    //左边按钮
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftButton.bgNormalImageName = @"button_icon_close";
    [leftButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //右边按钮
    ThemeButton *rightButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightButton.bgNormalImageName = @"button_icon_ok";
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
-(void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)send
{
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0)
    {
        error = @"微博内容为空";
    }
    else if (text.length > 140)
    {
        error = @"微博内容大于140字符";
    }
    if (error != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //发送
    AFHTTPRequestOperation *operation = [DataService sendWeibo:text image:_sendImage block:^(id result) {
            NSLog(@"发送反馈：%@",result);
        [self showTip:@"发送成功" show:NO operation:operation];
        }];
    [self showTip:@"正在发送..." show:YES operation:operation];
    //[self dismissViewControllerAnimated:YES completion:nil];

    
}
#pragma mark - 子视图
-(void)_createSubViews
{
    //文本框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.editable = YES;
    _textView.layer.cornerRadius = 10;
    _textView.layer.borderWidth = 3;
    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_textView];
    //编辑栏
    _editBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
    _editBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editBar];
    //创建编辑按钮
    NSArray *imageNames = @[
                            @"compose_toolbar_1.png",
                            @"compose_toolbar_4.png",
                            @"compose_toolbar_3.png",
                            @"compose_toolbar_5.png",
                            @"compose_toolbar_6.png"
                            ];
    for(int i = 0;i < imageNames.count;i++)
    {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15 + (kScreenWidth / 5) * i, 20,40, 33)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.bgNormalImageName = imageNames[i];
        [_editBar addSubview:button];
    }
    //地址按钮提示
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 20)];
    _locationLabel.hidden = YES;
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.backgroundColor = [UIColor grayColor];
    [_editBar addSubview:_locationLabel];
    
    
}
-(void)buttonAction:(UIButton *)button
{
    if(button.tag == 0)
    {
        //添加照片
        [self _selectPhoto];
        
    }
    if(button.tag == 3)
    {
        //定位
        [self _location];
    }
}
#pragma mark - 选择照片
-(void)_selectPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    if(buttonIndex == 0)
    {
        //拍照UIImagePickerControllerCameraDeviceRear后置摄像头
        sourceType = UIImagePickerControllerSourceTypeCamera;
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if(!isCamera)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    else if (buttonIndex == 1)
    {
        //相册
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - 照片选择代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //01 弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    //02 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //03 显示缩略图
    if (_zoomImageView == nil)
    {
        _zoomImageView = [[ZoomImageView alloc] initWithImage:image];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom + 10, 80, 80);
        [self.view addSubview:_zoomImageView];
        _zoomImageView.delegate = self;
    }
    _zoomImageView.image = image;
    _sendImage = image;
    
}
#pragma mark - 图片的放大缩小
-(void)imageWillZoomIn:(ZoomImageView *)imageView
{
    [_textView resignFirstResponder];
}
-(void)imageWillZoomOut:(ZoomImageView *)imageView
{
    [_textView becomeFirstResponder];
}
#pragma mark - 键盘弹出或者隐藏通知
-(void)keyboardWillShow:(NSNotification *)notification
{
    //NSLog(@"keyboardWillShow");
    //取出键盘相当于window的frame
    NSValue *boundValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [boundValue CGRectValue];
    //键盘高度
    CGFloat height = frame.size.height;
    //调整视图高度
    _editBar.bottom = kScreenHeight - height - 64;
}
-(void)keyboardDidHide:(NSNotification *)notification
{
    _editBar.bottom = kScreenHeight;
}
#pragma mark -  定位
-(void)_location
{
    if(_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        //判断版本
        if(kVersion > 8.0)
        {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"已经更新位置");
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSLog(@"经度：%.2f,纬度：%.2f",coordinate.longitude,coordinate.latitude);
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo_to_address
    //拼接coordinate 经度 纬度
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:coordinateStr forKey:@"coordinate"];
     __weak __typeof(self)weakSelf = self;
     [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
         NSArray *geos = [result objectForKey:@"geos"];
         if(geos.count > 0)
         {
             NSDictionary *geoDic = [geos lastObject];
             NSString *address = geoDic[@"address"];
             NSLog(@"地址 %@",address);
             dispatch_async(dispatch_get_main_queue(), ^{
                 __strong __typeof(self) strongSelf = weakSelf;
                 strongSelf->_locationLabel.text = address;
                 strongSelf->_locationLabel.hidden = NO;
             });
             
             
             
         }
     }];
    
    //二 iOS 内置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = [placemarks lastObject];
        NSLog(@"%@",place.name);
    }];
}
@end
