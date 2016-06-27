//
//  YBImgPickerViewController.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//
#define empty_width 3
#define maxnum_of_one_line 3
#define itemHeight ( CGRectGetWidth([UIScreen mainScreen].bounds) - (maxnum_of_one_line + 1) * empty_width ) / maxnum_of_one_line
#define item_Size CGSizeMake(itemHeight , itemHeight)
#define rightItemTitle [NSString stringWithFormat:@"完成 %ld/%ld",(long)isChoosenDic.count,(long)photoCounts]

#define tableCellH 70


#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "YBImgPickerViewController.h"
#import "YBImgPickerViewCell.h"
#import "YBImgPickerTableViewCell.h"
#import "YBPreImgViewController.h"


@interface YBImgPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,YBImgPickerViewCellDelegate,YBPreImgViewControllerDelegate>
{
    NSMutableArray * tableData;
    NSMutableArray * colletionData;
    NSMutableDictionary * isChoosenDic;
    BOOL isShowTable;
    UIViewController * preVC;
}
@property (nonatomic , strong) IBOutlet UICollectionView * myCollectionView;
@property (nonatomic , strong) IBOutlet UITableView * myTableView;
@property (nonatomic , strong) IBOutlet UIView * backView;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint * tableViewHeightCon;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint * tableViewTopCon;
@property (nonatomic , strong) UINavigationController *nav;
@property (nonatomic , strong) UIButton * titleBtn;
@property (nonatomic , weak) id <YBImgPickerViewControllerDelegate> delegate;
@property (nonatomic , strong) ALAssetsLibrary *assetsLibrary;
@end

@implementation YBImgPickerViewController
@synthesize myTableView,myCollectionView,backView,titleBtn;
@synthesize assetsLibrary;
@synthesize nav;
static NSString * const colletionReuseIdentifier = @"_collectionCell";
static NSString * const tableReuseIdentifier = @"_tableCell";
- (instancetype)initWithChoosenImgDic:(NSDictionary *)choosenImgDic delegate:(id<YBImgPickerViewControllerDelegate>)vcdelegate {
    self = [self initWithNibName:@"YBImgPickerViewController" bundle:nil];
    if (self) {
        nav = [[UINavigationController alloc] initWithRootViewController:self];
        tableData = [[NSMutableArray alloc]init];
        colletionData = [[NSMutableArray alloc]init];
        assetsLibrary = [[ALAssetsLibrary alloc]init];
        self.delegate = vcdelegate;
        isChoosenDic = [NSMutableDictionary dictionaryWithDictionary:choosenImgDic];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNav];
}
- (void)setNav {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica Neue" size:20], NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem.title = rightItemTitle;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    
    [myCollectionView registerNib:[UINib nibWithNibName:@"YBImgPickerViewCell" bundle:nil] forCellWithReuseIdentifier:colletionReuseIdentifier];
    [myTableView registerNib:[UINib nibWithNibName:@"YBImgPickerTableViewCell" bundle:nil] forCellReuseIdentifier:tableReuseIdentifier];
    
    
    [self getTableData];
    [self initDefaultView];
    
}
- (void)initDefaultView {
    //naviegationBar
    self.view.frame = [UIScreen mainScreen].bounds;
    self.navigationItem.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [titleBtn setImage:[UIImage imageNamed:@"YBimgPickerView.bundle/arrow"] forState:UIControlStateNormal];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 78, 0, 0)];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    [titleBtn setFrame:self.navigationItem.titleView.frame];
