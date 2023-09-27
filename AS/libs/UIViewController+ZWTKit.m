//
//  UIViewController+ZWTKit.m
//  UIKitModule
//
//  Created by weidong liu on 2017/5/4.
//  Copyright © 2017年 coson. All rights reserved.
//

#import "UIViewController+ZWTKit.h"
#import <objc/runtime.h>

@implementation UIViewController (ZWTKit)

+ (UIViewController *)mo_currentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self mo_getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)mo_getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self mo_getVisibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self mo_getVisibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self mo_getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef DEBUG
        Class class = [self class];
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(PAZWT_viewDidAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
//        SEL deallocSelector = sel_registerName("dealloc");;
//        swizzledSelector = @selector(PAZWT_dealloc);
//        originalMethod = class_getInstanceMethod(class, deallocSelector);
//        swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
#else
        
#endif
        
    });
}

- (void)PAZWT_viewDidAppear:(BOOL)animated {
    NSLog(@"%@ 进入页面 viewDidAppear:",[self class]);
    [self PAZWT_viewDidAppear:animated];
}

- (void)PAZWT_dealloc {
    NSLog(@"%@ 释放了 dealloc",[self class]);
    [self PAZWT_dealloc];
}


static char disablePopGestureKey;

- (void)setDisablePopGesture:(BOOL)disablePopGesture {
    self.navigationController.interactivePopGestureRecognizer.enabled = !disablePopGesture;
    objc_setAssociatedObject(self, &disablePopGestureKey, @(disablePopGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disablePopGesture {
    NSNumber *value = objc_getAssociatedObject(self, &disablePopGestureKey);
    return [value boolValue];
}

/** 创建左侧图片返回按钮 nav_back */
- (void)zwt_setLeftBackBarItem {
    [self zwt_setLeftBackBarItem:self action:@selector(backPopViewcontroller:)];
}

/** 创建左侧图片返回按钮 nav_back */
- (void)zwt_setLeftBackBarItem:(id)target
                         action:(SEL)action {
    UIImage *image = [UIImage imageNamed:@"nav_back"];
//    UIImage *image = [IconFont imageWithIcon:@"nav_ic_back" imageSize:(CGSize){22,22} fontSize:22 tintColor:ZWTColorNavTitle];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)backPopViewcontroller:(id)sender {
    if(self.navigationController.topViewController == self &&
       self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/** 创建 字符按钮 的 leftBarItem */
- (void)zwt_setLeftBarItemsByTitle:(NSString *)title
                            target:(id)target
                            action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightBarButtonItem;
    button = nil;
}

/** 创建 图片按钮 leftBarItem */
- (void)zwt_setLeftBarItemsByNormalImage:(UIImage *)normalImage
                        highlightedImage:(UIImage *)highlightedImage
                                  target:(id)target
                                  action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    if(highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    button = nil;
}

/** 创建 字符按钮 的 rightBarItem */
- (void)zwt_setRightBarItemsByTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action {
    [self zwt_setRightBarItemsByTitle:title titleColor:UIColor.blackColor target:target action:action];
}

/** 创建自定义颜色 字符按钮 的 rightBarItem */
- (void)zwt_setRightBarItemsByTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                             target:(id)target
                             action:(SEL)action {
    
    if(!titleColor) titleColor = UIColor.blackColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    button = nil;
}

/** 创建自定义颜色 字符按钮 的 rightBarItem */
- (UIBarButtonItem *)dh_setRightBarItemsByTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                             target:(id)target
                             action:(SEL)action {
    
    if(!titleColor) titleColor = UIColor.blackColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    button = nil;
    return rightBarButtonItem;
}

/** 创建 图片按钮 rightBarItem */
- (void)zwt_setRightBarItemsByNormalImage:(UIImage *)normalImage
                          highlightedImage:(UIImage *)highlightedImage
                                    target:(id)target
                                    action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:normalImage forState:UIControlStateNormal];
    if(highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    button = nil;
    
}

@end
