/*
 #####################################################################
 # File    : FYFCollectionMiddleware.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FYFCollectionViewDataSource.h"
#import "FYFListData.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYFCollectionMiddleware : NSObject<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>


/** UITableViewDelegate delegate*/
@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;
/** FYFTableViewDataSource dataSource*/
// 这里的FYFTableViewDataSource移除掉了已经实现的部分、剩余部分代理自由发挥
@property (nonatomic, weak) id<FYFCollectionViewDataSource> dataSource;


@property (nonatomic, assign) NSInteger count;

/// 添加一个section的数据
/// @param sectionData section的数据
- (void)addSectionData:(FYFListData *)sectionData;


/// 获取一个section的数据
/// @param section section对应的位置
- (nullable FYFListData *)dataOfSection:(NSInteger)section;


/// 移除一个section的数据
/// @param sectionData 对应的section数据
- (void)removeSectionData:(FYFListData *)sectionData;


/// 插入一个section的数据
/// @param sectionData 要插入的数据
/// @param section 要插入数据的位置
- (void)insertSectionData:(FYFListData *)sectionData atSection:(NSInteger)section;


/// 移除所有的section
- (void)removeAllSections;


@end

NS_ASSUME_NONNULL_END
