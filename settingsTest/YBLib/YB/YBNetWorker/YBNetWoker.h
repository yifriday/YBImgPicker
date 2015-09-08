//
//  NetWoker.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#ifndef YB_YBNetWoker_h
#define YB_YBNetWoker_h
@class AFHTTPRequestOperation;

@interface YBNetWoker : NSObject

+ (AFHTTPRequestOperation *) request:(NSString *) path parameters:(NSMutableDictionary *) parameters isMsgPack:(BOOL)isMsgPack isContainSession:(BOOL)isContainSession complete:(void (^)(id responseObject)) completeCallback error:(BOOL (^)()) errorCallback;

+ (void) upload:(NSString *) path parameters:(NSDictionary *) parameters fileContent:(NSData *)fileData fileName:(NSString *)filename isContainSession:(BOOL)isContainSession complete:(void (^)(id responseObject)) completeCallback error:(BOOL (^)()) errorCallback;

@end
#endif
