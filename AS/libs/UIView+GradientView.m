//
//  UIView+GradientView.m
//  test
//
//  Created by yangxudong on 2020/6/22.
//  Copyright © 2020 JackYang. All rights reserved.
//

#import "UIView+GradientView.h"
#import <objc/runtime.h>
#import "UIColor+XYColor.h"

static NSString *colorsKey = @"colorsKey";
static NSString *locationsKey = @"locationsKey";
static NSString *startPointKey = @"startPointKey";
static NSString *endPointKey = @"endPointKey";
static NSString *gradientTypeKey = @"gradientTypeKey";

@implementation UIView (GradientView)

#pragma mark private

+ (Class)layerClass {
    return [CAGradientLayer class];
}

#pragma mark get/set

- (void)setRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(CGColorRef)borderColor {
    self.layer.borderColor = borderColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    [(CAGradientLayer *)self.layer setColors:colors];
    objc_setAssociatedObject(self,
                             &colorsKey,
                             colors,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UIColor *> *)colors {
    return objc_getAssociatedObject(self,
                                    &colorsKey);
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    [(CAGradientLayer *)self.layer setLocations:locations];
    objc_setAssociatedObject(self,
                             &locationsKey,
                             locations,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<NSNumber *> *)locations {
    return objc_getAssociatedObject(self,
                                    &locationsKey);
}

- (void)setStartPoint:(CGPoint)startPoint {
    [(CAGradientLayer *)self.layer setStartPoint:startPoint];
    objc_setAssociatedObject(self,
                             &startPointKey,
                             @(startPoint),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)startPoint {
    return [self getPointValueWithKey:startPointKey];
}

- (void)setEndPoint:(CGPoint)endPoint {
    [(CAGradientLayer *)self.layer setEndPoint:endPoint];
    objc_setAssociatedObject(self,
                             &endPointKey,
                             @(endPoint),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)endPoint {
    return [self getPointValueWithKey:endPointKey];
}

- (CGPoint)getPointValueWithKey:(NSString *)key {
    NSValue *value = objc_getAssociatedObject(self,
                                              &key);
    if (value) {
        CGPoint point;
        [value getValue:&point];
        return point;
    }else return CGPointZero;
}

- (void)setGradientType:(CAGradientLayerType)gradientType {
    objc_setAssociatedObject(self,
                             &gradientTypeKey,
                             gradientType,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CAGradientLayerType)gradientType {
    return objc_getAssociatedObject(self,
                                    &gradientTypeKey);
}

#pragma mark public

- (void)defaultBlueGradient {
    self.colors = @[(__bridge id)[UIColor colorWithHexString:@"#69AEFF"].CGColor,
                    (__bridge id)[UIColor colorWithHexString:@"#3876FF"].CGColor];
    self.locations = @[@(0.0),@(1.0)];
    self.startPoint = CGPointMake(0, 0.5);
    self.endPoint = CGPointMake(1, 0.5);
}

- (void)defaultRedGradient {
    self.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF7777"].CGColor,
                    (__bridge id)[UIColor colorWithHexString:@"#FF5252"].CGColor];
    self.locations = @[@(0.0),@(1.0)];
    self.startPoint = CGPointMake(0, 0.5);
    self.endPoint = CGPointMake(1, 0.5);
}

- (void)gradientWithColors:(NSArray *)colors {
    id start = colors.firstObject;
    id end = colors.lastObject;
    UIColor *color_start = nil;
    UIColor *color_end = nil;
    if ([start isKindOfClass:[UIColor class]] &&
        [end isKindOfClass:[UIColor class]]) {
        color_start = (UIColor *)start;
        color_end = (UIColor *)end;
    }else if ([start isKindOfClass:[NSString class]] &&
              [end isKindOfClass:[NSString class]]) {
        color_start = [UIColor colorWithHexString:colors.firstObject];
        color_end = [UIColor colorWithHexString:colors.lastObject];
    }else {
        return;
    }
    
    self.colors = @[(__bridge id)color_start.CGColor,
                    (__bridge id)color_end.CGColor];
    self.locations = @[@(0.0),@(1.0)];
    self.startPoint = CGPointMake(0, 0.5);
    self.endPoint = CGPointMake(1, 0.5);
}

@end
