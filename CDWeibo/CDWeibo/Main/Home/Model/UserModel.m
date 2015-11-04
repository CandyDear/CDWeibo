//
//  UserModel.m
//  XSWeibo
//
//  Created by gj on 15/9/11.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"userDescription" : @"description",
                             @"gender" : @"gender",
                             @"location" : @"location",
                             @"screen_name" : @"screen_name",
                             @"profile_image_url" : @"profile_image_url",
                             @"followers_count" : @"followers_count",
                             @"friends_count" : @"friends_count",
                             @"idstr" : @"idstr",
                             @"name" : @"name",
                             @"url" : @"url",
                             @"avatar_large" : @"avatar_large",
                             @"statuses_count" : @"statuses_count",
                             @"favourites_count" : @"favourites_count",
                             @"verified" : @"verified"
                             };
    return mapAtt;
}

@end
