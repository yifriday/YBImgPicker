//
//  YBException.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/15.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "YBException.h"
#import "ErrorData.h"
@interface YBException ()<UIApplicationDelegate>
@end
@implementation YBException
+ (void)newYBException:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo{
    id exception;
    exception = [NSException exceptionWithName:[NSString stringWithFormat:@"======来问老师异常错误报告======\n%@",name] reason:reason userInfo:userInfo];
    @throw exception;
}
+ (void)exception:(NSException *)exception{
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"======来问老师异常错误报告======\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    [ErrorData setError:content prefix:name];
}
+ (void) UncaughtExceptionHandler:(NSException *)exception {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"======来问老师异常错误报告======\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailto:songyixing@yunbix.com"];
    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", content];
    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [YBAlertView alertWithTwoBtn:@"来问老师异常错误报告" message:@"发送错误信息处理邮件给我们的攻城狮吗？让我们的APP越来越好" sureBtnTitle:@"我愿意！" sureBtnClick:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
        
    }];
}
+ (void)exception_Try_Catch:(void (^)())myTry  finaly:(void (^)())myFinaly {
    @try {
        if (myTry) {
            myTry();
            
        }
        
    }
    @catch (NSException *exception) {
        [YBException UncaughtExceptionHandler:exception];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [YBException exception:exception];
            
        });
    }
    @finally {
        if (myFinaly) {
            myFinaly();
        }
    }
    
}
@end
