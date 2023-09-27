//
//  UIView+ZWTKit.m
//  UIKitModule
//
//  Created by 曹志君 on 2018/11/21.
//  Copyright © 2018 coson. All rights reserved.
//

#import "UIView+ZWTKit.h"
#import "UIColor+XYColor.h"
//#import "ZWTKitConfig.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "UIImage+ZWTKit.h"

@implementation UIView (ZWTKit)
    
- (CGPoint)frameOrigin {
    return self.frame.origin;
}
    
- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}
    
- (CGSize)frameSize {
    return self.frame.size;
}
    
- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}
    
- (CGFloat)frameX {
    return self.frame.origin.x;
}
    
- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}
    
- (CGFloat)frameY {
    return self.frame.origin.y;
}
    
- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}
    
- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}
    
- (void)setFrameRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}
    
- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}
    
- (void)setFrameBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}
    
- (CGFloat)frameWidth {
    return self.frame.size.width;
}
    
- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newWidth, self.frame.size.height);
}
    
- (CGFloat)frameHeight {
    return self.frame.size.height;
}
    
- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}
    
- (CGFloat)frameCenterX {
    return self.center.x;
}
    
- (void)setFrameCenterX:(CGFloat)frameCenterX {
    CGPoint center = self.center;
    center.x = frameCenterX;
    self.center = center;
}
    
- (CGFloat)frameCenterY {
    return self.center.y;
}
    
- (void)setFrameCenterY:(CGFloat)frameCenterY {
    CGPoint center = self.center;
    center.y = frameCenterY;
    self.center = center;
}
    
#pragma mark - Extension Function
#pragma mark - contains
    /**
     * 判断指定View是否存在于当前视图中
     * @param subView 需判断的视图
     */
- (BOOL)zwt_containsSubView:(UIView *)subView {
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}
    /**
     * 判断子视图是否存在指定类型
     * @param subClass 需判断的类型
     */
- (BOOL)zwt_containsSubViewOfClassType:(Class)subClass {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:subClass]) {
            return YES;
        }
    }
    return NO;
}
    
#pragma mark - corner
    /**
     * 设置四边圆角
     * @param radius 圆角半径
     */
- (void)zwt_setCornerRadius:(CGFloat)radius {
    [self.layer setCornerRadius:radius];
}
    
    /**
     * 设置视图圆角 (默认圆角8px)
     * @param rectCorner 圆角位置
     */
- (void)zwt_setCornerByRoundingCorners:(UIRectCorner)rectCorner {
    [self zwt_setCornerByRoundingCorners:rectCorner cornerRadii:CGSizeMake(8.0f, 8.0f)];
}
    
    /**
     * 设置视图圆角
     * @param rectCorner 圆角位置
     * @param cornerRadii 圆角半径
     */
- (void)zwt_setCornerByRoundingCorners:(UIRectCorner)rectCorner
                           cornerRadii:(CGSize)cornerRadii {
    //指定某个角变为圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    if (rect.size.width == 0 || rect.size.height == 0) return;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
//    });
}
    
#pragma mark - Line
    /**
     *  在View上绘制线条
     *  [color默认18,18,18 | width默认1px]
     *  @param edge 边缘
     */
- (void)zwt_drawLine:(UIRectEdge)edge {
    [self zwt_drawLine:edge width:1.0 color:[UIColor colorWithRed:18.0f/255.0 green:18.0f/255.0 blue:18.0f/255.0 alpha:1.0f]];
}
    /**
     *  在View上绘制线条
     *  @param edge 边缘
     *  @param width 线条宽度
     *  @param color 线条颜色
     */
- (void)zwt_drawLine:(UIRectEdge)edge
               width:(CGFloat)width
               color:(UIColor *)color {
    NSMutableArray *rectList = [NSMutableArray array];
    if(edge & UIRectEdgeTop) {//包含头部
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, self.frameWidth, width)]];
    }
    if(edge & UIRectEdgeBottom) {//包含底部
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(0.0f, self.frameHeight - width, self.frameWidth, width)]];
    }
    if(edge & UIRectEdgeLeft) {//包含左
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(0.0f, 0.0f, width,self.frameHeight)]];
    }
    if(edge & UIRectEdgeRight) {//包含右
        [rectList addObject:[NSValue valueWithCGRect:CGRectMake(self.frameWidth-width, 0.0f, width,self.frameHeight)]];
    }
    
    //绘制
    for (NSValue *rectValue in rectList) {
        CGRect rect = [rectValue CGRectValue];
        CALayer *layer = [CALayer layer];
        layer.frame = rect;
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    
}
    

