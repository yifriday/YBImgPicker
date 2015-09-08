//
//  UITextView+Word_limit.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/12.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Word_limit)

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSUInteger)maxLength;

-(NSInteger)textViewDidChange:(UITextView *)textView maxLength:(NSUInteger)maxLength;

@end