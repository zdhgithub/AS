//
//  UIAlertController+ZWTKit.h
//  UIKitModule
//
//  Created by 马强 on 2017/10/9.
//  Copyright © 2017年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ZWTKit)

/**
 初始化Alert
 @param title Alert的标题x`
 @param message Alert的展示的信息
 @param titleArray Alert中出现的按钮标题的数组
 @param actionHandle block回调事件
 */
+ (instancetype)zwt_alertControllerWithTitle:(NSString *)title
                                      message:(NSString *)message
                                   titleArray:(NSArray<NSString *> *)titleArray
                                  actionHandle:(void (^)(NSInteger index))actionHandle;

/**
 初始化Alert【带Message对齐方式】
 @param title Alert的标题
 @param message Alert的展示的信息
 @param textAlignment Message对齐方式
 @param titleArray Alert中出现的按钮标题的数组
 @param actionHandle block回调事件
 */
+ (instancetype)zwt_alertControllerWithTitle:(NSString *)title
                                      message:(NSString *)message
                                textAlignment:(NSTextAlignment)textAlignment
                                   titleArray:(NSArray<NSString *> *)titleArray
                                 actionHandle:(void (^)(NSInteger index))actionHandle;


/**
 初始化ActionSheet
 @param title ActionSheet的标题
 @param message ActionSheet的展示的信息
 @param titleArray ActionSheet中出现的按钮标题的数组
 @param actionHandle block回调事件
 */
+ (instancetype)zwt_actionSheetControllerWithTitle:(NSString *)title
                                      message:(NSString *)message
                                   titleArray:(NSArray<NSString *> *)titleArray
                                 actionHandle:(void (^)(NSInteger index))actionHandle;

/** 展示弹框 */
- (void)zwt_showAlert;

@end
