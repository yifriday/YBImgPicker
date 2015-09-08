//
//  YBException.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/15.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YBException : NSException
+ (void)newYBException:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;
+ (void)exception_Try_Catch:(void (^)())myTry  finaly:(void (^)())myFinaly;
+ (void)exception:(NSException *)exception;
@end
