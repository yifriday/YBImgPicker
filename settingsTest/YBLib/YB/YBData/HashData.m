//
//  HashData.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "HashData.h"
#import "LevelDB.h"
#define HASH_DATA @"HASH_DATA"
static  LevelDB * db;
@implementation HashData
+ (void)setHash:(id)hash prefix:(NSString *)prefix{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
        [db set:[NSString stringWithFormat:@"%@-%@",prefix,HASH_DATA] value:hash];
    } finaly:nil];
    
}
+ (id) getHash:(NSString *)prefix{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
    } finaly:nil];
    return [db get:[NSString stringWithFormat:@"%@-%@",prefix,HASH_DATA]];
}

@end
