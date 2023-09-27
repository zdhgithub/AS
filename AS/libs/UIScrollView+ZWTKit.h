//
//  UIScrollView+ZWTKit.h
//  BaseModule
//
//  Created by 练炽金 on 2019/1/10.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

@import UIKit;

@interface UIScrollView (ZWTKit)
/**
 设置下拉回弹视图的背景色
 */
@property (nonatomic, strong) UIColor *scrollOffsetViewColor;
/**
 设置底部上拉回弹视图的背景色
 */
@property (nonatomic, strong) UIColor *scrollFooterViewColor;

/// 下拉回弹渐变颜色，位置数组
@property (nonatomic, strong) NSArray<NSArray *> *scrollOffsetGradientArr;
///  下拉回弹图片
@property (nonatomic, strong) UIImage *scrollOffsetImage;

#pragma mark - 解决Pop滑动偏移问题
- (void)zwt_compatibleiOS11;
@end
