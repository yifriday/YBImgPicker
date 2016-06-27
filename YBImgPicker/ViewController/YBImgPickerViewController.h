//
//  YBImgPickerViewController.h
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YBImgPickerViewControllerDelegate <NSObject>

@optional
- (void)YBImagePickerDidFinishWithImages:(NSDictionary *)choosenImgDic;
@end

@interface YBImgPickerViewController : UIViewController
- (instancetype)initWithChoosenImgDic:(NSDictionary *)choosenImgDic delegate:(id<YBImgPickerViewControllerDelegate>)vcdelegate;

- (void)showInViewContrller:(UIViewController *)vc;

@end
