//
//  UIImage+ZWTKit.h
//  UIKitModule
//
//  Created by 曹志君 on 2019/2/28.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZWTKit)

/** 图片宽度*/
@property (nonatomic, readonly) CGFloat imageWidth;

/** 图片高度*/
@property (nonatomic, readonly) CGFloat imageHeight;

/**
 * 根据color生成1x1的纯色图片
 * @param color 颜色
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color;

/**
 * 根据color生成指定Size的纯色图片
 * @param color 颜色
 * @param size 所需图片Size
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size borderColor:(UIColor *)borderColor  cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size borderColor:(UIColor *)borderColor  cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners;
/**
 * 根据指定Size切割图片
 * @param targetSize 缩略图所需大小
 */
- (UIImage*)thumbnailImage:(CGSize)targetSize;

/** 图片质量目前根据大小算，不按比例算，为了处理超长超宽图片*/
- (UIImage *)zwt_imageCompressionQuality;

/** 判断处理图片方向 - 默认 UIImageOrientationUp*/
- (UIImage *)sm_fixOrientation;

@end
