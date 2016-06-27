//
//  YBPreImgViewController.m
//  WiFi_Test
//
//  Created by 宋奕兴 on 16/5/18.
//  Copyright © 2016年 宋奕兴. All rights reserved.
//

#import "YBPreImgViewController.h"

#import "YBPreViewImgViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#define rightItemTitle [NSString stringWithFormat:@"完成 %ld/%ld",(long)isChoosenDic.count,(long)photoCounts]

@interface YBPreImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YBPreViewImgViewCellDelegate>
{
    NSMutableArray * colletionData;
    NSMutableDictionary * isChoosenDic;
    NSIndexPath * curIndex;
    NSIndexPath * firstIndex;
    
}
@property (nonatomic , strong) IBOutlet UICollectionView * myCollectionView;
@property (nonatomic , weak) id <YBPreImgViewControllerDelegate> delegate;
@end

@implementation YBPreImgViewController
@synthesize myCollectionView;

static NSString * const YBPreViewImgViewCellReuseIdentifier = @"YBPreViewImgViewCell";
- (instancetype)initWithColletionData:(NSArray *)cData isChoosenDic:(NSDictionary *)cDic curIndex:(NSIndexPath *)cIndex delegate:(id<YBPreImgViewControllerDelegate>)delegate {
    self = [self initWithNibName:@"YBPreImgViewController" bundle:nil];
    if (self) {
        colletionData = cData.mutableCopy;
        isChoosenDic = cDic.mutableCopy;
        firstIndex = cIndex.copy;
        self.delegate = delegate;
    }
    return self;
}
- (void)showInViewContrller:(UIViewController *)vc {
    [vc.navigationController pushViewController:self animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNav];
}
- (void)setNav {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica Neue" size:20], NSFontAttributeName, nil]];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [YBPreHelper setNavState:NavState_White vc:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightItemTitle style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];

}
- (void)save {
    if ([self.delegate respondsToSelector:@selector(YBPreViewImgViewDidFinishWithImages:)]) {
            [self.delegate YBPreViewImgViewDidFinishWithImages:isChoosenDic.copy];
    }
}
- (void)back {
    if ([self.delegate respondsToSelector:@selector(YBPreViewImgViewBackToPreVc:)]) {
        [self.delegate YBPreViewImgViewBackToPreVc:curIndex.copy];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [myCollectionView registerNib:[UINib nibWithNibName:@"YBPreViewImgViewCell" bundle:nil] forCellWithReuseIdentifier:YBPreViewImgViewCellReuseIdentifier];
    [self initDefaultView];
}
- (void)initDefaultView {
    self.title = [NSString stringWithFormat:@"%ld/%ld",(long)firstIndex.item + 1,(long)colletionData.count];
    //naviegationBar
    self.view.frame = [UIScreen mainScreen].bounds;
    //collectionView
    UICollectionViewFlowLayout * mycollectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    mycollectionViewLayout.minimumInteritemSpacing = 0;
    mycollectionViewLayout.minimumLineSpacing = 0;
    mycollectionViewLayout.itemSize = CGSizeMake(YBPreViewImgViewCellWidth, YBPreViewImgViewCellHeight);
    mycollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mycollectionViewLayout.sectionInset = UIEdgeInsetsZero;
    myCollectionView.collectionViewLayout = mycollectionViewLayout;
    myCollectionView.pagingEnabled = YES;
    myCollectionView.showsVerticalScrollIndicator = NO;
    myCollectionView.showsHorizontalScrollIndicator = NO;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.backgroundColor = [UIColor whiteColor];
    [myCollectionView reloadData];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [myCollectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return colletionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBPreViewImgViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YBPreViewImgViewCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    ALAsset * asset = [colletionData objectAtIndex:indexPath.item];
    
    BOOL assetIsChoosen;
    if ([isChoosenDic objectForKey:[asset description]]) {
        assetIsChoosen = YES;
    }
    else {
        assetIsChoosen = NO;
    }

    cell.contentImg = [UIImage imageWithCGImage:[[asset defaultRepresentation]fullResolutionImage]];
    cell.isChoosenImgHidden = NO;
    cell.isChoosen = assetIsChoosen;
    cell.resetScale = YES;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == myCollectionView) {
        NSInteger curX = scrollView.contentOffset.x;
        if (curX % (NSInteger)[UIScreen mainScreen].bounds.size.width == 0) {
            curIndex = [NSIndexPath indexPathForItem:curX / CGRectGetWidth([UIScreen mainScreen].bounds) inSection:0];
            self.title = [NSString stringWithFormat:@"%ld/%ld",(long)curIndex.item + 1,(long)colletionData.count];
        }
    }
}
- (void)preViewImgViewCellIsChoosen:(YBPreViewImgViewCell *)cell {
    NSIndexPath * indexPath = [self.myCollectionView indexPathForCell:cell];
    NSInteger  tag = indexPath.item;
    ALAsset * asset = [colletionData objectAtIndex:tag];
    BOOL isChoosen;
    if ([isChoosenDic objectForKey:[asset description]]) {
        isChoosen = YES;
    }
    else {
        isChoosen = NO;
    }
    
    if (!isChoosen) {
        if (isChoosenDic.count >= photoCounts) {
            return;
        }
        UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        [isChoosenDic setObject:[UIImage imageWithData:UIImageJPEGRepresentation(image, 0.7)] forKey:[asset description]];
    }else {
        [isChoosenDic removeObjectForKey:[asset description]];
    }
    
    self.navigationItem.rightBarButtonItem.title = rightItemTitle;
    [self.myCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}
@end
