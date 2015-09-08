//
//  LevelDB.h
//  BaseApp
//
//  Created by 胡峰 on 15/8/10.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelDB : NSObject

+ (LevelDB *) db;

- (void) set:(NSString *) key value:(id) value;
- (id) get:(NSString *) key;
- (void) del:(NSString *) key;

@end
