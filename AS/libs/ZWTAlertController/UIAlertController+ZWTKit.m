//
//  UIAlertController+ZWTKit.h
//  UIKitModule
//
//  Created by 马强 on 2017/10/9.
//  Copyright © 2017年 coson. All rights reserved.
//

#import "UIAlertController+ZWTKit.h"
#import "ZWTAlertController.h"

@implementation UIAlertController (ZWTKit)

/**
初始化Alert
@param title Alert的标题
@param message Alert的展示的信息
@param titleArray Alert中出现的按钮标题的数组
@param actionHandle block回调事件
*/
+ (instancetype)zwt_alertControllerWithTitle:(NSString *)title
                                     message:(NSString *)message
                                  titleArray:(NSArray<NSString *> *)titleArray
                                actionHandle:(void (^)(NSInteger index))actionHandle {
    
    return [self zwt_alertControllerWithTitle:title
                                      message:message
                                textAlignment:NSTextAlignmentCenter
                                   titleArray:titleArray
                                 actionHandle:actionHandle];
}

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
                                actionHandle:(void (^)(NSInteger index))actionHandle {
    return [ZWTAlertController alertWithTitle:title
                                      message:message
                                textAlignment:textAlignment
                                        style:UIAlertControllerStyleAlert
                                   titleArray:titleArray
                                 actionHandle:actionHandle];
    
}

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
                                      actionHandle:(void (^)(NSInteger index))actionHandle {
    return [ZWTAlertController alertWithTitle:title
                                      message:message
                                textAlignment:NSTextAlignmentCenter
                                        style:UIAlertControllerStyleActionSheet
                                   titleArray:titleArray
                                 actionHandle:actionHandle];
}


/**
 展示弹框
 */
- (void)zwt_showAlert {
    [kit_getCurrentViewController() presentViewController:self animated:YES completion:nil];
}

#pragma mark - private
/** 获取当前controller */
FOUNDATION_EXPORT UIViewController* kit_getCurrentViewController(void) {
    //获得当前活动窗口的根视图
    UIViewController* vc = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations {
    UIAlertControllerStyleAlert
    return UIInterfaceOrientationMaskLandscape;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif
@end