- (void)addGradientLayerWithCornerRadius:(float)cornerRadius lineWidth:(float)lineWidth colors:(NSArray *)colors {
    [self addGradientLayerWithCornerRadius:cornerRadius lineWidth:lineWidth colors:colors size:self.frame.size];
}

- (void)addGradientLayerWithCornerRadius:(float)cornerRadius lineWidth:(float)lineWidth colors:(NSArray *)colors size:(CGSize)size {
    
    CGRect mapRect = CGRectMake(lineWidth/2, lineWidth/2, size.width-lineWidth, size.height-lineWidth);
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.cornerRadius = mapRect.size.height/2;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.lineWidth = lineWidth;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:mapRect cornerRadius:mapRect.size.height/2];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor blueColor].CGColor;
    
    gradientLayer.mask = maskLayer;
    [self.layer addSublayer:gradientLayer];
}


    @end

#pragma mark -
#pragma mark - DataEmpty Class & Category

@interface ZWTBaseDataEmptyItemView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *backHomeButton;

@property (nonatomic, copy) void(^refreshBlock)(void);
@property (nonatomic, copy) void(^backHomeBlock)(void);

@end

@implementation ZWTBaseDataEmptyItemView
    
- (UIImageView *)imgView
    {
        if (_imgView==nil) {
            _imgView = [UIImageView new];
            _imgView.contentMode = UIViewContentModeScaleAspectFit;
        }
        return _imgView;
    }
    
- (UILabel *)descLabel
    {
        if (_descLabel==nil) {
            _descLabel = [UILabel new];
            _descLabel.textColor = [UIColor colorWithHex:0x999999];
            _descLabel.font = [UIFont systemFontOfSize:13];
            _descLabel.numberOfLines = 0;
            _descLabel.textAlignment = NSTextAlignmentCenter;
        }
        return _descLabel;
    }
    
- (UIButton *)backHomeButton
    {
        if (_backHomeButton==nil) {
            _backHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _backHomeButton.layer.cornerRadius = 3;
            _backHomeButton.clipsToBounds = YES;
            [_backHomeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x125AB0]] forState:UIControlStateNormal];
            [_backHomeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x125AB0]] forState:UIControlStateHighlighted];
            [_backHomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        return _backHomeButton;
    }
    
- (UIButton *)refreshButton
    {
        if (_refreshButton==nil) {
            _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _refreshButton.layer.cornerRadius = 3;
            _refreshButton.clipsToBounds = YES;
            [_refreshButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
            _refreshButton.layer.borderWidth = 1;
            _refreshButton.layer.borderColor = [UIColor colorWithHex:0x0e0e0e].CGColor;
        }
        return _refreshButton;
    }
    
- (instancetype)initWithFrame:(CGRect)frame dataEmptyType:(ZWTViewDataEmptyType)dataEmptyType;
    {
        self = [super initWithFrame:frame];
        if (self) {
            [self addSubview:self.imgView];
            [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.width.height.mas_equalTo(110);
                make.centerX.mas_equalTo(self);
            }];
            
            [self addSubview:self.descLabel];
            [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.imgView.mas_bottom).mas_offset(0);
                make.centerX.mas_equalTo(self);
            }];
            
            if (dataEmptyType==ZWTViewDataEmpty_Url) {
                [self addSubview:self.backHomeButton];
                [self.backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(32);
                    make.height.mas_equalTo(44);
                    make.width.mas_equalTo(116);
                    make.centerX.mas_equalTo(self);
                }];
                
                [self addSubview:self.refreshButton];
                [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.backHomeButton.mas_bottom).mas_offset(20);
                    make.height.mas_equalTo(44);
                    make.width.mas_equalTo(116);
                    make.centerX.mas_equalTo(self);
                    make.bottom.mas_equalTo(0);
                }];
                [self.backHomeButton setTitle:@"back to home" forState:UIControlStateNormal];
                [self.refreshButton setTitle:@"reload" forState:UIControlStateNormal];
                [self.backHomeButton addTarget:self action:@selector(backHomeClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.refreshButton addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
            } else if (dataEmptyType==ZWTViewDataError_Reload||dataEmptyType==ZWTViewDataEmpty_Network) {
                [self addSubview:self.backHomeButton];
                [self.backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.descLabel.mas_bottom).mas_offset(32);
                    make.height.mas_equalTo(44);
                    make.width.mas_equalTo(116);
                    make.centerX.mas_equalTo(self);
                    make.bottom.mas_equalTo(0);
                }];
                [self.backHomeButton setTitle:@"refresh" forState:UIControlStateNormal];
                [self.backHomeButton addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }
        }
        return self;
    }
    
- (void)refreshClick:(UIButton *)btn
    {
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }
    
