//
//  UIImage+ZWTKit.m
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import "UIImage+ZWTKit.h"

@implementation UIImage (ZWTKit)

#pragma mark - Getter
- (CGFloat)imageWidth {
    return self.size.width;
}

- (CGFloat)imageHeight {
    return self.size.height;
}

#pragma mark - Extension Function
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

// 图片质量目前根据大小算，不按比例算，为了处理超长超宽图片
- (UIImage *)zwt_imageCompressionQuality {
    float maxSize = MAX(self.size.width, self.size.height);
    CGFloat compressionQuality = 0.0;
    
    if (maxSize >= 4000.0) {
        compressionQuality = 0.1;
    }
    else if (maxSize >= 1000.0 && maxSize < 4000) {
        compressionQuality = 0.25;
    }
    else if(maxSize < 1000 && maxSize >= 500){
        compressionQuality = 0.6;
    }
    else if(maxSize < 500 && maxSize >=200){
        compressionQuality = 0.7;
    }
    else{
        compressionQuality = 1;
    }
    
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
    UIImage *newImage = [UIImage imageWithData:data];
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
     
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size borderColor:(UIColor *)borderColor  cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0,0,size} byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0,0,size} cornerRadius:cornerRadius];
    [bezier closePath];
    [bezier addClip];
    [bezier fill];
//    [bezier stroke];
    CGContextAddPath(context, bezier.CGPath);
    
    if (borderColor) {
        [borderColor setStroke];
        CGContextSetLineWidth(context,2);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    
    
    [color setFill];
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColors:(NSArray<UIColor *> *)colors size:(CGSize)size borderColor:(UIColor *)borderColor  cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners {
    if (!colors || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, colors[0].CGColor);

    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0,0,size} byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    [bezier closePath];
    [bezier addClip];
    [bezier fill];

    CGContextAddPath(context, bezier.CGPath);
    
    if (borderColor) {
        [borderColor setStroke];
        CGContextSetLineWidth(context,2);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    
    
    [colors[0] setFill];
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size borderColor:(UIColor *)borderColor  cornerRadius:(CGFloat)cornerRadius {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRoundedRect:(CGRect){0,0,size} cornerRadius:cornerRadius];
    [bezier closePath];
    [bezier addClip];
    [bezier fill];
//    [bezier stroke];
    CGContextAddPath(context, bezier.CGPath);
    
    if (borderColor) {
        [borderColor setStroke];
        CGContextSetLineWidth(context,2);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
    }
    
    
    [color setFill];
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)thumbnailImage:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width * screenScale;
    CGFloat targetHeight = targetSize.height * screenScale;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) 
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else 
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }       
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight)); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return newImage;
}

/** 判断处理图片方向 - 默认 UIImageOrientationUp*/
- (UIImage *)sm_fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
