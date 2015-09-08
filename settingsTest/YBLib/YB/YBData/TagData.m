//
//  TagData.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "TagData.h"
#import "LevelDB.h"
#define TAG_DATA @"TAG_DATA"
static  LevelDB * db;
@implementation TagData

+ (void)setTags:(id)tags{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db set:TAG_DATA value:tags];
    } finaly:nil];
}

+ (id) getTags{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
    } finaly:nil];
    return [db get:TAG_DATA];
}

+ (void)delTags{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db del:TAG_DATA];
    } finaly:nil];
}

@end
