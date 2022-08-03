/*
 #####################################################################
 # File    : UITableView+Middleware.h
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

#import <UIKit/UIKit.h>
#import "FYFTableMiddleware.h"

NS_ASSUME_NONNULL_BEGIN


@interface UITableView (Middleware)

/** UIKSTableViewDelegate delegate*/
@property (nonatomic, weak, readonly) id<UITableViewDelegate> originDelegate;
/** FYFTableViewDataSource dataSource*/
@property (nonatomic, weak, readonly) id<FYFTableViewDataSource> originDataSource;
///  是否重用cell
@property (nonatomic, assign) BOOL notReuseCell;

/// 初始化 一个frame为Zero，样式为 UITableViewStylePlain 的tableView并设置代理
/// @param delegate tableview代理、数据源代理
- (instancetype)initWithDelegate:(id<UITableViewDelegate,FYFTableViewDataSource>)delegate;

/// 初始化 一个frame为Zero，样式为 UITableViewStylePlain 的tableView并设置代理
/// @param delegate tableview代理
/// @param dataSource tableView数据源代理
- (instancetype)initWithDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource;

/// 初始化 一个frame为Zero的tableView并设置代理
/// @param style tableview样式
/// @param delegate tableview代理
/// @param dataSource tableView数据源代理
- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource;

/// 初始化tableView并设置代理
/// @param frame tableView的frame
/// @param style tableview样式
/// @param delegate tableview代理
/// @param dataSource tableView数据源代理
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource;

/// 绑定代理给middleware同时保留其真实的代理
/// @param delegate 代理对象
/// @param dataSource 数据源代理对象
- (void)bindMiddlewareWithDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<FYFTableViewDataSource>)dataSource;

/// 添加一个Section数据源
/// @param sectionData section数据
- (void)addSectionData:(FYFListData *)sectionData;

/// 添加多个section的数据
/// @param sectionData section的数据
- (void)addSectionDatas:(NSArray<FYFListData*>*)sectionDatas;

/// 添加一组数据到最后一个section
/// @param dataArray 要添加的数组
- (void)appendModelsToLastSection:(NSArray<id<FYFItemModelProtocol>> *)dataArray;

/// 添加一组数据到最后一个section
/// @param dataArray 要添加的数组
/// @param section 对应的section
- (void)appendModels:(NSArray<id<FYFItemModelProtocol>> *)dataArray atSection:(NSInteger)section;

/// 获取一个section的数据
/// @param section section对应的位置
- (nullable FYFListData *)dataOfSection:(NSInteger)section;

/// 获取一条数据model
/// @param indexPath 所在位置
- (nullable id<FYFItemModelProtocol>)dataOfIndexPath:(NSIndexPath *)indexPath;

/// 插入一个section的数据
/// @param sectionData 要插入的数据
/// @param section 要插入数据的位置
- (void)insertSectionData:(FYFListData *)sectionData atSection:(NSInteger)section;

/// 移除一个section的数据
/// @param sectionData 对应的section数据
- (void)removeSectionData:(FYFListData *)sectionData;

/// 移除对应的row
/// @param indexPath row所在的IndexPath
- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath;

/// 获取section所在的位置 找不到返回NSNotFound
/// @param sectionData section的数据源
- (NSInteger)indexOfSection:(FYFListData *)sectionData;

/// 获取列表section的数目
- (NSInteger)sectionsCount;

/// 清空所有数据源
- (void)clear;

@end

NS_ASSUME_NONNULL_END
