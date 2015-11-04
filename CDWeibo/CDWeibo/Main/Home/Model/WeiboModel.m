//
//  WeiboModel.m
//  CDWeibo
//
//  Created by CandyDear on 15/10/12.
//  Copyright (c) 2015年 mac04. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel

- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    return mapAtt;
}

- (void)setAttributes:(NSDictionary*)dataDic{
    
    [super setAttributes:dataDic];
    //NSLog(@"%@",_source);
    //<a href="http://app.weibo.com/t/feed/1J95c3" rel="nofollow">红米手机</a>
    //01 微博来源处理
    if(_source != nil)
    {
        NSString *regex = @">.+<";
        NSArray *array = [_source componentsMatchedByRegex:regex];
        if (array.count != 0)
        {
            NSString *string = array[0];//>红米手机<
            string = [string substringWithRange:NSMakeRange(1, string.length - 2)];//红米手机
            _source = [NSString stringWithFormat:@"来源:%@",string];
        }
    }
    
    //用户信息解析
    NSDictionary *userDic  = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        _userModel = [[UserModel alloc] initWithDataDic:userDic];
    }
    
    //被转发的微博
    NSDictionary *reWeiBoDic = [dataDic objectForKey:@"retweeted_status"];
    if (reWeiBoDic != nil) {
        _reWeiboModel = [[WeiboModel alloc] initWithDataDic:reWeiBoDic];
        //02 转发微博的用户名处理，加在转发内容之前
        NSString *name = _reWeiboModel.userModel.screen_name;
        _reWeiboModel.text = [NSString stringWithFormat:@"@%@:%@",name,_reWeiboModel.text];
    }
    //表情处理
    NSString *regex = @"\\[\\w+\\]";
    //[兔子][微笑]
    NSArray *faceItems = [_text componentsMatchedByRegex:regex];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceConfigArray = [NSArray arrayWithContentsOfFile:filePath];
    
    for(NSString *faceName in faceItems)
    {
        //faceName '兔子'
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];//self.chs='兔子'
        //谓词NSPredicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        NSArray *items = [faceConfigArray filteredArrayUsingPredicate:predicate];//所有plist中chs的键值
        if(items.count > 0)
        {
            NSString *imageName = [items[0] objectForKey:@"png"];
            //<image url = '1.png'>
            NSString *urlStr = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            _text = [_text stringByReplacingOccurrencesOfString:faceName withString:urlStr];
        }
    }
    
}


@end
