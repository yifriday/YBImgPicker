//
//  YBPreViewImgViewCell.m
//  WiFi_Test
//
//  Created by 宋奕兴 on 16/5/18.
//  Copyright © 2016年 宋奕兴. All rights reserved.
//

#import "YBPreViewImgViewCell.h"
@interface YBPreViewImgViewCell ()<UIScrollViewDelegate>

@property (nonatomic , strong) IBOutlet UIImageView * mainImageView;
@property (nonatomic , strong) IBOutlet UIButton * isChoosenBtn;
@property (nonatomic , strong) IBOutlet UIScrollView * mainScrollView;
@end

const CGFloat maxScale = 3.0; // 最大的缩放比例
const CGFloat minScale = 1.0; // 最大的缩放比例
@implementation YBPreViewImgViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
    [self.isChoosenBtn addTarget:self action:@selector(isChoosenImageViewTap) forControlEvents:UIControlEventTouchUpInside];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.maximumZoomScale = maxScale; // scrollView最大缩放比例
    _mainScrollView.minimumZoomScale = minScale;// scrollView最小缩放比例
    _mainScrollView.backgroundColor = [UIColor clearColor];
    
    _mainScrollView.delegate = self;
    
    // 双击手势
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapClick:)];
    doubleTap.numberOfTapsRequired = 2;
    [_mainScrollView addGestureRecognizer:doubleTap];
}
- (void)isChoosenImageViewTap {
    if ([self.delegate respondsToSelector:@selector(preViewImgViewCellIsChoosen:)]) {
        [self.delegate preViewImgViewCellIsChoosen:self];
    }
}
- (void)setContentImg:(UIImage *)contentImg {
    if (contentImg) {
        _contentImg = contentImg;
        self.mainImageView.image = _contentImg;
    }
}
- (void)setIsChoosen:(BOOL)isChoosen {
    _isChoosen = isChoosen;
    [UIView animateWithDuration:0.2 animations:^{
        if (isChoosen) {
            [self.isChoosenBtn setImage:[UIImage imageNamed:@"YBimgPickerView.bundle/isChoosenY"] forState:UIControlStateNormal];
            
        }else {
            [self.isChoosenBtn setImage:[UIImage imageNamed:@"YBimgPickerView.bundle/isChoosenN"] forState:UIControlStateNormal];
        }
        self.isChoosenBtn.transform = CGAffineTransformMakeScale (1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.isChoosenBtn.transform = CGAffineTransformMakeScale (1.0,1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        //当捏或移动时，需要对center重新定义以达到正确显示位置
        CGFloat centerX = scrollView.center.x;
        CGFloat centerY = scrollView.center.y;
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height / 2 : centerY;
        
        self.mainImageView.center = CGPointMake(centerX, centerY);
    }
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mainImageView;
}

- (void)doubleTapClick:(UITapGestureRecognizer *)tap {
    CGFloat touchX = [tap locationInView:tap.view].x;
    CGFloat touchY = [tap locationInView:tap.view].y;
    
    if (_mainScrollView.zoomScale > 1.0) {
        [self.mainScrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat xsize = [UIScreen mainScreen].bounds.size.width/maxScale;
        CGFloat ysize = [UIScreen mainScreen].bounds.size.width/maxScale;
        [_mainScrollView zoomToRect:CGRectMake(touchX-xsize/2,touchY-ysize/2, xsize, ysize) animated:YES];
    }
}
- (void)setResetScale:(BOOL)resetScale {
    _resetScale = resetScale;
    if (resetScale) {
        [self.mainScrollView setZoomScale:1.0 animated:NO];
    }
}
@end
