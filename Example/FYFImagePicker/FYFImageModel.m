//
//  FYFImageModel.m
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import "FYFImageModel.h"
#import "FYFImageCollectionViewCell.h"

@implementation FYFImageModel

- (instancetype)initWithImage:(UIImage *)image imageUrl:(NSURL *)imageUrl {
    self = [super init];
    if (self) {
        _image = image;
        _imageUrl = imageUrl;
    }
    return self;
}

- (Class)itemClass {
    if (!_itemClass) {
        _itemClass = [FYFImageCollectionViewCell class];
    }
    return _itemClass;
}

@end
