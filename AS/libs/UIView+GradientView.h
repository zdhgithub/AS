//
//  UIView+GradientView.h
//  test
//
//  Created by yangxudong on 2020/6/22.
//  Copyright © 2020 JackYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GradientView)

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic) CGColorRef borderColor;

@property (nonatomic, strong) NSArray <UIColor *>*colors;

@property (nonatomic, strong) NSArray <NSNumber *>*locations;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, copy) CAGradientLayerType gradientType;

/// 快捷方式 - 默认蓝色渐变
- (void)defaultBlueGradient;

/// 快捷方式 - 默认红色渐变
- (void)defaultRedGradient;

/// 快捷方式 - 自定义渐变
/// @param colors colors - 只支持两种颜色渐变
- (void)gradientWithColors:(NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
