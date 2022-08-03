//
//  FYFMovieCollectionView.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFMovieCollectionView.h"
#import <FYFTableCollectionMiddleWare/FYFTableCollectionMiddleWare.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "FYFMovieModel.h"

@interface FYFMovieCollectionView ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, FYFCollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FYFMovieCollectionView

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

- (void)setMovieModels:(NSArray*)movieModels {
    _movieModels = movieModels;
    [self.collectionView clear];
    
    FYFListData *listData = [FYFListData listData];
    [listData appendModels:movieModels];
    [self.collectionView addSectionData:listData];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FYFMovieModel *movieModel = [collectionView dataOfIndexPath:indexPath];
    [self playMovie:movieModel.movieUrl];
}

- (void)playMovie:(NSURL *)movieUrl {
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:movieUrl];
    AVPlayerViewController *avPlayerVC = [[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:avPlayerVC animated:YES completion:nil];
}


@end
