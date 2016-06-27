//
//  YBPreViewImgViewCell.h
//  WiFi_Test
//
//  Created by 宋奕兴 on 16/5/18.
//  Copyright © 2016年 宋奕兴. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YBPreViewImgViewCellWidth (CGRectGetWidth([UIScreen mainScreen].bounds))
#define YBPreViewImgViewCellHeight (CGRectGetHeight([UIScreen mainScreen].bounds) - 64)

@protocol YBPreViewImgViewCellDelegate;

@interface YBPreViewImgViewCell : UICollectionViewCell
@property (nonatomic , strong) UIImage * contentImg;
@property (nonatomic , weak) id <YBPreViewImgViewCellDelegate>delegate;
@property (nonatomic , assign) BOOL isChoosen;
@property (nonatomic , assign) BOOL isChoosenImgHidden;
@property (nonatomic , assign) BOOL resetScale;
@end
@protocol YBPreViewImgViewCellDelegate <NSObject>
@optional
- (void)preViewImgViewCellIsChoosen:(YBPreViewImgViewCell *)cell;
@end