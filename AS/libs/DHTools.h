//
//  DHTools.h
//  mx2app
//
//  Created by dh on 10/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHTools : NSObject

void dh_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);
/// 显示更新弹窗 showToast:是否显示toast 只有用户手动点击时 才显示
//+(void)showupdateViewShouldToast:(BOOL)showToast;
//
//+(void)upContacts;
//
+(void)upMobileInfo;
//
//+(void)resetTabBar;

@end

NS_ASSUME_NONNULL_END