//    [titleBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20]];
    [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:20.]];
    [titleBtn setTitle:@"相册胶卷" forState:UIControlStateNormal];
    [titleBtn sizeToFit];
    titleBtn.center = self.navigationItem.titleView.center;
    
    [titleBtn addTarget:self action:@selector(showTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.titleView addSubview:titleBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(hide)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightItemTitle style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    //    self.navigationItem.rightBarButtonItem.enabled = NO;
    //tableView
    myTableView.rowHeight = tableCellH;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.hidden = YES;
    myTableView.scrollsToTop = NO;
    //collectionView
    UICollectionViewFlowLayout * mycollectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    mycollectionViewLayout.minimumInteritemSpacing = empty_width;
    mycollectionViewLayout.minimumLineSpacing = empty_width + 2;
    mycollectionViewLayout.itemSize = item_Size;
    mycollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    mycollectionViewLayout.sectionInset = UIEdgeInsetsMake(empty_width + 2, empty_width , empty_width + 2, empty_width);
    myCollectionView.collectionViewLayout = mycollectionViewLayout;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.backgroundColor = [UIColor whiteColor];
    //backView
    isShowTable = NO;
    backView.alpha = 0;
    UITapGestureRecognizer * backViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTableView)];
    [backView addGestureRecognizer:backViewTap];
}
- (void)setTableViewHeight {
    self.tableViewHeightCon.constant = [self getTabelViewHeight];
    self.tableViewTopCon.constant = -[self getTabelViewHeight];
    //    [self.view layoutIfNeeded];
}
- (void)getTableData {
    __weak typeof(self) weakSelf = self;
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        
        if(assetsGroup) {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            if(assetsGroup.numberOfAssets > 0) {
                [tableData insertObject:assetsGroup atIndex:0];
            }
        }else {
            if (tableData.count) {
                
                [weakSelf setTableViewHeight];
                [weakSelf getCollectionData:0];
                
                [myTableView reloadData];
                [myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                
            }
        }
    };
    
    
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    // ALAssetsGroupAll
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];

}
- (void)getCollectionData:(NSInteger)tag {
    if (colletionData.count) {
        [colletionData removeAllObjects];
    }
    [colletionData addObject:[UIImage imageNamed:@"YBimgPickerView.bundle/takePicture"]];
    if (tableData.count) {
        
        ALAssetsGroup * assetsGroup = [tableData objectAtIndex:tag];
        [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                NSString *type=[result valueForProperty:ALAssetPropertyType];
                if ([type isEqualToString:ALAssetTypePhoto]) {
                    [colletionData insertObject:result atIndex:1];
                }
            }else {
                [myCollectionView reloadData];
                
            }
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return colletionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YBImgPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:colletionReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item != 0) {
        ALAsset * asset = [colletionData objectAtIndex:indexPath.item];
        BOOL assetIsChoosen;
        if ([isChoosenDic objectForKey:[asset description]]) {
            assetIsChoosen = YES;
        }
        else {
            assetIsChoosen = NO;
        }
        cell.contentImg = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        cell.isChoosenImgHidden = NO;
        cell.isChoosen = assetIsChoosen;
    }else {
        cell.contentImg = [colletionData objectAtIndex:indexPath.item];
        cell.isChoosenImgHidden = YES;
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        if (isChoosenDic.count >= photoCounts) {
            return;
        }
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
            {
                //无权限
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"未设置使用相机权限" message:@"请前往设置页面设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
                
            }
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.showsCameraControls  = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请检查相机是否完好" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        
    }else {
        // 放大预览
        NSMutableArray * cData = [[NSMutableArray alloc]initWithArray:colletionData];
        [cData removeObjectAtIndex:0];
        NSIndexPath * index = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:0];
        YBPreImgViewController * preViewController = [[YBPreImgViewController alloc]initWithColletionData:cData isChoosenDic:isChoosenDic curIndex:index delegate:self];
        [preViewController showInViewContrller:self];
    }
}
- (void)cellIsChoosen:(YBImgPickerViewCell *)cell {
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
        image = [self fixOrientation:image];
        [isChoosenDic setObject:[UIImage imageWithData:UIImageJPEGRepresentation(image, 0.7)] forKey:[asset description]];
    }else {
        [isChoosenDic removeObjectForKey:[asset description]];
    }
    
    self.navigationItem.rightBarButtonItem.title = rightItemTitle;
    [self.myCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBImgPickerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableReuseIdentifier forIndexPath:indexPath];
    ALAssetsGroup * assetsGroup = [tableData objectAtIndex:indexPath.row];
    cell.albumTitle = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    cell.photoNum = assetsGroup.numberOfAssets;
    cell.albumImg = [UIImage imageWithCGImage:assetsGroup.posterImage];
    cell.backgroundColor = tableView.backgroundColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self getCollectionData:indexPath.row];
    [self showTableView];
    
}
#pragma mark imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [[UIImage alloc]init];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        UIImage * newOriImg = [self fixOrientation:image];
        // 保存图片到相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            //            UIImageWriteToSavedPhotosAlbum(image,self,nil, NULL);
            [isChoosenDic setObject:[UIImage imageWithData:UIImageJPEGRepresentation(newOriImg, 0.7)] forKey:@"Camera"];
        }
        __weak typeof(self) weakSelf = self;
        [picker dismissViewControllerAnimated:NO completion:^() {
            [weakSelf save];
        }];
        
    }
}

#pragma mark self
- (void)showInViewContrller:(UIViewController *)vc {

    preVC = vc;
    [vc presentViewController:nav animated:YES completion:nil];
    
}
- (void)hide{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf mydealloc];
    }];
    
}
- (void)save {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(YBImagePickerDidFinishWithImages:)]) {
            [weakSelf.delegate YBImagePickerDidFinishWithImages:isChoosenDic.copy];
            [weakSelf mydealloc];
        }
    }];
}
- (void)YBPreViewImgViewDidFinishWithImages:(NSDictionary *)choosenImgDic {
    isChoosenDic = choosenImgDic.copy;
    [self save];
}
- (void)YBPreViewImgViewBackToPreVc:(NSIndexPath *)index {
    [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
}
- (void)showTableView {
    myTableView.hidden = NO;
    backView.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    if (isShowTable) {
        self.tableViewTopCon.constant += 5;
        [UIView animateWithDuration:0.25 animations:^{
            backView.alpha = 0;
            [weakSelf.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            titleBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            self.tableViewTopCon.constant = - [self getTabelViewHeight];
            [UIView animateWithDuration:0.35 animations:^{
                [weakSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                backView.userInteractionEnabled = NO;
                isShowTable = !isShowTable;
            }];
        }];
    }
    else {
        self.tableViewTopCon.constant = 64 + 5;
        [UIView animateWithDuration:0.25 animations:^{
            backView.alpha = 1;
            [weakSelf.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            titleBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            self.tableViewTopCon.constant = 64;
            [UIView animateWithDuration:0.35 animations:^{
                [weakSelf.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                backView.userInteractionEnabled = YES;
                isShowTable = !isShowTable;
            }];
        }];
    }
}
- (void)mydealloc {
    tableData = nil;
    colletionData = nil;
    isChoosenDic = nil;
    
    myCollectionView = nil;
    myTableView = nil;
    backView = nil;
    nav = nil;
    titleBtn = nil;
    _delegate = nil;
    assetsLibrary = nil;
}

- (CGFloat)getTabelViewHeight {
    return MIN(CGRectGetHeight([UIScreen mainScreen].bounds) - 64, tableCellH * tableData.count);
}
#pragma mark - 图片相关
//修正>2M的图片方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
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

@end
