//
//  YBPhotoBroswer.h
//  ImageHelper
//
//  Created by 罗德昭 on 15/8/10.
//
//

#import <UIKit/UIKit.h>

@protocol YBPhotoBroswerDelegate

@required

- (void)pushViewController;

@end

@interface YBPhotoBroswer : UIViewController

@property (nonatomic,assign) BOOL navHidden;//默认为NO

@property (nonatomic,strong) id <YBPhotoBroswerDelegate>delegate;

@property (nonatomic,assign) CGFloat maxScale;//默认为3

@property (nonatomic,assign) CGFloat minScale;//默认为1

- (void)pushMyself;

- (instancetype)initWithDataArray:(NSArray *)picIDataArray withImageTag:(NSInteger)tag;

- (instancetype)initWithImageArray:(NSArray *)picImgArray withImageTag:(NSInteger)tag;

- (instancetype)initWithImgUrlArray:(NSArray *)picUrlArray withImageTag:(NSInteger)tag parentImgArray:(NSArray *)parentImgs;

@end

