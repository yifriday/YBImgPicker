//
//  ViewController.m
//  settingsTest
//
//  Created by 宋奕兴 on 15/8/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import "ViewController.h"
#import "IPHelper.h"
#import "YBImgPickerViewController.h"
@interface ViewController ()<YBImgPickerViewControllerDelegate>
{
    NSMutableDictionary * choosenDic;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [getIPBtn addTarget:self action:@selector(getIP) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [getIPBtn addGestureRecognizer:pan];
    [getIPBtn setValue:getIPBtn.currentTitle forKey:@"title"];
    [getIPBtn addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    iPLable.text = [IPHelper getIPAddress:YES];
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translatedPoint = [recognizer translationInView:self.view];
    NSLog(@"gesture translatedPoint  is %@", NSStringFromCGPoint(translatedPoint));
    CGFloat x = recognizer.view.center.x + translatedPoint.x;
    CGFloat y = recognizer.view.center.y + translatedPoint.y;
    
    recognizer.view.center = CGPointMake(x, y);
    
    NSLog(@"pan gesture testPanView moving  is %@,%@", NSStringFromCGPoint(recognizer.view.center), NSStringFromCGRect(recognizer.view.frame));
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (void)getIP {
    [getIPBtn setValue:getIPBtn.currentTitle forKey:@"title"];
    [getIPBtn setTitle:@"Down" forState:UIControlStateNormal];
    
}
- (IBAction)gotoNextView:(id)sender {
    YBImgPickerViewController * next = [[YBImgPickerViewController alloc]initWithChoosenImgDic:choosenDic delegate:self];
    [next showInViewContrller:self];
}

- (void)YBImagePickerDidFinishWithImages:(NSDictionary *)choosenImgDic {
    choosenDic = choosenImgDic.mutableCopy;
    //返回的是选中的图片的dictionary，key为asset，value为uiimage
}

@end
