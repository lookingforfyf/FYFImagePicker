//
//  FYFImageModel.h
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <FYFTableCollectionMiddleWare/FYFTableCollectionMiddleWare.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYFImageModel : NSObject<FYFItemModelProtocol>

- (instancetype)initWithImage:(UIImage *)image imageUrl:(NSURL *)imageUrl;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) Class itemClass;

@end

NS_ASSUME_NONNULL_END
