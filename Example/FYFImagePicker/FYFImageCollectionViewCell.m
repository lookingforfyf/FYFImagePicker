//
//  FYFImageCollectionViewCell.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFImageCollectionViewCell.h"
#import "FYFImageModel.h"

@interface FYFImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FYFImageCollectionViewCell

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
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
}

#pragma mark - FYFCollectionItemProtocol
- (void)setModel:(id<FYFItemModelProtocol>)model {
    FYFImageModel *imageModel = (FYFImageModel *)model;
    [self.imageView setImage:imageModel.image];
}

+ (CGSize)sizeForItem:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height/3);
}

@end
