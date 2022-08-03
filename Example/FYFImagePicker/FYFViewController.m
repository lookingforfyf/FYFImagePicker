//
//  FYFViewController.m
//  FYFImagePicker
//
//  Created by 786452470@qq.com on 08/03/2022.
//  Copyright (c) 2022 786452470@qq.com. All rights reserved.
//

#import "FYFViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <FYFImagePicker/FYFImagePickerController.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "FYFImageCollectionView.h"
#import "FYFMovieCollectionView.h"
#import "FYFImageModel.h"
#import "FYFMovieModel.h"

@interface FYFViewController ()

@property (nonatomic, strong) FYFImagePickerController *imagePicker;
@property (nonatomic, strong) FYFImageCollectionView *imageCollectionView;
@property (nonatomic, strong) FYFMovieCollectionView *movieCollectionView;

@end

@implementation FYFViewController

- (void)dealloc {
    NSLog(@"FYFViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *pickerButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 80)/2, 100, 80, 30)];
    pickerButton.backgroundColor = [UIColor blackColor];
    [pickerButton setTitle:@"picker" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickerButton addTarget:self action:@selector(picker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
    
    [self.view addSubview:self.imageCollectionView];
    [self.view addSubview:self.movieCollectionView];
}

#pragma mark - Getters
- (FYFImageCollectionView *)imageCollectionView {
    if (!_imageCollectionView) {
        _imageCollectionView = [[FYFImageCollectionView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 300)];
    }
    return _imageCollectionView;
}

- (FYFMovieCollectionView *)movieCollectionView {
    if (!_movieCollectionView) {
        _movieCollectionView = [[FYFMovieCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageCollectionView.frame) + 30, self.view.frame.size.width, 300)];
    }
    return _movieCollectionView;
}

- (FYFImagePickerController *)imagePicker {
    if (!_imagePicker) {
        __weak typeof(self) weakSelf = self;
        _imagePicker = [[FYFImagePickerController alloc] initWithPresentingViewController:self];
        _imagePicker.callPickerCompletion = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
//            [[KSToast toast] ks_showLoadingWithTitle:@"资源加载中......" inView:strongSelf.view];
        };
        _imagePicker.imagePickerCompletion = ^(NSArray<UIImage *> * _Nonnull images, NSArray<NSURL *> * _Nonnull imageUrls) {
            NSLog(@"images:%@",images.debugDescription);
            NSLog(@"imageUrls:%@", imageUrls);
            [weakSelf renderImages:images imageUrls:imageUrls];
        };
        _imagePicker.videoPickerCompletion = ^(NSArray<NSData *> * _Nonnull videoDatas, NSArray<NSURL *> * _Nonnull videoUrls) {
            NSLog(@"videoDatas:%@",videoDatas.debugDescription);
            NSLog(@"videoUrls:%@", videoUrls);
            [weakSelf renderMovieDatas:videoDatas movieUrls:videoUrls];
        };

        _imagePicker.cancelPickerCompletion = ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//            [[KSToast toast] ks_hiddenAllToasts];
        };
        
        if (@available(iOS 14.0, *)) {
            _imagePicker.selectionLimit = 9;
        } else {
            // Fallback on earlier versions
        }
    }
    return _imagePicker;
}

- (void)renderImages:(NSArray<UIImage *>*)images imageUrls:(NSArray<NSURL *>*)imageUrls {
//    [[KSToast toast] ks_hiddenAllToasts];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSMutableArray *imageModels = [NSMutableArray arrayWithCapacity:images.count];
    [images enumerateObjectsUsingBlock:^(UIImage*  _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        FYFImageModel *imageModel = [[FYFImageModel alloc] initWithImage:image imageUrl:imageUrls[idx]];
        [imageModels addObject:imageModel];
    }];
    self.imageCollectionView.imageModels = imageModels;
}

- (void)renderMovieDatas:(NSArray<NSData *>*)movieDatas movieUrls:(NSArray<NSURL *>*)movieUrls {
//    [[KSToast toast] ks_hiddenAllToasts];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableArray *movieModels = [NSMutableArray arrayWithCapacity:movieDatas.count];
    [movieDatas enumerateObjectsUsingBlock:^(NSData*  _Nonnull movieData, NSUInteger idx, BOOL * _Nonnull stop) {
        FYFMovieModel *movieModel = [[FYFMovieModel alloc] initWithMovieData:movieData movieUrl:movieUrls[idx] moviePreViewImage:[self requestVideoPreViewImage:movieUrls[idx]]];
        [movieModels addObject:movieModel];
    }];
    self.movieCollectionView.movieModels = movieModels;;
}

/// 获取视频第一帧
- (UIImage*)requestVideoPreViewImage:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - Actions
- (void)picker {
    __weak typeof(self) weakSelf = self;
    NSArray *otherButtonTitles  = @[@"录像",@"拍照",@"从相册中选择图片",@"从相册中选择视频"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){ }];
    [alertController addAction:cancelAction];

    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if (i == 0) {
                [weakSelf.imagePicker cameraVedioPicker];
            } else if (i == 1) {
                [weakSelf.imagePicker cameraPhotoPicker];
            } else if (i == 2) {
                [weakSelf.imagePicker imagePicker];
            } else if (i == 3) {
                [weakSelf.imagePicker videoPicker];
            }
        }];
        [alertController addAction:otherAction];
    }
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}



@end
