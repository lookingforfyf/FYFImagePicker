//
//  FYFImagePreViewController.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/17.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFImagePreViewController.h"
#import <FYFDefines/FYFColorDefine.h>

@interface FYFImagePreViewController ()

@property (nonatomic, strong) UIImageView *previewImageView;
@end

@implementation FYFImagePreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _previewImageView = [[UIImageView alloc] init];
    [_previewImageView setImage:self.image];
    [self.view addSubview:_previewImageView];
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(30, 90, 80, 30);
    [dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismissButton setTitleColor:FYFColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    dismissButton.backgroundColor = FYFColorFromRGB(0x224DD4);
    dismissButton.layer.cornerRadius = 4;
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    [self.view bringSubviewToFront:dismissButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat imageOriginalHeight = self.image.size.height;
    CGFloat imageOriginalWidth = self.image.size.width;
    
    CGFloat imageHeight = (viewWidth) *(imageOriginalHeight/imageOriginalWidth);
    CGFloat imageWidth = viewWidth;
        
    CGFloat x = (CGRectGetWidth(self.view.frame) - imageWidth)/2;
    CGFloat y = (CGRectGetHeight(self.view.frame) - imageHeight)/2;
    
    _previewImageView.frame = CGRectMake(x, y, imageWidth, imageHeight);
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
