//
//  MyAlertView.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/8/24.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView
- (void)dealloc
{
//    [label removeFromSuperview];
//
//    label = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor blackColor];
        
        label = [[UILabel alloc] initWithFrame:self.frame];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}
- (void)showStatusMessage:(NSString *)message  {
    self.hidden = NO;
    self.alpha = 1.0f;
    label.text = message;
    CGSize totalSize = self.frame.size;
    self.frame = (CGRect){ self.frame.origin, totalSize.width, 0 };
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = (CGRect){ self.frame.origin, totalSize };
    } completion:^(BOOL finished){
        label.text = message;
        [self makeKeyAndVisible];
    }];
}
- (void)hide  {
    CGSize totalSize = self.frame.size;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = (CGRect){ self.frame.origin, totalSize.width, 0 };
        } completion:^(BOOL finished){
            label.text = @"";
            self.hidden = YES;
            [self resignKeyWindow];
        }];
    });
}
@end
