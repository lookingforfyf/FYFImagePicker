#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FYFCollectionMiddleware.h"
#import "FYFCollectionViewDataSource.h"
#import "FYFGetCellClass.h"
#import "FYFItemModelProtocol.h"
#import "FYFListData.h"
#import "FYFTableCollectionMiddleWare.h"
#import "FYFTableMiddleware.h"
#import "FYFTableViewDataSource.h"
#import "UICollectionView+Middleware.h"
#import "UITableView+Middleware.h"

FOUNDATION_EXPORT double FYFTableCollectionMiddleWareVersionNumber;
FOUNDATION_EXPORT const unsigned char FYFTableCollectionMiddleWareVersionString[];

