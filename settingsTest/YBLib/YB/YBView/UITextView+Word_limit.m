//
//  UITextView+Word_limit.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/12.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#import "UITextView+Word_limit.h"

@implementation UITextView (Word_limit)
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSUInteger)maxLength{
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    comcatstr = [comcatstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    comcatstr = [comcatstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];//屏蔽空格和换行符
    NSInteger caninputlen = maxLength - comcatstr.length;
    
    if (caninputlen >= 0)//输入的字符没有达到上限
    {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
        }
        return YES;
    }
    else//达到上限，截取
    {
        NSInteger len = text.length + caninputlen;//当前输入的长度加上与之前字符串上限的差
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
        }
        return NO;
    }

}
//防止由于联想输入的缘故，会有很多字符一起输入
-(NSInteger)textViewDidChange:(UITextView *)textView maxLength:(NSUInteger)maxLength{

    NSString  *nsTextContent = textView.text;
    nsTextContent = [nsTextContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    nsTextContent = [nsTextContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //屏蔽空格和换行符
    NSInteger existTextNum = nsTextContent.length;
    
    
    if (existTextNum > maxLength)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:maxLength];
        
        [textView setText:s];
    }
    
    //显示正确数据
    NSInteger curCount = MAX(0, existTextNum);
    curCount = MIN(curCount, maxLength);
    return curCount;
}

@end
