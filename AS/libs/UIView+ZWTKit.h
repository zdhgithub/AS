//
//  UIView+ZWTKit.h
//  UIKitModule
//
//  Created by 曹志君 on 2018/11/21.
//  Copyright © 2018 coson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWTBaseDataEmptyView : UIView
@end

@interface UIView (ZWTKit)
    
@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;
    
@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;
    
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;
    
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
    
@property (nonatomic) CGFloat frameCenterX;
@property (nonatomic) CGFloat frameCenterY;
    
#pragma mark - contains
    /**
     * 判断指定View是否存在于当前视图中
     * @param subView 需判断的视图
     */
- (BOOL)zwt_containsSubView:(UIView *)subView;
    /**
     * 判断子视图是否存在指定类型
     * @param subClass 需判断的类型
     */
- (BOOL)zwt_containsSubViewOfClassType:(Class)subClass;
    
#pragma mark - corner
    /**
     * 设置四边圆角
     * @param radius 圆角半径
     */
- (void)zwt_setCornerRadius:(CGFloat)radius;
    /**
     * 设置视图圆角 (默认圆角8px)
     * @param rectCorner 圆角位置
     */
- (void)zwt_setCornerByRoundingCorners:(UIRectCorner)rectCorner;
    /**
     * 设置视图圆角
     * @param rectCorner 圆角位置
     * @param cornerRadii 圆角半径
     */
- (void)zwt_setCornerByRoundingCorners:(UIRectCorner)rectCorner
                           cornerRadii:(CGSize)cornerRadii;

- (void)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
    
#pragma mark - Line
    /**
     *  在View上绘制线条
     *  [color默认18,18,18 | width默认1px]
     *  @param edge 边缘
     */
- (void)zwt_drawLine:(UIRectEdge)edge;
    /**
     *  在View上绘制线条
     *  @param edge 边缘
     *  @param width 线条宽度
     *  @param color 线条颜色
     */
- (void)zwt_drawLine:(UIRectEdge)edge
               width:(CGFloat)width
               color:(UIColor *)color;
    
    @end

#pragma mark - 缺省页

typedef NS_ENUM(NSUInteger, ZWTViewDataEmptyType) {
    /** 无数据 (默认模式，UI还在进行设计确认过程，所以仅定义五种状态)*/
    ZWTViewDataEmpty_Data,
    /** 页面地址错误 */
    ZWTViewDataEmpty_Url,
    /** 无搜索结果 */
    ZWTViewDataEmpty_Search,
    /** 网络异常 */
    ZWTViewDataEmpty_Network,
    /** 点击重新加载 */
    ZWTViewDataError_Reload
};

/** 缺省页的Category */
@interface UIView (ZWTDataEmpty)
    
@property (nonatomic, readonly) BOOL isShowDataEmptyView;//是否显示缺省图

@property (nonatomic, strong, readonly) ZWTBaseDataEmptyView *dataEmptyView;
    
    /** 展示默认缺省页 */
- (void)zwt_showDefaultDataEmptyView;
    /** 根据类型展示缺省页 */
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType;
    /** 根据类型展示缺省页 传入frame*/
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame;
    /** 根据类型展示缺省页 传入frame 点击回调*/
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock;
    
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock backHomeBlock:(void(^)(void))backHomeBlock;
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame title:(NSString *)title image:(UIImage *)image reloadBlock:(void(^)(void))reloadBlock;
    
    /** 根据类型展示缺省页 自定义EmptyView的背景色*/
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType backgroundColor:(UIColor *)color;
    /** 隐藏缺省页 */
- (void)zwt_hideDataEmptyView;
    
#pragma mark - 自定义title及图片
    /** 展示自定义缺省页
     *  值为nil时展示为ZWTViewDataEmpty_Data
     */
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title;
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title font:(UIFont *)font frame:(CGRect)frame;
    
    /** 展示自定义缺省页
     *  值为nil时展示为ZWTViewDataEmpty_Data
     */
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title reloadBlock:(void(^)(void))reloadBlock;
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title reloadBlock:(void(^)(void))reloadBlock backHomeBlock:(void(^)(void))backHomeBlock;
    
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title frame:(CGRect)frame;
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock;
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock backHomeBlock:(void(^)(void))backHomeBlock;
    

//- (void)addGradientLayerWithCornerRadius:(float)cornerRadius lineWidth:(float)lineWidth colors:(NSArray *)colors;
//
//- (void)addGradientLayerWithCornerRadius:(float)cornerRadius lineWidth:(float)lineWidth colors:(NSArray *)colors size:(CGSize)size;
    
@end
