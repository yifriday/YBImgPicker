//
//  YBPhotoBroswer.m
//  ImageHelper
//
//  Created by 罗德昭 on 15/8/10.
//
//

#import "YBPhotoBroswer.h"
#import "SDWebImageManager.h"
#import "UIViewController+HUD.h"


#define ZOOM_SCALE 2.5

@interface YBPhotoBroswer ()<UIScrollViewDelegate>
{
    UIScrollView *bigScroll;
    UIScrollView *scroll1;
    UIScrollView *scroll2;
    UIScrollView *scroll3;
    UIScrollView *currentScroll;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *currentImageView;
    
    UILabel * numLabel;
    UIButton *saveBtn;
    
    NSInteger currentTag;// 传过来的，当前应当显示数组里的第几张图
    CGFloat currentScale;// 当前的缩放值
    NSInteger offsetX; //偏移量／屏宽
    CGPoint preOffset;
    BOOL toRight;
    
    NSMutableArray *imageArrary;
    NSArray * holderImgArray;
    NSArray * urlArray;
    
}
@end

@implementation YBPhotoBroswer

- (instancetype)initWithDataArray:(NSArray *)picIDataArray withImageTag:(NSInteger)tag {
    
    imageArrary = [[NSMutableArray alloc]init];
    for (NSData * imgData in picIDataArray) {
        UIImage * myImg = [UIImage imageWithData:imgData];
        [imageArrary addObject:myImg];
        currentTag = tag;
    }
    [self setScrolls];
    return self;
}

- (instancetype)initWithImageArray:(NSArray *)picImgArray withImageTag:(NSInteger)tag {
    imageArrary = [[NSMutableArray alloc]initWithArray:picImgArray];
    currentTag = tag;
    [self setScrolls];
    return self;
}

- (instancetype)initWithImgUrlArray:(NSArray *)picUrlArray withImageTag:(NSInteger)tag parentImgArray:(NSArray *)parentImgs{//parentImgse为小图
    urlArray = [NSArray arrayWithArray:picUrlArray];
    holderImgArray = [NSArray arrayWithArray:parentImgs];
    imageArrary = [[NSMutableArray alloc]init];
    currentTag = tag;// bigscroll应该显示第几张图
    [self setScrolls];
    if (urlArray.count > currentTag - 1) {//保证数据不越界
        [self loadImg:[urlArray objectAtIndex:currentTag - 1]];//直接加载要显示的第几个图片
        
    }
    return self;
}

