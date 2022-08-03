/*
 #####################################################################
 # File    : UITableView+Middleware.m
 # Project : FYFTableCollectionMiddleWare
 # Created : 2021/8/13 1:52 PM
 # DevTeam : fanyunfei Development Team
 # Author  : fanyunfei
 # Notes   : 为tableView添加方法
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

#import "UITableView+Middleware.h"
#import <objc/runtime.h>

@interface UITableView ()
/** 私有属性 请勿直接操作此对象 */
@property (nonatomic, strong) FYFTableMiddleware *tableMiddleware;

@end

@implementation UITableView (Middleware)

// 关联属性中间件
static void *FYFTableMiddlewareKey = (void *)@"tableMiddlewareKey";
-(FYFTableMiddleware *)tableMiddleware {
    return objc_getAssociatedObject(self, FYFTableMiddlewareKey);
}
-(void)setTableMiddleware:(FYFTableMiddleware *)fyfTableMiddleware {
    objc_setAssociatedObject(self, FYFTableMiddlewareKey, fyfTableMiddleware, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 关联属性中间件
static void *kNotReuseCellKey = (void *)@"notReuseCellKey";
-(BOOL)notReuseCell {
    return [objc_getAssociatedObject(self, kNotReuseCellKey) boolValue];
}
-(void)setNotReuseCell:(BOOL)notReuseCell {
    objc_setAssociatedObject(self, kNotReuseCellKey, @(notReuseCell), OBJC_ASSOCIATION_ASSIGN);
    self.tableMiddleware.notReuseCell = notReuseCell;
}

- (id<UITableViewDelegate>)originDelegate {
    return self.tableMiddleware.delegate;
}
- (id<FYFTableViewDataSource>)originDataSource {
    return self.tableMiddleware.dataSource;
}
#pragma mark- custom func


/// 初始化 一个frame为Zero，样式为 UITableViewStylePlain 的tableView并设置代理
/// @param delegate tableview代理、数据源代理
- (instancetype)initWithDelegate:(id<UITableViewDelegate,FYFTableViewDataSource>)delegate {
    return [self initWithFrame:CGRectZero style:UITableViewStylePlain delegate:delegate dataSource:delegate];
}


/// 初始化 一个frame为Zero，样式为 UITableViewStylePlain 的tableView并设置代理
/// @param delegate tableview代理
/// @param dataSource tableView数据源代理
- (instancetype)initWithDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource {
    return [self initWithFrame:CGRectZero style:UITableViewStylePlain delegate:delegate dataSource:dataSource];
}


/// 初始化 一个frame为Zero的tableView并设置代理
/// @param style tableview样式
/// @param delegate tableview代理
/// @param dataSource tableView数据源代理
- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource {
    return [self initWithFrame:CGRectZero style:style delegate:delegate dataSource:dataSource];
}


/// 初始化tableView并设置代理
/// @param frame tableView的frame
/// @param style tableview样式
/// @param delegate tableview代理
/// @param dataSource tableView数据源代理
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource {
    self = [self initWithFrame:frame style:style];
    [self bindMiddlewareWithDelegate:delegate dataSource:dataSource];
    return self;
}
/// 绑定代理给middleware同时保留其真实的代理
/// @param delegate 代理对象
/// @param dataSource 数据源代理对象
- (void)bindMiddlewareWithDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource {
    // 每一个tableview都有一个自己管理的数据源
    self.tableMiddleware = [FYFTableMiddleware new];
    self.tableMiddleware.delegate = delegate;
    self.tableMiddleware.dataSource = dataSource;
    self.delegate = self.tableMiddleware;
    self.dataSource = self.tableMiddleware;
    // 项目的分割线线都是由自己去绘制
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 项目使用系统的高度自适应方法
    self.estimatedRowHeight = 44.0;
    self.estimatedSectionHeaderHeight = 22.0;
    self.estimatedSectionFooterHeight = 22.0;
    self.rowHeight = UITableViewAutomaticDimension;
    self.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.sectionFooterHeight = UITableViewAutomaticDimension;
    //调整listView在iOS11上出现返回上一级页面不平滑情况  ai.chen 2017-12-19
    if (@available(iOS 11.0,*)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark- 数据源操作

/// 添加一个section数据
/// @param sectionData section数据
- (void)addSectionData:(FYFListData *)sectionData {
    [self.tableMiddleware addSectionData:sectionData];
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
    if (self.tableMiddleware.count <= 0) {
        sectionData = [FYFListData listData];
        [self.tableMiddleware addSectionData:sectionData];
    }else {
       sectionData = [self.tableMiddleware dataOfSection:self.tableMiddleware.count - 1];
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
    if (section >= self.tableMiddleware.count || section < 0 || dataArray == nil) {
        return;
    }
    FYFListData *sectionData = [self.tableMiddleware dataOfSection:section];
    if (sectionData == nil) {
        return;
    }
    [sectionData appendModels:dataArray];
}

/// 获取一个section的数据
/// @param section section对应的位置
- (nullable FYFListData *)dataOfSection:(NSInteger)section {
    if (section >= self.tableMiddleware.count || section < 0) {
        return nil;
    }
    return [self.tableMiddleware dataOfSection:section];
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
    [self.tableMiddleware insertSectionData:sectionData atSection:section];
}

/// 移除一个section的数据
/// @param sectionData 对应的section数据
- (void)removeSectionData:(FYFListData *)sectionData {
    [self.tableMiddleware removeSectionData:sectionData];
}

/// 移除对应的row
/// @param indexPath row所在的IndexPath
- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath {
    FYFListData *sectionData = [self dataOfSection:indexPath.section];
    if (sectionData && sectionData.count > indexPath.row) {
        [sectionData removeModelAtIndex:indexPath.row];
    }
}

/// 获取section所在的位置 找不到返回NSNotFound
/// @param sectionData section的数据源
- (NSInteger)indexOfSection:(FYFListData *)sectionData {
    return [self.tableMiddleware indexOfSection:sectionData];
}
/// 获取列表section的数目
- (NSInteger)sectionsCount {
    return self.tableMiddleware.count;
}

/// 清空所有数据源
- (void)clear {
    [self.tableMiddleware removeAllSections];
}
@end
