/*
 #####################################################################
 # File    : FYFCollectionMiddleware.m
 # Project : FYFTableCollectionMiddleWare
 # Created : 2021/8/13 1:52 PM
 # DevTeam : fanyunfei Development Team
 # Author  : fanyunfei
 # Notes   : UICollectionView的管理类
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

#import "FYFCollectionMiddleware.h"
#import <objc/runtime.h>
#import "FYFGetCellClass.h"

@interface FYFCollectionMiddleware()
// 缓存注册信息
@property (nonatomic, strong) NSMutableDictionary * cacheRegisterCellDict;
// CollectionView的数据源
@property (nonatomic, strong) NSMutableArray<FYFListData *> *collectionSource;

@end


@implementation FYFCollectionMiddleware


// section的总数
- (NSInteger)count {
    return self.collectionSource.count;
}

/// 添加一个section的数据
/// @param sectionData section的数据
- (void)addSectionData:(FYFListData *)sectionData {
    if (sectionData == nil) {
        return;
    }
    [self.collectionSource addObject:sectionData];
}

/// 获取一个section的数据
/// @param section section对应的位置
- (nullable FYFListData *)dataOfSection:(NSInteger)section {
    if(section > -1 && section < [self.collectionSource count]){
        return self.collectionSource[section];
    }
    return nil;
}

/// 移除一个section的数据
/// @param sectionData 对应的section数据
- (void)removeSectionData:(FYFListData *)sectionData {
    if (sectionData == nil) {
        return;
    }
    if (![self.collectionSource containsObject:sectionData]) {
        return;
    }
    // removeObject:会删除所有的空数组元素当sectionData为空数组的时候，所以先获取index之后再删除
    NSUInteger index = [self.collectionSource indexOfObjectPassingTest:^BOOL(FYFListData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj == sectionData;
    }];
    if (index >= 0 && index < self.collectionSource.count) {
        [self.collectionSource removeObjectAtIndex:index];
    }
}

/// 插入一个section的数据
/// @param sectionData 要插入的数据
/// @param section 要插入数据的位置
- (void)insertSectionData:(FYFListData *)sectionData atSection:(NSInteger)section {
    if (section < -1 || section >= self.collectionSource.count || sectionData == nil) {
        return;
    }
    [self.collectionSource insertObject:sectionData atIndex:section];
}

/// 移除所有的section
- (void)removeAllSections {
    [self.collectionSource removeAllObjects];
}

#pragma mark- runtime

- (BOOL)respondsToSelector:(SEL)aSelector {
    // 检查是否能响应到该方法
    BOOL isRespond = [super respondsToSelector:aSelector];
    // 代理对象是否l可以响应到
    if (!isRespond) {
        isRespond = [self.delegate respondsToSelector:aSelector];
    }
    // 数据代理对象是否可以响应到
    if (!isRespond) {
        isRespond = [self.dataSource respondsToSelector:aSelector];
    }
    return isRespond;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 进入到这个方法说明上面的respondsToSelector返回为YES，但是又找到对应的方法，所以直接使用备用对象
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    if ([self.dataSource respondsToSelector:aSelector]) {
        return self.dataSource;
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = [sectionData modelAtIndex:indexPath.row];
    NSAssert(model, @"Array out of bounds!!!");
    NSAssert(model.itemClass, @"Register cell does not implement CellModelProtocol!!!");
    
    SEL heightMethod = @selector(sizeForItem:indexPath:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGSize (*sizeForCellFunc)(Class, SEL, id, id);
        sizeForCellFunc func = (sizeForCellFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, collectionView, indexPath);
        }
    }
    return CGSizeMake(40.0f, 40.0f);
}

- (UICollectionReusableView<CollectionHeaderFooterProtocol> *)registerHeaderFooterWithModel:(id<FYFItemModelProtocol>)model kind:(NSString *)kind table:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    NSString *itemClassString = NSStringFromClass(model.itemClass);
    NSAssert(itemClassString, @"register collectionView header or footer does not implement FYFItemModelProtocol!!!");
    // 注册的话header、footer要分开注册，否则会闪退，所以这边使用两个key来缓存
    itemClassString = [NSString stringWithFormat:@"%@-%@",kind,itemClassString];
    if ([self.cacheRegisterCellDict valueForKey:itemClassString] == nil) {
        [collectionView registerClass:model.itemClass forSupplementaryViewOfKind:kind withReuseIdentifier:kGetHeaderFooterIDWithClass(model.itemClass)];
        [self.cacheRegisterCellDict setValue:model.itemClass forKey:itemClassString];
    }
    // 获取注册ReusableView
    UICollectionReusableView<CollectionHeaderFooterProtocol> *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kGetHeaderFooterIDWithClass(model.itemClass) forIndexPath:indexPath];
    NSAssert(view, @"table header or footer class has not register!!!");
    view.collection = collectionView;
    view.indexPath = indexPath;
    view.model = model;
    return view;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    if (sectionData == nil) {
        return nil;
    }
    id<FYFItemModelProtocol> model = kind == UICollectionElementKindSectionHeader ?         sectionData.headerModel : sectionData.footerModel;
    if (model == nil) {
        return nil;
    }
    return [self registerHeaderFooterWithModel:model kind:kind table:collectionView atIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.headerModel;
    if (model == nil) return CGSizeZero;
    
    SEL heightMethod = @selector(sizeForHeaderFooter:kind:section:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGSize (*sizeForCellFunc)(Class, SEL, id, id, NSInteger);
        sizeForCellFunc func = (sizeForCellFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, collectionView,UICollectionElementKindSectionHeader, section);
        }
    }
    return CGSizeMake(40.0f, 40.0f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.footerModel;
    if (model == nil) return CGSizeZero;
    
    SEL heightMethod = @selector(sizeForHeaderFooter:kind:section:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGSize (*sizeForCellFunc)(Class, SEL, id, id, NSInteger);
        sizeForCellFunc func = (sizeForCellFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, collectionView,UICollectionElementKindSectionFooter,section);
        }
    }
    return CGSizeMake(40.0f, 40.0f);
}
#pragma mark- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectionSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.collectionSource.count <= section || section < 0) {
        NSAssert(NO, @"Array out of bounds!!!");
        return 0;
    }
    FYFListData *sectionData = [self.collectionSource objectAtIndex:section];
    return sectionData.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = [sectionData modelAtIndex:indexPath.row];
    NSAssert(model, @"Array out of bounds!!!");
    
    // 缓存注册信息，避免相同model多次注册
    NSString *itemClassString = NSStringFromClass(model.itemClass);
    NSAssert(itemClassString, @"Register cell does not implement CellModelProtocol!!!");
    if ([self.cacheRegisterCellDict valueForKey:itemClassString] == nil) {
        [collectionView registerClass:model.itemClass forCellWithReuseIdentifier:kGetCellIDWithClass(model.itemClass)];
        [self.cacheRegisterCellDict setValue:model.itemClass forKey:itemClassString];
    }
    // 获取注册cell
    UICollectionViewCell<CollectionItemProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGetCellIDWithClass(model.itemClass) forIndexPath:indexPath];
    NSAssert(cell, @"cell class has not register!!!");
    
    cell.collection = collectionView;
    cell.indexPath = indexPath;
    cell.model = model;
    return cell;
}



#pragma mark- lazy

- (NSMutableArray *)collectionSource {
    if (!_collectionSource) {
        _collectionSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _collectionSource;
}
- (NSMutableDictionary *)cacheRegisterCellDict {
    if (!_cacheRegisterCellDict) {
        _cacheRegisterCellDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _cacheRegisterCellDict;
}
@end