- (void)backHomeClick:(UIButton *)btn
    {
        if (self.backHomeBlock) {
            self.backHomeBlock();
        }
    }
    
    
    @end

@interface ZWTBaseDataEmptyView ()
    
@property (nonatomic, strong) ZWTBaseDataEmptyItemView *itemView;

@end

@implementation ZWTBaseDataEmptyView
    
- (instancetype)initWithFrame:(CGRect)frame dataEmptyType:(ZWTViewDataEmptyType)dataEmptyType {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.itemView = [[ZWTBaseDataEmptyItemView alloc] initWithFrame:CGRectZero dataEmptyType:dataEmptyType];
        [self addSubview:self.itemView];
        [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self).multipliedBy(0.8);
        }];
        [self setShowDataSource:dataEmptyType];
    }
    return self;
}
    
- (void) setShowDataSource:(ZWTViewDataEmptyType)dataEmptyType {
    
    NSString *imageName = nil;
    NSString *remindStr = nil;
    switch (dataEmptyType) {
        case ZWTViewDataEmpty_Data:
        imageName = @"common_def_content_nor";
        remindStr = @"no data";
        break;
        case ZWTViewDataEmpty_Url:
        imageName = @"borrow_def_file_error";
        remindStr = @"Page is temporarily inaccessible, working on fixing";
        break;
        case ZWTViewDataEmpty_Search:
        imageName = @"common_def_search_error";
        remindStr = @"no data";
        break;
        case ZWTViewDataEmpty_Network:
        imageName = @"common_def_network_error";
        remindStr = @"Uh-oh ~ no network";
        break;
        case ZWTViewDataError_Reload:
        imageName = @"common_def_network_error";
        remindStr = @"Network exception, please re-request";
        break;
        default:{
            imageName = @"common_def_content_nor";
            remindStr = @"no data";
        }
        break;
    }
    [self.itemView.imgView setImage:[UIImage imageNamed:@"imageName"]];
    [self.itemView.descLabel setText:remindStr];
}
    
    @end


static const void *ZWTDataEmptyViewKey = &ZWTDataEmptyViewKey;
@implementation UIView (ZWTDataEmpty)
    
    
    /** 展示默认缺省页 */
- (void)zwt_showDefaultDataEmptyView {
    [self zwt_showDataEmptyView:ZWTViewDataEmpty_Data];
}
    
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType
                setFrameBlock:(void(^)(void))setFrameBlock
    {
        [self zwt_hideDataEmptyView];
        if (!self.dataEmptyView) {
            self.dataEmptyView = [[ZWTBaseDataEmptyView alloc] initWithFrame:CGRectZero dataEmptyType:dataEmptyType];
            [self addSubview:self.dataEmptyView];
            if (setFrameBlock) {
                setFrameBlock();
            }
        }
    }
    
    /** 根据类型展示缺省页 */
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType {
    [self zwt_showDataEmptyView:dataEmptyType setFrameBlock:^{
        [self.dataEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.height.mas_equalTo(self);
        }];
    }];
}
    
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame
    {
        [self zwt_showDataEmptyView:dataEmptyType setFrameBlock:^{
            self.dataEmptyView.frame = frame;
        }];
        
    }
    
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock {
    [self zwt_showDataEmptyView:dataEmptyType setFrameBlock:^{
        self.dataEmptyView.frame = frame;
    }];
    self.dataEmptyView.itemView.refreshBlock = reloadBlock;
}

- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame title:(NSString *)title image:(UIImage *)image reloadBlock:(void(^)(void))reloadBlock {
    [self zwt_showDataEmptyView:dataEmptyType setFrameBlock:^{
        self.dataEmptyView.frame = frame;
    }];
    self.dataEmptyView.itemView.refreshBlock = reloadBlock;
    self.dataEmptyView.itemView.imgView.image = image;
    self.dataEmptyView.itemView.descLabel.text = title;
}
    
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock backHomeBlock:(void(^)(void))backHomeBlock
    {
        [self zwt_showDataEmptyView:dataEmptyType setFrameBlock:^{
            self.dataEmptyView.frame = frame;
        }];
        self.dataEmptyView.itemView.refreshBlock = reloadBlock;
        self.dataEmptyView.itemView.backHomeBlock = backHomeBlock;
    }
    
    /** 根据类型展示缺省页 自定义EmptyView的背景色*/
- (void)zwt_showDataEmptyView:(ZWTViewDataEmptyType)dataEmptyType backgroundColor:(UIColor *)color {
    [self zwt_showDataEmptyView:dataEmptyType];
    [self.dataEmptyView setBackgroundColor:color];
}
    
    /** 隐藏缺省页 */
