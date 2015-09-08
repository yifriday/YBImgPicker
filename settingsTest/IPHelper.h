//
//  IPHelper.h
//  settingsTest
//
//  Created by 宋奕兴 on 15/8/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPHelper : NSObject
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;
@end
