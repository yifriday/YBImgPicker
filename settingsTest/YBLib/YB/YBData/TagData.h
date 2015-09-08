//
//  TagData.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//


#ifndef YB_TagData_h
#define YB_TagData_h
@interface TagData : NSObject

+ (void)setTags:(id)tags;
+ (id) getTags;
+ (void)delTags;

@end
#endif