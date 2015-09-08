//
//  UserData.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "UserData.h"
#import "LevelDB.h"
#define USER_DATA @"USER_DATA"
static  LevelDB * db;
@implementation UserData
+ (void) setUser:(id)user{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db set:USER_DATA value:user];
    } finaly:nil];
}
+ (id) getUser {
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
    } finaly:nil];
    return [db get:USER_DATA];
}
+ (void)delUser {
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db del:USER_DATA];
    } finaly:nil];
}
@end
