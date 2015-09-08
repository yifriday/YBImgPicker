//
//  YBImageLoader.h
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//

#ifndef YB_ImageLoader_h
#define YB_ImageLoader_h

@interface YBImageLoader : NSObject

+ (void)loadImage:(UIImageView *)dirImage url:(NSString *)url placeholder:(UIImage *)placeholder;

+ (void)loadImagewithNewSize:(UIImageView *)dirImage url:(NSString *)url placeholder:(UIImage *)placeholder;

+ (void)loadBtnBackgroungImage:(UIButton *)dirBtn url:(NSString *)url placeholder:(UIImage *)placeholder;

+ (void)loadBtnImage:(UIButton *)dirBtn url:(NSString *)url placeholder:(UIImage *)placeholder;

+ (void)downloadImageByUrl:(NSString *)url;

+ (NSData *)zoomOutImage:(UIImage *)image fraction:(int)fraction;

+ (NSData *)zoomOutImageData:(NSData *)imageData fraction:(int)fraction;

//等比例缩放图片
+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;

#pragma mark - 图片相关
//修正>2M的图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//重新定义图片大小
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size ;
//带有阈值的重构图片大小

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size withTime:(float)time ;

//得到图片某一部分
+ (UIImage *)getPartOfImage:(UIImage *)img rect:(CGRect)partRect;

//得到图片中心部分

+ (UIImage *)getCenterImage:(UIImage *)image scaledToSize:(CGSize)newSize;

//是否从中心点开始得到图片的一部分
+ (UIImage *)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;


@end

#endif
