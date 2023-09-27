//
//  ZWTRefreshBasicVC.m
//  DocumentLibrary
//
//  Created by 李名扬 on 2019/11/12.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

#import "ZWTRefreshBasicVC.h"
#import "ZWTRefreshFooter.h"
#import "ZWTRefreshHeader.h"
#import "ZWTProgressHUD.h"
#import "UIView+ZWTKit.h"
//#import "ZWTKitColorConfig.h"
#import "UIColor+XYColor.h"

@interface ZWTRefreshBasicVC ()
@property (nonatomic, copy) NSArray *filtters;
@property (nonatomic, copy) DoRefreshWithBlock refreshBlock;
@property (nonatomic, strong) UITableView *re_Table;
/** 是否有更多数据 默认是YES*/
@property (nonatomic, assign) BOOL re_isHaveMoreDatas;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *re_dataSource;
@end

@implementation ZWTRefreshBasicVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

/** 初始化刷新设置*/
- (void)setUpRefreshWithTableView:(UITableView *)table dataSource:(NSMutableArray *)dataSource refresh:(DoRefreshWithBlock)refreshBlock {
    
    NSAssert(dataSource && [dataSource isKindOfClass:[NSMutableArray class]], @"☠️☠️☠️ZWTRefreshBasicVC -传入的数据源格式错误！");
    NSAssert(table, @"☠️☠️☠️ZWTRefreshBasicVC -刷新的table为nil");
    NSAssert(refreshBlock, @"☠️☠️☠️ZWTRefreshBasicVC -刷新的refreshBlock为nil");

    self.refreshBlock = refreshBlock;
    self.re_dataSource = dataSource;
    self.re_Table = table;
    self.pageNo = 1;
    self.re_isHaveMoreDatas = YES;
    
//    [ZWTProgressHUD zwt_showLoadMessage:@""];
    
    
    self.re_Table.mj_header = [ZWTRefreshHeader zwt_headerWithRefreshingBlock:^{
        
        self.pageNo = 1;
        self.re_isHaveMoreDatas = YES;
        [self.re_Table.mj_footer resetNoMoreData];
        
        if (self.refreshBlock) {
            self.refreshBlock(self.pageNo,YES);
        }
    }];
        
    self.re_Table.mj_footer = [ZWTRefreshFooter zwt_footerWithRefreshingBlock:^{
        if (self.refreshBlock) {
            if(!self.re_isHaveMoreDatas || self.re_dataSource.count == 0) { return;}
            self.refreshBlock(self.pageNo,NO);
        }
    }];
    
    self.re_Table.mj_footer.hidden = self.re_dataSource.count == 0 ? YES : NO;
}

/** 主动刷新
    @params
        pageNo:刷新的当前数据页码
        totalNum:内容的总数
        msg:请求提示语
        isSuccess:请求是否成功，YES:成功; NO:失败
 */
- (void)updatePageNo:(NSInteger)pageNo totalNum:(NSInteger)totalNum msg:(NSString *)msg isReqSuccess:(BOOL)isSuccess items:(NSArray *)items forceClean:(BOOL)isFore {
    
    msg = msg ? : @"";
    items = items ? : @[];
    
    if (isFore) {
        [self.re_dataSource removeAllObjects];
    }
    
    [ZWTProgressHUD zwt_hideLoadHUD];
    //关闭加载状态
    ZWTRefreshHeader *header = (ZWTRefreshHeader *)self.re_Table.mj_header;
    [header zwt_endRefreshing];
    [self.re_Table.mj_footer endRefreshing];
    
    if (isSuccess) {
        
        if (self.pageNo == 1) {
            [self.re_dataSource removeAllObjects];
        }
        
        if (items.count != 0) {
            
            self.pageNo++;
            [self.re_dataSource addObjectsFromArray:items];
            //判断是否还有更多数据
            if(self.re_dataSource.count >= totalNum) {
                self.re_isHaveMoreDatas = NO;
                [self.re_Table.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [UIView performWithoutAnimation:^{
            [self.re_Table reloadData];
        }];
    } else {
        [ZWTProgressHUD zwt_showErrorMessage:msg];
    }
    
    if (self.re_dataSource.count == 0) {
        [self.re_Table zwt_showDataEmptyView:ZWTViewDataEmpty_Data frame:self.re_Table.frame];
        self.re_Table.backgroundColor = UIColor.whiteColor;
        self.re_Table.mj_footer.hidden = YES;
    } else {
        [self.re_Table zwt_hideDataEmptyView];
        self.re_Table.backgroundColor = [UIColor colorWithHexString:@"#F7F8F9"];
        self.re_Table.mj_footer.hidden = NO;
    }
}
@end
