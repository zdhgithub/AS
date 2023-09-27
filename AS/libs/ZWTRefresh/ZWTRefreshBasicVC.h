//
//  ZWTRefreshBasicVC.h
//  DocumentLibrary
//
//  Created by 李名扬 on 2019/11/12.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoRefreshWithBlock)(NSInteger pageNo, BOOL isLoadMore);
typedef void(^RefreshCompletion)(void);

@interface ZWTRefreshBasicVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

/** 当前的页数 默认是:1*/
@property (nonatomic, assign) NSInteger pageNo;

/** 初始化刷新设置，block中返回pageNo:刷新页码，isLoadMore:YES 为上拉加载更多，NO为下拉刷新*/
- (void)setUpRefreshWithTableView:(UITableView *)table dataSource:(NSMutableArray *)dataSource refresh:(DoRefreshWithBlock)refreshBlock;

/** 主动刷新
    @params
        pageNo:刷新的当前数据页码
        totalNum:内容的总数
        msg:请求提示语
        isSuccess:请求是否成功，YES:成功; NO:失败
        items:请求是否成功，当前请求返回的list
 */
- (void)updatePageNo:(NSInteger)pageNo totalNum:(NSInteger)totalNum msg:(NSString *)msg isReqSuccess:(BOOL)isSuccess items:(NSArray *)items forceClean:(BOOL)isFore;
@end

