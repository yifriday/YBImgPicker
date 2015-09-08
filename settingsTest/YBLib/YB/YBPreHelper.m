//
//  YBPreHelper.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//


#import "YBPreHelper.h"
#import "AFHTTPRequestOperationManager.h"
@implementation YBPreHelper
#pragma mark - 颜色相关
//得到HEX域颜色
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
//从图片中获取色彩
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -时间相关

//从时间整型数据的到时间
+ (NSDate *)dateFromLongLong:(long long)msSince1970 {
    return [NSDate dateWithTimeIntervalSince1970:(msSince1970 - 1970) * 60 * 60 * 24 * 365];
}
//从时间格式得到时间字符串格式
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
//从时间字符串格式得到时间格式
+ (NSDate *)stringToDate:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}
//得到符合相应时间格式的当前时间字符串
+ (NSString *)getCurrentTime:(NSString *)timeformat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:timeformat];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//计算年龄
+ (NSString *)countAge:(NSString *)birthday {
    if ([@"" isEqualToString:birthday]) {
        return @"0";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd"];
    NSDate *date = [dateFormatter dateFromString:birthday];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    int year = (int)[comps year];
    
    NSDate *now = [NSDate date];
    NSDateComponents *nowComps = [calendar components:unitFlags fromDate:now];
    int nowYear = (int)[nowComps year];
    return [NSString stringWithFormat:@"%d", (nowYear - year)];
}

#pragma mark - 正则表达式验证相关
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13,14,15,16,17,18,19开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3-9]{1}[0-9]{9}$";

    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//邮箱验证
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark - 网络相关
//得到UUID
+(NSString*)getUuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
#pragma mark -文本相关
//定义数字显示规则
+ (void)showNum:(double)num label:(UILabel *)label {
    if (num < 1000) {
        label.text = [NSString stringWithFormat:@"%d",(int)num];
        
    }else if (num >= 1000 && num < 10000) {
        int favourNumStart = num / 1000;
        double favourNumEnd = ((long)num % 1000) / 1000.0;
        num = favourNumStart + favourNumEnd;
        label.text = [NSString stringWithFormat:@"%.1lfK",num];
    }else {
        int favourNumStart = num / 10000;
        double favourNumEnd = ((long)num % 10000) / 10000.0;
        num = favourNumStart + favourNumEnd;
        label.text = [NSString stringWithFormat:@"%.1lfW",num];
    }
}

// 过滤所有表情

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935)
             {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299)
             {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
             {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
//设置排版
+ (void)setLableTextParagrah: (UILabel *)label lineSpace:(CGFloat)lineSpace paragraphSpacing:(CGFloat)paragraphSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent{
    if (!label.text.length) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:label.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineHeightMultiple:lineSpace];
    [paragraphStyle setParagraphSpacing:paragraphSpacing];
    [paragraphStyle setFirstLineHeadIndent:firstLineHeadIndent];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    
    label.attributedText = attributedString;
}
//判断数据源是否为空
+ (BOOL)modelIsEmpty:(id)model {
    if ([model isKindOfClass:[NSArray class]] || [model isKindOfClass:[NSMutableArray class]] ) {
        NSArray * realModel = (NSArray *)model;
        if (realModel.count) {
            return NO;
        }else {
            return YES;
        }
    }else if ([model isKindOfClass:[NSDictionary class]] ||[model isKindOfClass:[NSMutableDictionary class]]) {
        NSDictionary * realModel = (NSDictionary *)model;
        if (realModel.count) {
            return NO;
        }else {
            return YES;
        }
    }else if ([model isKindOfClass:[NSString class]] ||[model isKindOfClass:[NSMutableString class]]) {
        NSString * realModel = (NSString *)model;
        if (realModel.length) {
            return NO;
        }else {
            return YES;
        }
    }else {
        if (model == nil) {
            return YES;
        }else return NO;
    }
}
@end
