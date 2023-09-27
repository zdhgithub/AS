//
//  UIViewController+ZWTExtend.h
//  UIKitModule
//
//  Created by weidong liu on 2017/5/4.
//  Copyright © 2017年 coson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZWTKit)

//获取当前控制器
+ (UIViewController *)mo_currentViewController;

/** 新增修改 by lianchijin 2018.11.09
 1、增加 disablePopGesture 是否禁用右滑手势返回属性，在需要禁用页面的 viewDidLoad 中设置 self.disablePopGesture = YES 即可
 2、设置默认返回按钮
 3、提供导航栏自定义左边 leftBarButtonItems 方法
 */

/**
 * 是否禁用右滑返回，默认NO
 * Created by lianchijin on 2018/11/09.
 */
@property(nonatomic, assign) BOOL disablePopGesture;

/**
 * 自定义leftBarItems
 * 可 return 多个按钮
 * return nil  则 leftBarItem 不存在

 @return NSArray
 */
- (NSArray <UIBarButtonItem *>*)customLeftBarItems;


/** 创建左侧图片返回按钮 nav_back */
- (void)zwt_setLeftBackBarItem;

/** 创建左侧图片返回按钮 nav_back */
- (void)zwt_setLeftBackBarItem:(id)target
                          action:(SEL)action;

/** 创建 字符按钮 的 leftBarItem */
- (void)zwt_setLeftBarItemsByTitle:(NSString *)title
                             target:(id)target
                             action:(SEL)action;
/** 创建 图片按钮 leftBarItem */
- (void)zwt_setLeftBarItemsByNormalImage:(UIImage *)normalImage
                         highlightedImage:(UIImage *)highlightedImage
                                   target:(id)target
                                   action:(SEL)action;

/** 创建 字符按钮 的 rightBarItem */
- (void)zwt_setRightBarItemsByTitle:(NSString *)title
                              target:(id)target
                              action:(SEL)action;

/** 创建自定义颜色 字符按钮 的 rightBarItem */
- (void)zwt_setRightBarItemsByTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                             target:(id)target
                             action:(SEL)action;

/** 创建 图片按钮 rightBarItem */
- (void)zwt_setRightBarItemsByNormalImage:(UIImage *)normalImage
                          highlightedImage:(UIImage *)highlightedImage
                              target:(id)target
                              action:(SEL)action;


/** 创建自定义颜色 字符按钮 的 rightBarItem */
- (UIBarButtonItem *)dh_setRightBarItemsByTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                             target:(id)target
                                         action:(SEL)action;


@end
