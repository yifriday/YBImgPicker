//
//  YBPreImgViewController.h
//  WiFi_Test
//
//  Created by 宋奕兴 on 16/5/18.
//  Copyright © 2016年 宋奕兴. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YBPreImgViewControllerDelegate <NSObject>

@optional
- (void)YBPreViewImgViewDidFinishWithImages:(NSDictionary *)choosenImgDic;
- (void)YBPreViewImgViewBackToPreVc:(NSIndexPath *)index;
@end

#define photoCounts 3

@interface YBPreImgViewController : UIViewController
- (instancetype)initWithColletionData:(NSArray *)cData isChoosenDic:(NSDictionary *)cDic curIndex:(NSIndexPath *)cIndex delegate:(id<YBPreImgViewControllerDelegate>)delegate;
- (void)showInViewContrller:(UIViewController *)vc;

@end
