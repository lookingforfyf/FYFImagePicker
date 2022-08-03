//
//  FYFMovieCollectionViewCell.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFMovieCollectionViewCell.h"
#import "FYFMovieModel.h"

@interface FYFMovieCollectionViewCell ()

@property (nonatomic, strong) UIImageView *videoPreviewImageView;

@end

@implementation FYFMovieCollectionViewCell
@synthesize collection;
@synthesize indexPath;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    _videoPreviewImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    _videoPreviewImageView.contentMode = UIViewContentModeScaleAspectFill;
    _videoPreviewImageView.clipsToBounds = YES;
    [self.contentView addSubview:_videoPreviewImageView];
}

#pragma mark - KSCollectionItemProtocol
- (void)setModel:(id<FYFItemModelProtocol>)model {
    FYFMovieModel *movieModel = (FYFMovieModel *)model;
    [self.videoPreviewImageView setImage:movieModel.moviePreViewImage];
}

+ (CGSize)sizeForItem:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height/3);
}

@end
