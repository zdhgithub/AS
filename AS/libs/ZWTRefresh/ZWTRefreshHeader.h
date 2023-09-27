//
//  ZWTRefreshHeader.h
//  ZWTUIKit
//
//  Created by 李名扬 on 2019/9/2.
//

//#import "MJRefreshGifHeader.h"
//#import "MJRefresh.h"
@import MJRefresh;

NS_ASSUME_NONNULL_BEGIN

@interface ZWTRefreshHeader : MJRefreshGifHeader

+ (ZWTRefreshHeader *)zwt_headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

- (void)zwt_endRefreshing;
@end

NS_ASSUME_NONNULL_END
