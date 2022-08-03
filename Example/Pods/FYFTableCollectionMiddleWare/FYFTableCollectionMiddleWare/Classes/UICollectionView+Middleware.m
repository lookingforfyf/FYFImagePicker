/*
 #####################################################################
 # File    : UICollectionView+Middleware.m
 # Project : FYFTableCollectionMiddleWare
 # Created : 2021/8/13 1:52 PM
 # DevTeam : fanyunfei Development Team
 # Author  : fanyunfei
 # Notes   : 为UICollectionView添加方法
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

#import "UICollectionView+Middleware.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView ()
/** 私有属性 请勿直接操作此对象 */
@property (nonatomic, strong) FYFCollectionMiddleware *collectionMiddleware;

@end
@implementation UICollectionView (Middleware)
// 关联属性中间件
static void *FYFCollectionMiddlewareKey = (void *)@"collectionMiddlewareKey";
-(FYFCollectionMiddleware *)collectionMiddleware {
    return objc_getAssociatedObject(self, FYFCollectionMiddlewareKey);
}
-(void)setCollectionMiddleware:(FYFCollectionMiddleware *)fyfCollectionMiddleware {
    objc_setAssociatedObject(self, FYFCollectionMiddlewareKey, fyfCollectionMiddleware, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable id<UICollectionViewDelegate>)originDelegate {
    return self.collectionMiddleware.delegate;
}
- (nullable id<FYFCollectionViewDataSource>)originDataSource {
    return self.collectionMiddleware.dataSource;
}

#pragma mark- init

/// 初始化一个collectionView、大小为零、默认UICollectionViewFlowLayout
/// @param delegate 代理
- (instancetype)initWithDelegate:(id<UICollectionViewDelegateFlowLayout,FYFCollectionViewDataSource>)delegate {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithFrame:CGRectZero collectionViewLayout:layout delegate:delegate dataSource:delegate];
}

/// 初始化一个collectionView、大小为零
/// @param layout 布局信息
/// @param delegate 代理
- (instancetype)initWithLayout:(UICollectionViewLayout *)layout delegate:(id<UICollectionViewDelegateFlowLayout,FYFCollectionViewDataSource>)delegate {
    return [self initWithFrame:CGRectZero collectionViewLayout:layout delegate:delegate dataSource:delegate];
}

/// 初始化一个collectionView、 大小为零
/// @param layout 布局信息
/// @param delegate 代理
/// @param dataSource 数据代理
- (instancetype)initWithLayout:(UICollectionViewLayout *)layout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate dataSource:(id<FYFCollectionViewDataSource>)dataSource {
    return [self initWithFrame:CGRectZero collectionViewLayout:layout delegate:delegate dataSource:dataSource];
}

/// 初始化一个collectionView
/// @param frame collectionView的大小
/// @param layout 布局信息
/// @param delegate 代理
/// @param dataSource 数据代理
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate dataSource:(id<FYFCollectionViewDataSource>)dataSource {
    self = [self initWithFrame:frame collectionViewLayout:layout];
    [self bindMiddlewareWithDelegate:delegate dataSource:dataSource];
    return self;
}

/// 绑定代理给middleware同时保留其真实的代理
/// @param delegate 代理对象
/// @param dataSource 数据源代理对象
- (void)bindMiddlewareWithDelegate:(id<UICollectionViewDelegateFlowLayout>)delegate dataSource:(id<FYFCollectionViewDataSource>)dataSource {
    // 每一个tableview都有一个自己管理的数据源
    self.collectionMiddleware = [FYFCollectionMiddleware new];
    self.collectionMiddleware.delegate = delegate;
    self.collectionMiddleware.dataSource = dataSource;
    self.delegate = self.collectionMiddleware;
    self.dataSource = self.collectionMiddleware;
}
#pragma mark- 数据源操作

/// 添加一个section数据
/// @param sectionData section数据
- (void)addSectionData:(FYFListData *)sectionData {
    [self.collectionMiddleware addSectionData:sectionData];
}

/// 添加多个section的数据
/// @param sectionDatas section的数据
- (void)addSectionDatas:(NSArray<FYFListData*>*)sectionDatas {
    if (sectionDatas && sectionDatas.count) {
        [sectionDatas enumerateObjectsUsingBlock:^(FYFListData * _Nonnull listData, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addSectionData:listData];
        }];
    }
}

/// 添加一组数据到最后一个section
/// @param dataArray 要添加的数组
- (void)appendModelsToLastSection:(NSArray<id<FYFItemModelProtocol>> *)dataArray {
    FYFListData *sectionData = nil;
    if (self.collectionMiddleware.count <= 0) {
        sectionData = [FYFListData listData];
        [self.collectionMiddleware addSectionData:sectionData];
    }else {
       sectionData = [self.collectionMiddleware dataOfSection:self.collectionMiddleware.count - 1];
    }
    
    if (sectionData == nil) {
        return;
    }
    [sectionData appendModels:dataArray];
}

/// 添加一组数据到最后一个section
/// @param dataArray 要添加的数组
/// @param section 对应的section
- (void)appendModels:(NSArray<id<FYFItemModelProtocol>> *)dataArray atSection:(NSInteger)section {
    if (section >= self.collectionMiddleware.count || section < 0 || dataArray == nil) {
        return;
    }
    FYFListData *sectionData = [self.collectionMiddleware dataOfSection:section];
    if (sectionData == nil) {
        return;
    }
    [sectionData appendModels:dataArray];
}

/// 获取一个section的数据
/// @param section section对应的位置
- (nullable FYFListData *)dataOfSection:(NSInteger)section {
    if (section >= self.collectionMiddleware.count || section < 0) {
        return nil;
    }
    return [self.collectionMiddleware dataOfSection:section];
}

/// 获取一条数据model
/// @param indexPath 所在位置
- (nullable id<FYFItemModelProtocol>)dataOfIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    return [sectionData modelAtIndex:indexPath.row];
}

/// 插入一个section的数据
/// @param sectionData 要插入的数据
/// @param section 要插入数据的位置
- (void)insertSectionData:(FYFListData *)sectionData atSection:(NSInteger)section {
    [self.collectionMiddleware insertSectionData:sectionData atSection:section];
}

/// 移除一个section的数据
/// @param sectionData 对应的section数据
- (void)removeSectionData:(FYFListData *)sectionData {
    [self.collectionMiddleware removeSectionData:sectionData];
}

/// 获取列表section的数目
- (NSInteger)sectionsCount {
    return self.collectionMiddleware.count;
}

/// 清空所有数据源
- (void)clear {
    [self.collectionMiddleware removeAllSections];
}
@end
NS_ASSUME_NONNULL_END
