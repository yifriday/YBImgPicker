//
//  YBImageLoader.m
//  BaseApp
//
//  Created by 宋奕兴 on 15/8/11.
//  Copyright (c) 2015年 胡峰. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#define MaxConcurrentDownloads 8
@implementation YBImageLoader
+ (void)loadBtnBackgroungImage:(UIButton *)dirBtn url:(NSString *)url placeholder:(UIImage *)placeholder {
    [[SDWebImageDownloader sharedDownloader]setMaxConcurrentDownloads:MaxConcurrentDownloads];
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         
                                                         if (image) {
                                                             // 如果不是硬盘缓存，则存储到硬盘
                                                             if (cacheType != SDImageCacheTypeDisk) {
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                             }
                                                             // 设置图片显示
                                                             [dirBtn setBackgroundImage:image forState:UIControlStateNormal];
                                                         } else {
                                                             // 缓存不存在，重新从网络获取图片
                                                             NSURL *imageUrl = [NSURL URLWithString:url];
                                                             UIImage *placeholderTemp;
                                                             if (placeholder) {
                                                                 placeholderTemp = placeholder;
                                                             } else {
                                                                 placeholderTemp = [UIImage imageNamed:@"iconImgPlaceholder.png"];
                                                             }
                                                             [dirBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:placeholderTemp options:SDWebImageLowPriority | SDWebImageRefreshCached | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                 // 成功后，保存
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                             }];
                                                         }
                                                     }];
    
}

+ (void)loadBtnImage:(UIButton *)dirBtn url:(NSString *)url placeholder:(UIImage *)placeholder {
    [[SDWebImageDownloader sharedDownloader]setMaxConcurrentDownloads:MaxConcurrentDownloads];
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         
                                                         if (image) {
                                                             // 如果不是硬盘缓存，则存储到硬盘
                                                             if (cacheType != SDImageCacheTypeDisk) {
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                             }
                                                             // 设置图片显示
                                                             [dirBtn setImage:image forState:UIControlStateNormal];
                                                         } else {
                                                             // 缓存不存在，重新从网络获取图片
                                                             NSURL *imageUrl = [NSURL URLWithString:url];
                                                             UIImage *placeholderTemp;
                                                             if (placeholder) {
                                                                 placeholderTemp = placeholder;
                                                             } else {
                                                                 placeholderTemp = [UIImage imageNamed:@"iconImgPlaceholder.png"];
                                                             }
                                                             [dirBtn sd_setImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:placeholderTemp options:SDWebImageLowPriority | SDWebImageRefreshCached | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                 // 成功后，保存
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                             }];
                                                         }
                                                     }];
    
}

+ (void)loadImage:(UIImageView *)dirImage url:(NSString *)url placeholder:(UIImage *)placeholder {
    [[SDWebImageDownloader sharedDownloader]setMaxConcurrentDownloads:MaxConcurrentDownloads];
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (image) {
                                                             // 如果不是硬盘缓存，则存储到硬盘
                                                             if (cacheType != SDImageCacheTypeDisk) {
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                             }
                                                             // 设置图片显示
                                                             [dirImage setImage:image];
                                                         } else {
                                                             // 缓存不存在，重新从网络获取图片
                                                             NSURL *imageUrl = [NSURL URLWithString:url];
                                                             UIImage *placeholderTemp;
                                                             if (placeholder) {
                                                                 placeholderTemp = placeholder;
                                                             } else {
                                                                 placeholderTemp = [UIImage imageNamed:@""];
                                                             }
                                                             [dirImage sd_setImageWithURL:imageUrl
                                                                         placeholderImage:placeholderTemp
                                                                                  options:SDWebImageLowPriority | SDWebImageRefreshCached | SDWebImageRetryFailed
                                                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                                    // 成功后，保存
                                                                                    if (!error) {
                                                                                        [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];

                                                                                    }else {
//                                                                                        [YBException newYBException:@"DownloadImgErrro" reason:@"DownloadImgErrro" userInfo:@{@"error":error.userInfo}];
                                                                                    }
                                                                                }];
                                                         }
                                                     }];
}

+ (void)loadImagewithNewSize:(UIImageView *)dirImage url:(NSString *)url placeholder:(UIImage *)placeholder {
    [[SDWebImageDownloader sharedDownloader]setMaxConcurrentDownloads:MaxConcurrentDownloads];
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:url
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (image) {
                                                             // 如果不是硬盘缓存，则存储到硬盘
                                                             if (cacheType != SDImageCacheTypeDisk) {
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                             }
                                                             // 设置图片显示
                                                             image = [self getCenterImage:image scaledToSize:CGSizeMake(dirImage.frame.size.width, dirImage.frame.size.height)];
                                                             [dirImage setImage:image];
                                                         } else {
                                                             // 缓存不存在，重新从网络获取图片
                                                             NSURL *imageUrl = [NSURL URLWithString:url];
                                                             UIImage *placeholderTemp;
                                                             if (placeholder) {
                                                                 placeholderTemp = placeholder;
                                                             } else {
                                                                 placeholderTemp = [UIImage imageNamed:@""];
                                                             }
                                                             [dirImage sd_setImageWithURL:imageUrl
                                                                         placeholderImage:placeholderTemp
                                                                                  options:SDWebImageLowPriority | SDWebImageRefreshCached | SDWebImageRetryFailed
                                                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                                    // 成功后，保存
                                                                                    if (error) {
//                                                                                        [YBException newYBException:@"DownloadImgErrro" reason:@"DownloadImgErrro" userInfo:@{@"error":error.userInfo}];
                                                                                    }else {
                                                                                    [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                                                                    }
                                                                                }];
                                                         }
                                                     }];
}

