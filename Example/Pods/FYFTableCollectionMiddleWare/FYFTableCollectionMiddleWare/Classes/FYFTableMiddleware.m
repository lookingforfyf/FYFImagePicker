/*
 #####################################################################
 # File    : KSFYFTableMiddleware.m
 # Project : FYFTableCollectionMiddleWare
 # Created : 2021/8/13 1:52 PM
 # DevTeam : fanyunfei Development Team
 # Author  : fanyunfei
 # Notes   : UITableView的数据源管理类
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

#import "FYFTableMiddleware.h"
#import <objc/runtime.h>
#import "FYFGetCellClass.h"

@interface FYFTableMiddleware()

// 用于缓存注册表
@property (nonatomic, strong) NSMutableDictionary * cacheRegisterCellDict;
// tableView的数据源
@property (nonatomic, strong) NSMutableArray<FYFListData *> *tableSource;

@end

@implementation FYFTableMiddleware

// section的个数
- (NSInteger)count {
    return self.tableSource.count;
}

/// 添加一个section的数据
/// @param sectionData section的数据
- (void)addSectionData:(FYFListData *)sectionData {
    if (sectionData == nil) {
        return;
    }
    [self.tableSource addObject:sectionData];
}

/// 获取一个section的数据
/// @param section section对应的位置
- (nullable FYFListData *)dataOfSection:(NSInteger)section {
    if(section > -1 && section < [self.tableSource count]){
        return self.tableSource[section];
    }
    return nil;
}

/// 移除一个section的数据
/// @param sectionData 对应的section数据
- (void)removeSectionData:(FYFListData *)sectionData {
    if (sectionData == nil) {
        return;
    }
    if (![self.tableSource containsObject:sectionData]) {
        return;
    }
    // removeObject:会删除所有的空数组元素当sectionData为空数组的时候，所以先获取index之后再删除
    NSUInteger index = [self.tableSource indexOfObjectPassingTest:^BOOL(FYFListData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj == sectionData;
    }];
    if (index >= 0 && index < self.tableSource.count) {
        [self.tableSource removeObjectAtIndex:index];
    }
}

/// 插入一个section的数据
/// @param sectionData 要插入的数据
/// @param section 要插入数据的位置
- (void)insertSectionData:(FYFListData *)sectionData atSection:(NSInteger)section {
    if (section < -1 || section >= self.tableSource.count || sectionData == nil) {
        return;
    }
    [self.tableSource insertObject:sectionData atIndex:section];
}

/// 获取一个section的数据源
/// @param sectionData 要查找的数据
- (NSInteger)indexOfSection:(FYFListData *)sectionData {
    if (sectionData == nil) {
        return NSNotFound;
    }
    return [self.tableSource indexOfObject:sectionData];
}

/// 移除所有的section
- (void)removeAllSections {
    [self.tableSource removeAllObjects];
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

#pragma mark- UITableViewDelegate

- (void)registerHeaderFooterWithModel:(id<FYFItemModelProtocol>)model table:(UITableView *)tableView inSection:(NSInteger)section {
    NSString *itemClassString = NSStringFromClass(model.itemClass);
    NSAssert(itemClassString, @"register table header or footer does not implement FYFItemModelProtocol!!!");
    if ([self.cacheRegisterCellDict valueForKey:itemClassString] == nil) {
        [tableView registerClass:model.itemClass forHeaderFooterViewReuseIdentifier:kGetHeaderFooterIDWithClass(model.itemClass)];
        [self.cacheRegisterCellDict setValue:model.itemClass forKey:itemClassString];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.headerModel;
    if (model == nil) {
        return nil;
    }
    // 注册view,内部会避免多次注册
    [self registerHeaderFooterWithModel:model table:tableView inSection:section];
    // 获取注册view
    UITableViewHeaderFooterView<TableHeaderFooterProtocol> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGetHeaderFooterIDWithClass(model.itemClass)];
    NSAssert(view, @"table header or footer class has not register!!!");
    view.table = tableView;
    view.section = section;
    view.model = model;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.footerModel;
    if (model == nil) {
        return nil;
    }
    
    // 注册view,内部会避免多次注册
    [self registerHeaderFooterWithModel:model table:tableView inSection:section];
    // 获取注册view
    UITableViewHeaderFooterView<TableHeaderFooterProtocol> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGetHeaderFooterIDWithClass(model.itemClass)];
    NSAssert(view, @"table header or footer class has not register!!!");
    view.table = tableView;
    view.section = section;
    view.model = model;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = [sectionData modelAtIndex:indexPath.row];
    NSAssert(model, @"Array out of bounds!!!");
    NSAssert(model.itemClass, @"Register cell does not implement CellModelProtocol!!!");
    
    // 缓存注册信息，避免相同model多次注册
    NSString *itemClassString = NSStringFromClass(model.itemClass);
    NSAssert(itemClassString, @"Register cell does not implement CellModelProtocol!!!");
    if ([self.cacheRegisterCellDict valueForKey:itemClassString] == nil) {
        if (self.notReuseCell) {
            [tableView registerClass:model.itemClass forCellReuseIdentifier:kGetCellIDWithClassAndIndex(model.itemClass, indexPath)];
        }else{
           [tableView registerClass:model.itemClass forCellReuseIdentifier:kGetCellIDWithClass(model.itemClass)];
            [self.cacheRegisterCellDict setValue:model.itemClass forKey:itemClassString];
        }
        
    }
    
    SEL heightMethod = @selector(estimatedHeightForCell:indexPath:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGFloat (*heightForCellFunc)(Class, SEL, id, id);
        heightForCellFunc func = (heightForCellFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, tableView, indexPath);
        }
    }
    return 44.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = [sectionData modelAtIndex:indexPath.row];
    NSAssert(model, @"Array out of bounds!!!");
    NSAssert(model.itemClass, @"Register cell does not implement CellModelProtocol!!!");
    
    SEL heightMethod = @selector(heightForCell:indexPath:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGFloat (*heightForCellFunc)(Class, SEL, id, id);
        heightForCellFunc func = (heightForCellFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, tableView, indexPath);
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.headerModel;
    if (model == nil) {
        return 0.0;
    }
    // 注册view,内部会避免多次注册
    [self registerHeaderFooterWithModel:model table:tableView inSection:section];
    // 获取高度
    SEL heightMethod = @selector(estimatedHeightForHeaderFooter:inSection:sectionType:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGFloat (*heightForHeaderFunc)(Class, SEL, id, NSInteger,TableSectionViewType);
        heightForHeaderFunc func = (heightForHeaderFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, tableView, section, TableSectionHeaderType);
        }
    }
    return 22.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.headerModel;
    if (model == nil) {
        return 0.0;
    }
    // 注册view,内部会避免多次注册
    [self registerHeaderFooterWithModel:model table:tableView inSection:section];
    // 获取高度
    SEL heightMethod = @selector(heightForHeaderFooter:inSection:sectionType:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGFloat (*heightForHeaderFunc)(Class, SEL, id, NSInteger,TableSectionViewType);
        heightForHeaderFunc func = (heightForHeaderFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, tableView, section, TableSectionHeaderType);
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.footerModel;
    if (model == nil) {
           return 0.0;
       }
    
    // 注册view,内部会避免多次注册
    [self registerHeaderFooterWithModel:model table:tableView inSection:section];
    
    // 获取高度
    SEL heightMethod = @selector(estimatedHeightForHeaderFooter:inSection:sectionType:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGFloat (*heightForHeaderFunc)(Class, SEL, id, NSInteger,TableSectionViewType);
        heightForHeaderFunc func = (heightForHeaderFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, tableView, section, TableSectionFooterType);
        }
    }
    return 22.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    FYFListData *sectionData = [self dataOfSection:section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = sectionData.footerModel;
    if (model == nil) {
           return 0.0;
       }
    
    // 注册view,内部会避免多次注册
    [self registerHeaderFooterWithModel:model table:tableView inSection:section];
    
    // 获取高度
    SEL heightMethod = @selector(heightForHeaderFooter:inSection:sectionType:);
    Method method =  class_getClassMethod(model.itemClass, heightMethod);
    if(nil != method){
        typedef CGFloat (*heightForHeaderFunc)(Class, SEL, id, NSInteger,TableSectionViewType);
        heightForHeaderFunc func = (heightForHeaderFunc)method_getImplementation(method);
        if (nil != func) {
            return func(model.itemClass, heightMethod, tableView, section, TableSectionFooterType);
        }
    }
    return UITableViewAutomaticDimension;
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableSource.count <= section || section < 0) {
        NSAssert(NO, @"Array out of bounds!!!");
        return 0;
    }
    FYFListData *sectionData = [self.tableSource objectAtIndex:section];
    return sectionData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    NSAssert(sectionData, @"Array out of bounds!!!");
    id<FYFItemModelProtocol> model = [sectionData modelAtIndex:indexPath.row];
    NSAssert(model, @"Array out of bounds!!!");
    
    // 缓存注册信息，避免相同model多次注册
    NSString *itemClassString = NSStringFromClass(model.itemClass);
    NSAssert(itemClassString, @"Register cell does not implement CellModelProtocol!!!");
    if ([self.cacheRegisterCellDict valueForKey:itemClassString] == nil) {
       if (self.notReuseCell) {
            [tableView registerClass:model.itemClass forCellReuseIdentifier:kGetCellIDWithClassAndIndex(model.itemClass, indexPath)];
        }else{
           [tableView registerClass:model.itemClass forCellReuseIdentifier:kGetCellIDWithClass(model.itemClass)];
            [self.cacheRegisterCellDict setValue:model.itemClass forKey:itemClassString];
        }
    }
    // 获取注册cell
    UITableViewCell<TableCellProtocol> *cell;
    if (self.notReuseCell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kGetCellIDWithClassAndIndex(model.itemClass, indexPath)];
    }else{
       cell = [tableView dequeueReusableCellWithIdentifier:kGetCellIDWithClass(model.itemClass)];
    }
    NSAssert(cell, @"cell class has not register!!!");
    
    cell.table = tableView;
    cell.indexPath = indexPath;
    cell.model = model;
    return cell;
}

#pragma mark- lazy

- (NSMutableArray *)tableSource {
    if (!_tableSource) {
        _tableSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableSource;
}
- (NSMutableDictionary *)cacheRegisterCellDict {
    if (!_cacheRegisterCellDict) {
        _cacheRegisterCellDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _cacheRegisterCellDict;
}
@end
