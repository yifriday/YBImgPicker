//
//  YBAlertView.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#ifndef YB_YBAlertView_h
#define YB_YBAlertView_h

@interface YBAlertView : NSObject

+ (void) alertWithTwoBtn:(NSString *)title message:(NSString *) message sureBtnTitle:(NSString *)sureBtnTilte sureBtnClick: (void (^)()) sureBtnClick;
+ (void) alertWithOneBtn:(NSString *)title message:(NSString *) message sureBtnTitle:(NSString *)sureBtnTilte sureBtnClick: (void (^)()) sureBtnClick;
@end

#endif
