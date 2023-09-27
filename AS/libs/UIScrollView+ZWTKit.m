//
//  UIScrollView+ZWTKit.m
//  BaseModule
//
//  Created by 练炽金 on 2019/1/10.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

#import "UIScrollView+ZWTKit.h"
#import <objc/runtime.h>

@interface UIScrollView ()
@property (nonatomic, strong) UIView *scrollOffsetView;
@property (nonatomic, strong) UIView *scrollFooterView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIImageView *scrollOffsetImageView;
@end

@implementation UIScrollView (ZWTKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(setContentOffset:);
        SEL swizzledSelector = @selector(ZWT_setContentOffset:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)ZWT_setContentOffset:(CGPoint)point {
    
    [self ZWT_setContentOffset:point];
    
    if (self.scrollOffsetViewColor) {
        if (!self.scrollOffsetView) {
            self.scrollOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
            self.scrollOffsetView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:self.scrollOffsetView];
        }
        
        CGPoint contentOffset = point;
        if (contentOffset.y < 0) {
            self.scrollOffsetView.frame = CGRectMake(0, 0, self.bounds.size.width, self.contentOffset.y);
        }else{
            self.scrollOffsetView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        }
        self.scrollOffsetView.backgroundColor = self.scrollOffsetViewColor;
        [self sendSubviewToBack:self.scrollOffsetView];
    }
    
    if (self.scrollFooterViewColor) {
        if (!self.scrollFooterView) {
            self.scrollFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
            self.scrollFooterView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:self.scrollFooterView];
        }
        
        CGFloat maxY = self.contentSize.height - CGRectGetHeight(self.frame);
        CGFloat contentOffsetY = point.y;
        if (contentOffsetY > maxY) {
            self.scrollFooterView.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, contentOffsetY-maxY);
        }else{
            self.scrollFooterView.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, 0);
        }
        self.scrollFooterView.backgroundColor = self.scrollFooterViewColor;
        [self sendSubviewToBack:self.scrollFooterView];
    }
    
    if (self.scrollOffsetGradientArr) {
        if (!self.scrollOffsetView) {
            self.scrollOffsetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
            self.scrollOffsetView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:self.scrollOffsetView];
            
            self.gradientLayer = [[CAGradientLayer alloc] init];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
            self.gradientLayer.colors = self.scrollOffsetGradientArr[0];
            self.gradientLayer.locations = self.scrollOffsetGradientArr[1];
            [self.scrollOffsetView.layer insertSublayer:self.gradientLayer atIndex:0];
        }
        
        CGPoint contentOffset = point;
        if (contentOffset.y < 0) {
            self.scrollOffsetView.frame = CGRectMake(0, 0, self.bounds.size.width, self.contentOffset.y);
        }else{
            self.scrollOffsetView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        }
        self.gradientLayer.frame = self.scrollOffsetView.bounds;
        [self sendSubviewToBack:self.scrollOffsetView];
    }
    
    if (self.scrollOffsetImage) {
        if (!self.scrollOffsetImageView) {
            self.scrollOffsetImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
            self.scrollOffsetImageView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:self.scrollOffsetImageView];
        }
        
        CGPoint contentOffset = point;
        if (contentOffset.y < 0) {
            self.scrollOffsetImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.contentOffset.y);
        }else{
            self.scrollOffsetImageView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        }
        self.scrollOffsetImageView.image = self.scrollOffsetImage;
        self.scrollOffsetImageView.contentMode = UIViewContentModeScaleToFill;
        [self sendSubviewToBack:self.scrollOffsetImageView];
    }
}


static char scrollOffsetImageViewKey;
- (void)setScrollOffsetImageView:(UIImageView *)scrollOffsetImageView {
    objc_setAssociatedObject(self, &scrollOffsetImageViewKey, scrollOffsetImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)scrollOffsetImageView {
    return objc_getAssociatedObject(self, &scrollOffsetImageViewKey);
}

static char scrollOffsetImageKey;
- (void)setScrollOffsetImage:(UIImage *)scrollOffsetImage {
    objc_setAssociatedObject(self, &scrollOffsetImageKey, scrollOffsetImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)scrollOffsetImage {
    return objc_getAssociatedObject(self, &scrollOffsetImageKey);
}

static char scrollOffsetGradientLayerKey;
- (void)setGradientLayer:(CAGradientLayer *)gradientLayer {
    objc_setAssociatedObject(self, &scrollOffsetGradientLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CAGradientLayer *)gradientLayer {
    return objc_getAssociatedObject(self, &scrollOffsetGradientLayerKey);
}

static char scrollOffsetGradientArrKey;
- (void)setScrollOffsetGradientArr:(NSArray<NSArray *> *)scrollOffsetGradientArr {
    objc_setAssociatedObject(self, &scrollOffsetGradientArrKey, scrollOffsetGradientArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<NSArray *> *)scrollOffsetGradientArr {
    return objc_getAssociatedObject(self, &scrollOffsetGradientArrKey);
}


static char scrollOffsetViewColorKey;
- (void)setScrollOffsetViewColor:(UIColor *)scrollOffsetViewColor {
    objc_setAssociatedObject(self, &scrollOffsetViewColorKey, scrollOffsetViewColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)scrollOffsetViewColor {
    return objc_getAssociatedObject(self, &scrollOffsetViewColorKey);
}
static char scrollOffsetViewKey;
- (void)setScrollOffsetView:(UIView *)scrollOffsetView {
    objc_setAssociatedObject(self, &scrollOffsetViewKey, scrollOffsetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)scrollOffsetView {
    return objc_getAssociatedObject(self, &scrollOffsetViewKey);
}

static char scrollFooterViewColorKey;
- (void)setScrollFooterViewColor:(UIColor *)scrollFooterViewColor {
    objc_setAssociatedObject(self, &scrollFooterViewColorKey, scrollFooterViewColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)scrollFooterViewColor {
    return objc_getAssociatedObject(self, &scrollFooterViewColorKey);
}
static char scrollFooterViewKey;
- (void)setScrollFooterView:(UIView *)scrollFooterView {
    objc_setAssociatedObject(self, &scrollFooterViewKey, scrollFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)scrollFooterView {
    return objc_getAssociatedObject(self, &scrollFooterViewKey);
}

#pragma mark - 解决Pop滑动偏移问题
- (void)zwt_compatibleiOS11 {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
@end
