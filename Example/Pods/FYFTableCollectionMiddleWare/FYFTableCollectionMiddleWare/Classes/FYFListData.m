/*
 #####################################################################
 # File    : FYFListData.m
 # Project : FYFTableCollectionMiddleWare
 # Created : 2021/8/13 1:52 PM
 # DevTeam : fanyunfei Development Team
 # Author  : fanyunfei
 # Notes   : 列表的每个section的的数据源
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  :
 # Author:
 # Notes :
 #
 #####################################################################
 */


#import "FYFListData.h"

@interface FYFListData() {
    @protected
    NSMutableArray<id<FYFItemModelProtocol>> *_sectionArray;
}

@end

@implementation FYFListData

/// 初始化
- (instancetype)init {
    if (self = [super init]) {
        _sectionArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

/// 便捷的初始化方式
+ (instancetype)listData {
    return [[self alloc] init];
}

// 实现可枚举协议，使FYFListData类可以实现for in的方式去遍历
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable [_Nonnull])buffer count:(NSUInteger)len {
    return [_sectionArray countByEnumeratingWithState:state objects:buffer count:len];
}

// 获取section数据的count
- (NSInteger)count {
    return _sectionArray.count;
}

/// 添加model
/// @param model 要添加的model
- (void)addModel:(id<FYFItemModelProtocol>)model {
    if (model == nil) {
        return;
    }
    [_sectionArray addObject:model];
}

/// 添加model数组
/// @param modelArray 要添加的model数组
- (void)appendModels:(NSArray<id<FYFItemModelProtocol>> *)modelArray {
    if (modelArray == nil || modelArray.count <= 0) {
        return;
    }
    [_sectionArray addObjectsFromArray:modelArray];
}

/// 插入一条model数据
/// @param model 对应的数据model
/// @param index 对应的位置
- (void)insertModel:(id<FYFItemModelProtocol>)model atIndex:(NSInteger)index {
    if (model == nil || index < 0 || index >= self.count) {
        return;
    }
    [_sectionArray insertObject:model atIndex:index];
}

/// 替换一个数据model在对应的位置
/// @param index 对应的index
/// @param model 数据model
- (void)replaceModelAtIndex:(NSInteger)index newModel:(id<FYFItemModelProtocol>)model {
    if (model == nil || index < 0 || index >= self.count) {
        return;
    }
    [_sectionArray replaceObjectAtIndex:index withObject:model];
}

/// 移除所有的数据model
- (void)removeAllModels {
    [_sectionArray removeAllObjects];
}

/// 移除对应的数据model
/// @param model 数据model
- (void)removeModel:(id<FYFItemModelProtocol>)model {
    if (model == nil) {
        return;
    }
    [_sectionArray removeObject:model];
}

/// 移除数据model在对应的位置
/// @param index 数据model的位置
- (void)removeModelAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.count) {
        return;
    }
    [_sectionArray removeObjectAtIndex:index];
}

/// 获取model
/// @param index 对应的index
- (nullable id<FYFItemModelProtocol>)modelAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.count) {
        return nil;
    }
    return [_sectionArray objectAtIndex:index];
}
@end
