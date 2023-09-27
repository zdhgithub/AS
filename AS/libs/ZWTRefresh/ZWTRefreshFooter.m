//
//  ZWTRefreshFooter.m
//  ZWTUIKit
//
//  Created by 李名扬 on 2019/9/2.
//

#import "ZWTRefreshFooter.h"
//#import <ZWTUIKit.h>
#import "UIColor+XYColor.h"

@implementation ZWTRefreshFooter

+ (ZWTRefreshFooter *)zwt_footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    
   ZWTRefreshFooter *footer = [ZWTRefreshFooter footerWithRefreshingBlock:refreshingBlock];
    
    // Set title
//    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
//    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"tirar hacia arriba cargando" forState:MJRefreshStateIdle];
    [footer setTitle:@"loading..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"no más" forState:MJRefreshStateNoMoreData];

    // Set font
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    
//    // Set textColor
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    return footer;
}
@end
