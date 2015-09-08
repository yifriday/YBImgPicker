//
//  YBPreHelper.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface YBPreHelper : NSObject
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (NSDate *)dateFromLongLong:(long long)msSince1970;

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

+ (NSDate *)stringToDate:(NSString *)dateString format:(NSString *)format;

+ (NSString *)countAge:(NSString *)birthday;

+ (void)showNum:(double)num label:(UILabel *)label;

+ (NSString *)getCurrentTime:(NSString *)timeformat;

+ (BOOL) validateMobile:(NSString *)mobile;

+ (BOOL) validateEmail:(NSString *)email;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString*)getUuid;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (void)setLableTextParagrah: (UILabel *)label lineSpace:(CGFloat)lineSpace paragraphSpacing:(CGFloat)paragraphSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent;

+ (BOOL)modelIsEmpty:(id)model;

@end