- (void)loadImg: (NSString *)imageURL {
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:imageURL
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (image) {
                                                             // 如果不是硬盘缓存，则存储到硬盘
                                                             if (cacheType != SDImageCacheTypeDisk) {
                                                                 [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:TRUE];
                                                             }
                                                             [imageArrary replaceObjectAtIndex:offsetX withObject:image];
                                                             int whichScroll = (offsetX) % 3;
                                                             switch (whichScroll) {
                                                                 case 0:
                                                                     [imageView1 removeFromSuperview];//这里要remove，会导致imageview指向空
                                                                     imageView1 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX]];
                                                                     [self zoomImg:imageView1];
                                                                     [scroll1 addSubview:imageView1];
                                                                     currentImageView = imageView1;
                                                                     break;
                                                                 case 1:
                                                                     [imageView2 removeFromSuperview];//这里要remove，会导致imageview指向空
                                                                     imageView2 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX  ]];
                                                                     [self zoomImg:imageView2];
                                                                     [scroll2 addSubview:imageView2];
                                                                     currentImageView = imageView2;
                                                                     
                                                                     break;
                                                                 case 2:
                                                                     
                                                                     [imageView3 removeFromSuperview];//这里要remove，会导致imageview指向空
                                                                     imageView3 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX  ]];
                                                                     [self zoomImg:imageView3];
                                                                     [scroll3 addSubview:imageView3];
                                                                     currentImageView = imageView3;
                                                                     break;
                                                                 default:
                                                                     break;
                                                             }
                                                             
                                                         } else {
                                                             // 缓存不存在，重新从网络获取图片
                                                             [self showHudInView:self.view hint:nil];
                                                             
                                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                 NSURL *imageUrl = [NSURL URLWithString:imageURL];
                                                                 
                                                                 [[SDWebImageDownloader sharedDownloader] setMaxConcurrentDownloads:1];
                                                                 
                                                                 [[SDWebImageDownloader sharedDownloader] setDownloadTimeout:10.0];
                                                                 
                                                                 
                                                                 [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:imageUrl options:SDWebImageLowPriority | SDWebImageRefreshCached | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                     
                                                                 } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                     if (finished && error == nil) {
                                                                         [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:TRUE];
                                                                         [imageArrary replaceObjectAtIndex:offsetX withObject:image];
                                                                         int whichScroll = (offsetX) % 3;
                                                                         switch (whichScroll) {
                                                                             case 0:
                                                                                 [scroll1 setZoomScale:1.0 animated:YES];                                                       [imageView1 removeFromSuperview];//这里要remove，会导致imageview指向空
                                                                                 imageView1 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX  ]];
                                                                                 [self zoomImg:imageView1];
                                                                                 [scroll1 addSubview:imageView1];
                                                                                 currentImageView = imageView1;
                                                                                 break;
                                                                             case 1:
                                                                                 [scroll2 setZoomScale:1.0 animated:YES];
                                                                                 [imageView2 removeFromSuperview];//这里要remove，会导致imageview指向空
                                                                                 imageView2 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX  ]];
                                                                                 [self zoomImg:imageView2];
                                                                                 [scroll2 addSubview:imageView2];
                                                                                 currentImageView = imageView2;
                                                                                 break;
                                                                             case 2:
                                                                                 [scroll3 setZoomScale:1.0 animated:YES];
                                                                                 [imageView3 removeFromSuperview];//这里要remove，会导致imageview指向空
                                                                                 imageView3 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX  ]];
                                                                                 [self zoomImg:imageView3];
                                                                                 [scroll3 addSubview:imageView3];
                                                                                 currentImageView = imageView3;
                                                                                 break;
                                                                             default:
                                                                                 break;
                                                                         }
                                                                     }
                                                                     [self hideHud];
                                                                 }];
                                                             });
                                                             
                                                         }
                                                     }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    UITapGestureRecognizer * popG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popMyself)];
    [self.view addGestureRecognizer:popG];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagTwice:)];
    tapTwice.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapTwice];
    [popG requireGestureRecognizerToFail:tapTwice];
    self.view.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)pushMyself {//重写push动画
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.delegate pushViewController];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden=YES;
}

- (void)popMyself {//重写pop动画
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
    self.navigationController.navigationBarHidden = self.navHidden;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = _navHidden;
}
- (CGFloat)maxScale {//懒加载maxScale
    if (_maxScale == 0.0) {
        _maxScale = 3.0;
    }
    return _maxScale;
}

- (CGFloat)minScale{
    if (_minScale == 0.0) {
        _minScale = 1.0;
    }
    return  _minScale;
}

