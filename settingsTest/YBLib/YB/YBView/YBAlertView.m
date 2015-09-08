//
//  YBAlertView.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "YBAlertView.h"
static YBAlertView * delegate;
@interface YBAlertView ()<UIAlertViewDelegate> {
}
@property (retain, strong) void (^sureBtnClick)();
@end

@implementation YBAlertView
+ (void) alertWithTitle:(NSString *)title message:(NSString *) message sureBtnTitle:(NSString *)sureBtnTilte sureBtnClick: (void (^)()) sureBtnClick {
    if(delegate == nil){
        delegate = [[YBAlertView alloc] init];
    }
    delegate.sureBtnClick = sureBtnClick;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:sureBtnTilte, nil];
    alert.tag = 200;
    alert.delegate = delegate;
    [alert show];
}
+ (void) alertWithOneBtn:(NSString *)title message:(NSString *) message sureBtnTitle:(NSString *)sureBtnTilte sureBtnClick: (void (^)()) sureBtnClick {
    if(delegate == nil){
        delegate = [[YBAlertView alloc] init];
    }
    delegate.sureBtnClick = sureBtnClick;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:sureBtnTilte otherButtonTitles:nil];
    alert.tag = 100;
    alert.delegate = delegate;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(self.sureBtnClick && buttonIndex == 1 && alertView.tag == 200){
        self.sureBtnClick();
        return;
    }
    if(self.sureBtnClick && buttonIndex == 0 && alertView.tag == 100){
        self.sureBtnClick();
        return;
    }
    
}

@end
