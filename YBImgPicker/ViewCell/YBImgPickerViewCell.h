//
//  YBImgPickerViewCell.h
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YBImgPickerViewCellDelegate;

@interface YBImgPickerViewCell : UICollectionViewCell
@property (nonatomic , strong) UIImage * contentImg;
@property (nonatomic , weak) id <YBImgPickerViewCellDelegate>delegate;
@property (nonatomic , assign) BOOL isChoosen;
@property (nonatomic , assign) BOOL isChoosenImgHidden;
@end

@protocol YBImgPickerViewCellDelegate <NSObject>
@optional
- (void)cellIsChoosen:(YBImgPickerViewCell *)cell;
@end