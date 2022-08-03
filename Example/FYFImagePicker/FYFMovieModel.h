//
//  FYFMovieModel.h
//  FYFImagePicker
//
//  Created by 范云飞 on 2022/7/16.
//  Copyright © 2022 范云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FYFTableCollectionMiddleWare/FYFTableCollectionMiddleWare.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYFMovieModel : NSObject<FYFItemModelProtocol>

- (instancetype)initWithMovieData:(NSData *)movieData movieUrl:(NSURL *)movieUrl moviePreViewImage:(UIImage *)moviePreViewImage;

@property (nonatomic, strong) NSData *movieData;
@property (nonatomic, strong) NSURL *movieUrl;
@property (nonatomic, strong) UIImage *moviePreViewImage;
@property (nonatomic, strong) Class itemClass;

@end

NS_ASSUME_NONNULL_END
