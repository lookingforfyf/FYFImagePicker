//
//  FYFMovieModel.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFMovieModel.h"
#import "FYFMovieCollectionViewCell.h"

@implementation FYFMovieModel

- (instancetype)initWithMovieData:(NSData *)movieData movieUrl:(NSURL *)movieUrl moviePreViewImage:(UIImage *)moviePreViewImage {
    self = [super init];
    if (self) {
        _movieData = movieData;
        _movieUrl = movieUrl;
        _moviePreViewImage = moviePreViewImage;
    }
    return self;
}

- (Class)itemClass {
    if (!_itemClass) {
        _itemClass = [FYFMovieCollectionViewCell class];
    }
    return _itemClass;
}

@end
