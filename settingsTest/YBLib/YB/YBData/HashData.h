//
//  HashData.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#ifndef YB_HashData_h
#define YB_HashData_h
@interface HashData : NSObject
+ (void)setHash:(id)hash prefix:(NSString *)prefix;
+ (id) getHash:(NSString *)prefix;
@end
#endif