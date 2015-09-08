//
//  ErrorData.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/18.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorData : NSObject
+ (void)setError:(id)error prefix:(NSString *)name;
+ (id) getError:(NSString *)name;
@end
