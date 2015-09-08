//
//  ErrorData.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/18.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "ErrorData.h"
#import "LevelDB.h"
#define ERROR_DATA @"ERROR_DATA"
static  LevelDB * db;
@implementation ErrorData
+ (void)setError:(id)error prefix:(NSString *)name{
    [YBException exception_Try_Catch:^{
         db = [LevelDB db];
        [db set:[NSString stringWithFormat:@"%@-%@",ERROR_DATA,name] value:error];
    } finaly:nil];
    
}
+ (id) getError:(NSString *)name{
    [YBException exception_Try_Catch:^{
        db = [LevelDB db];
    } finaly:nil];
    return [db get:[NSString stringWithFormat:@"%@-%@",ERROR_DATA,name]];
}

@end