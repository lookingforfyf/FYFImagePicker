//
//  FYFGetCellClass.h
//  FYFTableCollectionMiddleWareDemo
//
//  Created by 范云飞 on 2021/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 根据cellClass获取cellID
/// @param cellClass cell的class
static NSString * kGetCellIDWithClass(Class cellClass) {
    return  [NSString stringWithFormat:@"cellclass-%@", cellClass];
}

/// 根据cellClass与indexPath获取cellID
/// @param cellClass cell关联的class
/// @param indexPath cell所在的位置
static NSString * kGetCellIDWithClassAndIndex(Class cellClass,NSIndexPath *indexPath) {
    return  [NSString stringWithFormat:@"cellclass-%@-%@-%@", cellClass,@(indexPath.section),@(indexPath.row)];
}

/// 根据Header/Footer的class获取viewID
/// @param headerFooterClass Header/Footer的class
static NSString * kGetHeaderFooterIDWithClass(Class headerFooterClass) {
    return  [NSString stringWithFormat:@"headerfooterclass-%@", headerFooterClass];
}


NS_ASSUME_NONNULL_END