+ (void)downloadImageByUrl:(NSString *)url {
    [[SDWebImageDownloader sharedDownloader]setMaxConcurrentDownloads:MaxConcurrentDownloads];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageUrl = [NSURL URLWithString:url];
    [manager downloadImageWithURL:imageUrl
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image && !error && finished) {
                                // 如果不是硬盘缓存，则存储到硬盘
                                if (cacheType != SDImageCacheTypeDisk) {
                                    [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:TRUE];
                                }
                            }else {
//                                [YBException newYBException:@"DownloadImgErrro" reason:@"DownloadImgErrro" userInfo:@{@"error":error.userInfo}];
                            }
                        }];
}

+ (NSData *)zoomOutImage:(UIImage *)image fraction:(int)fraction {
    CGFloat h = image.size.height;
    CGFloat w = image.size.width;
    CGRect rect;
    if (h >= w) {
        rect = CGRectMake(0, h / 2 - w / 2, w, w);
    } else {
        rect = CGRectMake(w / 2 - h / 2, 0, h, h);
    }
    CGImageRef cgImage = CGImageCreateWithImageInRect([image CGImage], rect);
    CGImageRelease(cgImage);
    
    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width / fraction, image.size.height / fraction)];
    NSData *data = UIImagePNGRepresentation(image);
    return [NSMutableData dataWithData:data];
}

+ (NSData *)zoomOutImageData:(NSData *)imageData fraction:(int)fraction {
    UIImage *image = [UIImage imageWithData:imageData];
    
    return [self zoomOutImage:image fraction:fraction];
}

//等比例缩放图片
+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 图片相关
//修正>2M的图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//重新定义图片大小
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    float width = image.size.width < size.width ? image.size.width : size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    
    float x = 0.0f;
    float y = 0.0f;
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
//带有阈值的重构图片大小

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size withTime:(float)time {
    float width = image.size.width * time < size.width ? image.size.width * time : size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    
    float x = 0.0f;
    float y = 0.0f;
    CGRect rect = CGRectMake(x, y, width, height);
    
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//得到图片某一部分
+ (UIImage *)getPartOfImage:(UIImage *)img rect:(CGRect)partRect {
    CGImageRef imageRef = img.CGImage;
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
    UIImage *retImg = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    return retImg;
}

//得到图片中心部分

+ (UIImage *)getCenterImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    
    CGFloat XRY = newSize.height / newSize.width;
    CGFloat fraction;
    float imaWidth;
    float imaHeight;
    
    if (image.size.height >= image.size.width) {
        fraction = image.size.width / newSize.width;
        image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(newSize.width, image.size.height / fraction)];
        imaWidth = (image.size.width > newSize.width) ? newSize.width : image.size.width;
        imaHeight = imaWidth * XRY;
    } else if (image.size.height < image.size.width) {
        fraction = image.size.height / newSize.height;
        image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(image.size.width / fraction, newSize.height)];
        imaHeight = (image.size.height > newSize.height) ? newSize.height : image.size.height;
        imaWidth = imaHeight / XRY;
    }
    
    float imaX = (image.size.width - imaWidth) / 2.0;
    float imaY = (image.size.height - imaHeight) / 2.0;
    CGRect rect = CGRectMake(imaX, imaY, imaWidth, imaHeight);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    image = [UIImage imageWithCGImage:imageRef];
    
    return image;
}

//是否从中心点开始得到图片的一部分
+ (UIImage *)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool {
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if (centerBool)
        rect = CGRectMake((imgwidth - viewwidth) / 2, (imgheight - viewheight) / 2, viewwidth, viewheight);
    else {
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth * viewheight / viewwidth);
            } else {
                float width = viewwidth * imgheight / viewheight;
                float x = (imgwidth - width) / 2;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                } else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth * viewheight / viewwidth);
                }
            }
        } else {
            if (imgwidth <= imgheight) {
                float height = viewheight * imgwidth / viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                } else {
                    rect = CGRectMake(0, 0, viewwidth * imgheight / viewheight, imgheight);
                }
            } else {
                float width = viewwidth * imgheight / viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width) / 2;
                    rect = CGRectMake(x, 0, width, imgheight);
                } else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end