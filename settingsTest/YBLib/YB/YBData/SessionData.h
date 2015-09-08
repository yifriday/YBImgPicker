//
//  SessionData.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#ifndef YB_SessionData_h
#define YB_SessionData_h
@interface SessionData : NSObject

+ (void)setSession:(id)session;
+ (id) getSession;
+ (void)delSession;

@end
#endif