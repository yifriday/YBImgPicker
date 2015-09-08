//
//  SessionData.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "SessionData.h"
#import "LevelDB.h"
#define SESSION_DATA @"SESSION_DATA"
static  LevelDB * db;
@implementation SessionData
+ (void) setSession:(id)session{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db set:SESSION_DATA value:session];
    } finaly:nil];
}
+ (id) getSession {
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
    } finaly:nil];
    return [db get:SESSION_DATA];
}
+ (void)delSession {
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db del:SESSION_DATA];
    } finaly:nil];
}
@end