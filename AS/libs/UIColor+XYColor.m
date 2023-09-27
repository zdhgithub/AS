//
//  UIColor+XYColor.m
//  NemoOfficeClient
//
//  Created by 杨旭东 on 2017/9/27.
//  Copyright © 2017年 ainemo. All rights reserved.
//

#import "UIColor+XYColor.h"

@implementation UIColor (XYColor)

+ (UIColor *(^)(int, float))Color{
    return ^(int tone, float alpha){
        return [UIColor colorWithRed:((tone & 0xFF0000) >> 16)/255.0 green:((tone & 0xFF00) >> 8)/255.0 blue:((tone & 0xFF))/255.0 alpha:alpha];
    };
}

+ (UIColor *(^)(CGFloat))mainBlue{
    return ^(CGFloat alpha){
        return self.Color(0x3876FF, alpha);
    };
}

+ (UIColor *(^)())liveColor{
    return ^(){
        return self.Color(0x2ee016, 1.f);
    };
}

+ (UIColor *(^)())recordingColor{
    return ^(){
        return self.Color(0xff3838, 1.f);
    };
}

+ (UIColor *(^)(CGFloat))white{
    return ^(CGFloat alpha){
        return self.Color(0xffffff, alpha);
    };
}

+ (UIColor *(^)(CGFloat))black{
    return ^(CGFloat alpha){
        return self.Color(0x000000, alpha);
    };
}

+ (UIColor *(^)(CGFloat))dark{
    return ^(CGFloat alpha){
        return self.Color(0x393946, alpha);
    };
}

+ (UIColor *(^)())lucency{
    return ^(){
        return self.Color(0xffffff, .0f);
    };
}

+ (UIColor *(^)(CGFloat))dim_white{
    return ^(CGFloat alpha){
        return self.Color(0xf4f5f6, alpha);
    };
}

+ (UIColor *(^)(CGFloat))gray{
    return ^(CGFloat alpha){
        return self.Color(0x666666, alpha);
    };
}

+ (UIColor *(^)(CGFloat))pale_gray{
    return ^(CGFloat alpha){
        return self.Color(0xd7d7d7, alpha);
    };
}

+ (UIColor *(^)(CGFloat))badge_red{
    return ^(CGFloat alpha){
        return self.Color(0xff6666, alpha);
    };
}

- (UIColor *(^)(CGFloat))component{
    return ^(CGFloat alpha){
        return [self colorWithAlphaComponent:alpha];
    };
}

+ (UIColor *(^)(CGFloat))minor_gray{
    return ^(CGFloat alpha){
        return self.Color(0xbebebe, alpha);
    };
}

+ (UIColor *(^)(CGFloat))line_gray{
    return ^(CGFloat alpha){
        return self.Color(0xe6e6e6, alpha);
    };
}

+ (UIColor *(^)(CGFloat))disable_mainBlue{
    return ^(CGFloat alpha){
        return self.Color(0x44B5FF, alpha);
    };
}

+ (UIColor *(^)(CGFloat))shadow {
    return ^(CGFloat alpha){
        return self.Color(0x1C4679, alpha);
    };
}

+ (UIColor *)colorWithHexString:(NSString *)hex withAlpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex{
    return [UIColor colorWithHexString:hex withAlpha:1];
}

+ (UIColor *)colorWithHex:(int)hex withAlpha:(CGFloat)alpha{
    
    CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat g = ((hex & 0x00FF00) >> 8 ) / 255.0;
    CGFloat b = ((hex & 0x0000FF)      ) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hex{
    return [UIColor colorWithHex:hex withAlpha:1];
}

+ (UIColor *(^)(CGFloat))listShadow {
    return ^(CGFloat alpha){
        return self.Color(0xA5AAB1, alpha);
    };
}

+ (UIColor *(^)())addParticipatBg {
    return ^(){
        return self.Color(0xe5e5e5, 1.f);
    };
}

+ (UIColor *(^)())green {
    return ^(){
        return self.Color(0x90b12b, 1.f);
    };
}

+ (UIColor *(^)())selectNormal {
    return ^(){
        return self.Color(0xc7e9ff, 1.f);
    };
}

+ (UIColor *(^)())selectError {
    return ^(){
        return self.Color(0xffcaca, 1.f);
    };
}

+ (UIColor *(^)())selectErrorDorder {
    return ^(){
        return self.Color(0xf36a6a, 1.f);
    };
}

+ (UIColor *(^)())selectErrorSelected {
    return ^(){
        return self.Color(0xf45f5f, 1.f);
    };
}

-(BOOL)isClearColor{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    if (red == 0 && green == 0 && blue == 0 && alpha == 0) {
        return YES;
    }else{
        return NO;
    }
}
@end
