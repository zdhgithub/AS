//
//  ZWTRefreshFooter.h
//  ZWTUIKit
//
//  Created by 李名扬 on 2019/9/2.
//

//#import <MJRefreshAutoNormalFooter.h>
@import MJRefresh;

NS_ASSUME_NONNULL_BEGIN

@interface ZWTRefreshFooter : MJRefreshAutoNormalFooter

+ (ZWTRefreshFooter *)zwt_footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end

NS_ASSUME_NONNULL_END
