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
- (void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray;

@end

@interface YBImgPickerViewController : UIViewController
- (void)showInViewContrller:(UIViewController *)vc choosenNum:(NSInteger)choosenNum delegate:(id<YBImgPickerViewControllerDelegate>)vcdelegate;
@end