- (void)setScrolls
{
    if (imageArrary.count == 0) {// 如果imagearray里面没图，说明是url，则用小图加进来
        [imageArrary addObjectsFromArray:holderImgArray];
    }
    CGRect screenframe = [UIScreen mainScreen].bounds;
    bigScroll = [[UIScrollView alloc]init];
    bigScroll.frame = screenframe;
    bigScroll.bounces = NO;
    bigScroll.contentInset = UIEdgeInsetsZero;
    bigScroll.contentSize = CGSizeMake(screenframe.size.width * imageArrary.count, screenframe.size.height);
    bigScroll.delegate=self;
    bigScroll.showsHorizontalScrollIndicator = NO;
    bigScroll.showsVerticalScrollIndicator = NO;
    bigScroll.pagingEnabled=YES;
    bigScroll.backgroundColor = [UIColor clearColor];
    
    
    CGRect scrollFrame=screenframe;
    scroll1 = [[UIScrollView alloc]initWithFrame:screenframe];
    imageView1 = [[UIImageView alloc]initWithImage:imageArrary[0]];
    [self zoomImg:imageView1];
    scroll1.contentSize = imageView1.frame.size;
    scroll1.contentInset = UIEdgeInsetsZero;
    scroll1.bounces = NO;
    scroll1.delegate = self;
    scroll1.maximumZoomScale = self.maxScale;
    scroll1.minimumZoomScale = self.minScale;
    scroll1.backgroundColor = [UIColor clearColor];
    [scroll1 addSubview:imageView1];
    [bigScroll addSubview:scroll1];
    
    
    
    scroll2 = [[UIScrollView alloc]init];
    scrollFrame.origin.x =  screenframe.size.width;
    scroll2.frame=scrollFrame;
    imageView2 = [[UIImageView alloc]initWithImage:imageArrary[1]];
    [self zoomImg:imageView2];
    scroll2.contentSize = imageView2.frame.size;
    scroll2.bounces = NO;
    scroll2.delegate = self;
    scroll2.contentInset = UIEdgeInsetsZero;
    scroll2.maximumZoomScale = self.maxScale;
    scroll2.minimumZoomScale = self.minScale;
    scroll2.backgroundColor = [UIColor clearColor];
    [scroll2 addSubview:imageView2];
    [bigScroll addSubview:scroll2];
    
    
    
    scroll3 = [[UIScrollView alloc]init];
    scrollFrame.origin.x =  screenframe.size.width *2;
    scroll3.frame=scrollFrame;
    imageView3 = [[UIImageView alloc]initWithImage:imageArrary[2]];
    [self zoomImg:imageView3];
    scroll3.contentSize = imageView3.frame.size;
    scroll3.bounces = NO;
    scroll3.delegate = self;
    scroll3.contentInset = UIEdgeInsetsZero;
    scroll3.maximumZoomScale = self.maxScale;
    scroll3.minimumZoomScale = self.minScale;
    scroll3.backgroundColor = [UIColor clearColor];
    [scroll3 addSubview:imageView3];
    [bigScroll addSubview:scroll3];
    bigScroll.canCancelContentTouches = NO;
    
    
    
    
    
    
    bigScroll.contentOffset = CGPointMake(bigScroll.contentSize.width/imageArrary.count * (currentTag-1), 0);
    int offset = bigScroll.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    int whichScroll = offset % 3;
    switch (whichScroll) {
        case 0:
            currentImageView = imageView1;
            currentScroll = scroll1;
            break;
        case 1:
            currentImageView =  imageView2;
            currentScroll = scroll2;
            break;
        case 2:
            currentImageView =  imageView3;
            currentScroll = scroll3;
            break;
        default:
            break;
    }
    
    
    
    
    [self.view addSubview:bigScroll];
    numLabel = [[UILabel alloc]init];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)currentTag,(unsigned long)imageArrary.count];
    [numLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [numLabel sizeToFit];
    numLabel.frame = CGRectMake(numLabel.frame.origin.x, numLabel.frame.origin.y, numLabel.frame.size.width + 20, numLabel.frame.size.height + 4);
    numLabel.center = CGPointMake(self.view.center.x, 30);
    numLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    numLabel.layer.masksToBounds = YES;
    numLabel.layer.cornerRadius = CGRectGetHeight(numLabel.frame) / 2;
    [self.view addSubview:numLabel];
    saveBtn=[[UIButton alloc]init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    saveBtn.titleLabel.textColor = [UIColor whiteColor];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [saveBtn sizeToFit];
    saveBtn.frame=CGRectMake(10, self.view.frame.size.height - saveBtn.frame.size.height - 10, saveBtn.frame.size.width + 20,saveBtn.frame.size.height);
    saveBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    saveBtn.layer.borderWidth = 0.5;
    saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5;
    [saveBtn addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)saveImg//保存图片
{
    int offset = bigScroll.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    offset = MAX(offset, 0);
    UIImage * image = imageArrary[offset];
    
    if (image){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *message;
    if (!error) {
        message = @"成功保存到相册";
        [self showHint:@"保存相册成功"];
    }else
    {
        message = [error description];
        [self showHint:message];
    }
    NSLog(@"message is %@",message);
}


- (void)zoomImg:(UIImageView *)img {//缩放imageView的大小
    CGRect mainF = [UIScreen mainScreen].bounds;
    CGFloat mainH = mainF.size.height;
    CGFloat mainW = mainF.size.width;
    CGFloat scale = img.frame.size.width / img.frame.size.height;
    if (img.frame.size.width >= img.frame.size.height) {
        img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y, mainW, mainW / scale);
    }else {
        img.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y, mainH * scale, mainH);
        
    }
    img.center = CGPointMake(mainW / 2, mainH / 2);
}

- (void)tagTwice:(UITapGestureRecognizer *)tap
{
    float x = [tap locationInView:tap.view].x;
    float y = [tap locationInView:tap.view].y;
    
    if (currentScale > 1.0) {
        currentScale = 1.0;
        [currentScroll  setZoomScale:1.0 animated:YES];
        
    }else
    {
        currentScale = ZOOM_SCALE;
        CGFloat xsize = [UIScreen mainScreen].bounds.size.width/ZOOM_SCALE;
        CGFloat ysize = [UIScreen mainScreen].bounds.size.width/ZOOM_SCALE;
        [currentScroll zoomToRect:CGRectMake(x-xsize/2,y-ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (![scrollView isEqual:bigScroll]) {
        //        [scroll2 setZoomScale:scale animated:YES];
        NSLog(@"%f--",scale);
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:bigScroll]) {
        return currentImageView;
    }else
    {
        return nil;
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:bigScroll])
    {
        CGFloat offsetXX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
        CGFloat offsetYY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
        currentImageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetXX,scrollView.contentSize.height/2 + offsetYY);
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:bigScroll]) {
        
        offsetX = bigScroll.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
        
        numLabel.text = [NSString stringWithFormat:@"%ld/%lu",
                         offsetX+1,(unsigned long)imageArrary.count];
        
        if (preOffset.x > bigScroll.contentOffset.x) {
            toRight = NO;
        }else
        {
            toRight = YES;
        }
        preOffset = bigScroll.contentOffset;
        int whichScroll = offsetX % 3;
        switch (whichScroll) {
            case 0:
                currentImageView = imageView1;
                currentScroll = scroll1;
                break;
            case 1:
                currentImageView =  imageView2;
                currentScroll = scroll2;
                break;
            case 2:
                currentImageView =  imageView3;
                currentScroll = scroll3;
                break;
            default:
                break;
        }
        
        if (bigScroll.contentOffset.x == self.view.bounds.size.width) {
            
            [scroll3 setZoomScale:1.0 animated:YES];
            
        }
        if (offsetX < urlArray.count) {
            [self loadImg:[urlArray objectAtIndex:offsetX]];
        }
        
        [self moveScrollWithDirect:toRight];
        
        
    }
    
}

