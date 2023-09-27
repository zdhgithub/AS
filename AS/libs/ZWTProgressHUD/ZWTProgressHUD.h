//
//  ZWTProgressHUD.h
//  BaseModule
//
//  Created by 曹志君 on 2019/1/9.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

#import "MBProgressHUD.h"


@interface ZWTProgressHUD : MBProgressHUD

#pragma mark -
#pragma mark - Prompt Box
/** toast纯文字形式提示框 (默认1.0秒展示时间)*/
+ (void) zwt_showMessage:(NSString *)title;

/** toast纯文字形式提示框 (默认1.0秒展示时间) 指定View*/
+ (void) zwt_showMessage:(NSString *)title
                  toView:(UIView *)view;

/** toast复合型提示框 (图片默认居中，默认1.0秒展示时间)*/
+ (void) zwt_showMessage:(NSString *)title
                              image:(UIImage *)image;

/** toast复合型提示框 (图片默认居中，默认1.0秒展示时间)，指定View*/
+ (void) zwt_showMessage:(NSString *)title
                              image:(UIImage *)image
                             toView:(UIView *)view;

/** 展示成功的Message，带图标*/
+ (void)zwt_showSuccessMessage:(NSString *)success;

/** 展示成功的Message，带图标，指定View*/
+ (void)zwt_showSuccessMessage:(NSString *)success
                      toView:(UIView *)view;

/** 展示失败的Message，带图标*/
+ (void)zwt_showErrorMessage:(NSString *)error;

/** 展示失败的Message，带图标，指定View*/
+ (void)zwt_showErrorMessage:(NSString *)error
                    toView:(UIView *)view;

/** 展示Loading hud (默认在window居中展示)*/
+ (void) zwt_showLoadMessage:(NSString *)title;

/** 展示Loading hud (view为nil时默认在window居中展示)*/
+ (void) zwt_showLoadMessage:(NSString *)title
                           toView:(UIView *)view;

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)zwt_showProgressHubWithTitle:(NSString *)title;

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)zwt_showProgressHubWithTitle:(NSString *)title toView:(UIView *)view;

/** 显示上传进度的progress*/
+ (void)zwt_showProgress:(float)progress;

/** 直接取消loading hud*/
+ (void) zwt_hideLoadHUD;

/** 取消loading hud 并Toast展示相应的文案*/
+ (void) zwt_hideLoadHUDWithRemindTitle:(NSString *)remindTitle;

@end

