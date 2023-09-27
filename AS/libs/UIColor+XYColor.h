//
//  UIColor+XYColor.h
//  NemoOfficeClient
//
//  Created by 杨旭东 on 2017/9/27.
//  Copyright © 2017年 ainemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XYColor)

+ (UIColor *(^)(int, float))Color;

+ (UIColor *(^)(CGFloat))mainBlue;

+ (UIColor *(^)())liveColor;

+ (UIColor *(^)())recordingColor;

+ (UIColor *(^)(CGFloat))white;

+ (UIColor *(^)(CGFloat))black;

+ (UIColor *(^)(CGFloat))dark;

+ (UIColor *(^)())lucency;

+ (UIColor *(^)(CGFloat))dim_white;

+ (UIColor *(^)(CGFloat))gray;

+ (UIColor *(^)(CGFloat))pale_gray;

+ (UIColor *(^)(CGFloat))badge_red;

- (UIColor *(^)(CGFloat))component;

+ (UIColor *(^)(CGFloat))minor_gray;


+ (UIColor *(^)(CGFloat))line_gray;


/** 主操作按钮（Disable） */
+ (UIColor *(^)(CGFloat))disable_mainBlue;

+ (UIColor *(^)(CGFloat))shadow;

+ (UIColor *(^)(CGFloat))listShadow;

+ (UIColor *(^)())addParticipatBg;

+ (UIColor *(^)())green;

+ (UIColor *(^)())selectNormal;

+ (UIColor *(^)())selectError;

+ (UIColor *(^)())selectErrorDorder;

+ (UIColor *(^)())selectErrorSelected;

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)hex withAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hex;

-(BOOL)isClearColor;
@end
