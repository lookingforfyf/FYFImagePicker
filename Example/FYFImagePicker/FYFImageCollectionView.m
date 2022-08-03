//
//  FYFImageCollectionView.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFImageCollectionView.h"
#import <FYFTableCollectionMiddleWare/FYFTableCollectionMiddleWare.h>
#import "FYFImageModel.h"
#import "FYFImagePreViewController.h"

@interface FYFImageCollectionView ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, FYFCollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FYFImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = CGFLOAT_MIN;
        layout.minimumLineSpacing = CGFLOAT_MIN;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithLayout:layout delegate:self];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)setImageModels:(NSArray*)imageModels {
    _imageModels = imageModels;
    [self.collectionView clear];
    
    FYFListData *listData = [FYFListData listData];
    [listData appendModels:imageModels];
    [self.collectionView addSectionData:listData];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FYFImageModel *imageModel = [collectionView dataOfIndexPath:indexPath];
    FYFImagePreViewController *imagePreviewVC = [[FYFImagePreViewController alloc] init];
    imagePreviewVC.image = imageModel.image;
    imagePreviewVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:imagePreviewVC animated:YES completion:nil];
}

@end