- (void)zwt_hideDataEmptyView {
    if(self.dataEmptyView) {
        [self.dataEmptyView removeFromSuperview];
        self.dataEmptyView = nil;
    }
}
    
#pragma mark - 自定义title及图片
    /** 展示自定义缺省页
     *  值为nil时展示为ZWTViewDataEmpty_Data
     */
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image
                               title:(NSString *)title {
    [self zwt_showDefaultDataEmptyView:image title:title reloadBlock:nil];
}

- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title font:(UIFont *)font frame:(CGRect)frame {
    [self zwt_showDefaultDataEmptyView:image title:title font:font frame:frame reloadBlock:nil];
}
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image
                               title:(NSString *)title
                                font:(UIFont *)font
                               frame:(CGRect)frame
                         reloadBlock:(void(^)(void))reloadBlock {
    
        [self zwt_showDataEmptyView:ZWTViewDataEmpty_Data setFrameBlock:^{
            self.dataEmptyView.frame = frame;
        }];
    
//        [self zwt_showDataEmptyView:ZWTViewDataEmpty_Data setFrameBlock:^{
//            [self.dataEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.top.equalTo(@(0));
//                make.width.height.mas_equalTo(self);
//            }];
//        }];
    
   
    self.dataEmptyView.itemView.refreshBlock = reloadBlock;
    
    if(image) {
        [self.dataEmptyView.itemView.imgView setImage:image];
    }
    
    if(title) {
        [self.dataEmptyView.itemView.descLabel setText:title];
    }
    if (font) {
        [self.dataEmptyView.itemView.descLabel setFont:font];
    }
}
    /** 展示自定义缺省页
     *  值为nil时展示为ZWTViewDataEmpty_Data
     */
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image
                               title:(NSString *)title
                         reloadBlock:(void(^)(void))reloadBlock {
    [self zwt_showDataEmptyView:ZWTViewDataEmpty_Data setFrameBlock:^{
        [self.dataEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(0));
            make.width.height.mas_equalTo(self);
        }];
    }];
    self.dataEmptyView.itemView.refreshBlock = reloadBlock;
    
    if(image) {
        [self.dataEmptyView.itemView.imgView setImage:image];
    }
    
    if(title) {
        [self.dataEmptyView.itemView.descLabel setText:title];
    }
}
    
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title reloadBlock:(void(^)(void))reloadBlock backHomeBlock:(void(^)(void))backHomeBlock
    {
        [self zwt_showDataEmptyView:ZWTViewDataEmpty_Data setFrameBlock:^{
            [self.dataEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(@(0));
                make.width.height.mas_equalTo(self);
            }];
        }];
        self.dataEmptyView.itemView.refreshBlock = reloadBlock;
        self.dataEmptyView.itemView.backHomeBlock = backHomeBlock;
        if(image) {
            [self.dataEmptyView.itemView.imgView setImage:image];
        }
        
        if(title) {
            [self.dataEmptyView.itemView.descLabel setText:title];
        }
    }
    
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title frame:(CGRect)frame
    {
        [self zwt_showDefaultDataEmptyView:image title:title frame:frame reloadBlock:nil backHomeBlock:nil];
    }
    
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock
    {
        [self zwt_showDefaultDataEmptyView:image title:title frame:frame reloadBlock:reloadBlock backHomeBlock:nil];
    }
    
- (void)zwt_showDefaultDataEmptyView:(UIImage *)image title:(NSString *)title frame:(CGRect)frame reloadBlock:(void(^)(void))reloadBlock backHomeBlock:(void(^)(void))backHomeBlock
    {
        [self zwt_showDataEmptyView:ZWTViewDataEmpty_Data setFrameBlock:^{
            self.dataEmptyView.frame = frame;
        }];
        self.dataEmptyView.itemView.refreshBlock = reloadBlock;
        self.dataEmptyView.itemView.backHomeBlock = backHomeBlock;
        if(image) {
            [self.dataEmptyView.itemView.imgView setImage:image];
        }
        if(title) {
            [self.dataEmptyView.itemView.descLabel setText:title];
        }
    }
    
    
#pragma mark - private
- (void)setDataEmptyView:(ZWTBaseDataEmptyView *)dataEmptyView {
    objc_setAssociatedObject(self, &ZWTDataEmptyViewKey, dataEmptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
    
- (ZWTBaseDataEmptyView *)dataEmptyView {
    return objc_getAssociatedObject(self, &ZWTDataEmptyViewKey);
}
    
- (BOOL)isShowDataEmptyView
{
    return self.dataEmptyView!=nil;
}
    
    @end
