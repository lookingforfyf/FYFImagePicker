/*
 #####################################################################
 # File    : FYFItemModelProtocol.h
 # Project : FYFTableCollectionMiddleWare
 # Created : 2021/8/13 1:52 PM
 # DevTeam : fanyunfei Development Team
 # Author  : fanyunfei
 # Notes   : cell关联model协议,cell协议
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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TableSectionViewType) {
    TableSectionHeaderType = 0,
    TableSectionFooterType,
};

@protocol FYFItemModelProtocol <NSObject>

@property (nonatomic) Class itemClass;

@end

@protocol TableCellProtocol <NSObject>

@property (nonatomic, weak) UITableView *table;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<FYFItemModelProtocol> model;

@optional
+ (CGFloat)estimatedHeightForCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (CGFloat)heightForCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end


@protocol TableHeaderFooterProtocol <NSObject>

@property (nonatomic, weak) UITableView *table;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id<FYFItemModelProtocol> model;

@optional
+ (CGFloat)estimatedHeightForHeaderFooter:(UITableView *)tableView inSection:(NSInteger)section sectionType:(TableSectionViewType)sectionType;
+ (CGFloat)heightForHeaderFooter:(UITableView *)tableView inSection:(NSInteger)section sectionType:(TableSectionViewType)sectionType;
@end


@protocol CollectionItemProtocol <NSObject>

@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<FYFItemModelProtocol> model;


+ (CGSize)sizeForItem:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

@protocol CollectionHeaderFooterProtocol <NSObject>

@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<FYFItemModelProtocol> model;

+ (CGSize)sizeForHeaderFooter:(UICollectionView *)collectionView kind:(NSString *)kind section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