- (void)moveScrollWithDirect:(BOOL)forward
{
    
    
    if (forward) {//向右
        if (imageArrary.count > 3 && offsetX >=2 && offsetX <= imageArrary.count-2) {
            int whichScroll = (offsetX-2) % 3;
            switch (whichScroll) {
                case 0:
                    [scroll2 setZoomScale:1.0 animated:YES];
                    [scroll3 setZoomScale:1.0 animated:YES];
                    [imageView1 removeFromSuperview];//这里要remove，会导致imageview指向空
                    scroll1.frame = CGRectMake(currentScroll.frame.origin.x + currentScroll.frame.size.width , currentScroll.frame.origin.y, currentScroll.frame.size.width, currentScroll.frame.size.height);
                    imageView1 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX +1 ]];
                    [self zoomImg:imageView1];
                    [scroll1 addSubview:imageView1];
                    break;
                case 1:
                    
                    [scroll1 setZoomScale:1.0 animated:YES];
                    [scroll3 setZoomScale:1.0 animated:YES];
                    
                    [imageView2 removeFromSuperview];//这里要remove，会导致imageview指向空
                    scroll2.frame = CGRectMake(currentScroll.frame.origin.x + currentScroll.frame.size.width , currentScroll.frame.origin.y, currentScroll.frame.size.width, currentScroll.frame.size.height);
                    imageView2 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX +1 ]];
                    [self zoomImg:imageView2];
                    [scroll2 addSubview:imageView2];
                    break;
                case 2:
                    [imageView3 removeFromSuperview];//这里要remove，会导致imageview指向空
                    scroll3.frame = CGRectMake(currentScroll.frame.origin.x + currentScroll.frame.size.width , currentScroll.frame.origin.y, currentScroll.frame.size.width, currentScroll.frame.size.height);
                    imageView3 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX +1]];
                    [self zoomImg:imageView3];
                    [scroll3 addSubview:imageView3];
                    [scroll1 setZoomScale:1.0 animated:YES];
                    [scroll2 setZoomScale:1.0 animated:YES];
                    break;
                default:
                    break;
            }
        }
        if(imageArrary.count > 3 && offsetX == 1 && offsetX <= imageArrary.count-2){
            [scroll1 setZoomScale:1.0 animated:YES];
            [scroll2 setZoomScale:1.0 animated:YES];
        }
    }else {
        if (imageArrary.count > 3 && offsetX >=1 && offsetX <= imageArrary.count-1) {
            int whichScroll = (offsetX +2) % 3;
            switch (whichScroll) {
                case 0:
                    [scroll2 setZoomScale:1.0 animated:YES];
                    [scroll3 setZoomScale:1.0 animated:YES];
                    [imageView1 removeFromSuperview];//这里要remove，会导致imageview指向空
                    
                    scroll1.frame = CGRectMake(currentScroll.frame.origin.x - currentScroll.frame.size.width , currentScroll.frame.origin.y, currentScroll.frame.size.width, currentScroll.frame.size.height);
                    
                    imageView1 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX -1]];
                    [self zoomImg:imageView1];
                    [scroll1 addSubview:imageView1];
                    break;
                case 1:
                    [imageView2 removeFromSuperview];//这里要remove，会导致imageview指向空
                    
                    scroll2.frame = CGRectMake(currentScroll.frame.origin.x - currentScroll.frame.size.width , currentScroll.frame.origin.y, currentScroll.frame.size.width, currentScroll.frame.size.height);
                    [scroll1 setZoomScale:1.0 animated:YES];
                    [scroll3 setZoomScale:1.0 animated:YES];
                    
                    imageView2 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX -1]];
                    [self zoomImg:imageView2];
                    [scroll2 addSubview:imageView2];
                    break;
                case 2:
                    [imageView3 removeFromSuperview];//这里要remove，会导致imageview指向空
                    scroll3.frame = CGRectMake(currentScroll.frame.origin.x - currentScroll.frame.size.width , currentScroll.frame.origin.y, currentScroll.frame.size.width, currentScroll.frame.size.height);
                    [scroll1 setZoomScale:1.0 animated:YES];
                    [scroll2 setZoomScale:1.0 animated:YES];
                    
                    
                    imageView3 = [[UIImageView alloc]initWithImage:[imageArrary objectAtIndex:offsetX -1]];
                    [self zoomImg:imageView3];
                    [scroll3 addSubview:imageView3];
                    break;
                default:
                    break;
            }
        }
        if(imageArrary.count > 3 && offsetX == 0 && offsetX <= imageArrary.count-1){
            [scroll1 setZoomScale:1.0 animated:YES];
        }
    }
}
@end
