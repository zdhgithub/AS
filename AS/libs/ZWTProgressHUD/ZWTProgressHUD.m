//
//  ZWTProgressHUD.m
//  BaseModule
//
//  Created by 曹志君 on 2019/1/9.
//  Copyright © 2019 pingan.inc. All rights reserved.
//

#import "ZWTProgressHUD.h"
//#import "ZWTKitConfig.h"
#import <Masonry/Masonry.h>
//#import "SmartKitTools.h"
#import "UIColor+XYColor.h"

static MBProgressHUD *showHUD;

@implementation ZWTProgressHUD

#pragma mark -
#pragma mark - Prompt Box
/** toast纯文字形式提示框 (默认1.0秒展示时间)*/
+ (void) zwt_showMessage:(NSString *)title {
    [ZWTProgressHUD zwt_showMessage:title toView:nil];
}

/** toast纯文字形式提示框 (默认1.0秒展示时间) 指定View*/
+ (void) zwt_showMessage:(NSString *)title
                  toView:(UIView *)view {
    if(title && title.length>0) {
        UIView *showView = view?:[UIApplication sharedApplication].keyWindow;
        MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        textHud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#333333" withAlpha:0.8];
        textHud.mode = MBProgressHUDModeText;
        textHud.detailsLabel.font = [UIFont systemFontOfSize:17];
        textHud.detailsLabel.textColor = UIColor.whiteColor;
        textHud.detailsLabel.text = title;
        // 隐藏时候从父控件中移除
        textHud.removeFromSuperViewOnHide = YES;
        //展示1.0秒后隐藏
        [textHud hideAnimated:YES afterDelay:1.0];
    }
}

/** toast复合型提示框 (图片默认居中，默认1.0秒展示时间)*/
+ (void) zwt_showMessage:(NSString *)title
                              image:(UIImage *)image {
    [ZWTProgressHUD zwt_showMessage:title image:image toView:nil];
}

/** toast复合型提示框 (图片默认居中，默认1.0秒展示时间)*/
+ (void) zwt_showMessage:(NSString *)title
                              image:(UIImage *)image
                             toView:(UIView *)view {
    
    if(image) {
        UIView *showView = view?:[UIApplication sharedApplication].keyWindow;
        MBProgressHUD *textHud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        
        // 设置图片
        textHud.mode = MBProgressHUDModeCustomView;
        textHud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#333333" withAlpha:0.8];
        textHud.customView = [[UIImageView alloc] initWithImage:image];
        //设置文本
        textHud.detailsLabel.font = [UIFont systemFontOfSize:17];
        textHud.detailsLabel.textColor = UIColor.whiteColor;
        textHud.detailsLabel.text = title;
        textHud.detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        // 隐藏时候从父控件中移除
        textHud.removeFromSuperViewOnHide = YES;
        //展示1.0秒后隐藏
        [textHud hideAnimated:YES afterDelay:1.0];
        
    }else {
        [ZWTProgressHUD zwt_showMessage:title];
    }
    
}

/** 展示成功的Message，带图标*/
+ (void)zwt_showSuccessMessage:(NSString *)success {
    //SmartBundleImageNamed(@"zwt_hudSuccess", @"ZWTUIKit")
    [ZWTProgressHUD zwt_showMessage:success image: [UIImage imageNamed:@""]];
}

/** 展示成功的Message，带图标，指定View*/
+ (void)zwt_showSuccessMessage:(NSString *)success
                      toView:(UIView *)view {
    // SmartBundleImageNamed(@"zwt_hudSuccess", @"ZWTUIKit")
    [ZWTProgressHUD zwt_showMessage:success image:[UIImage imageNamed:@""] toView:view];
}

/** 展示失败的Message，带图标*/
+ (void)zwt_showErrorMessage:(NSString *)error {
    //SmartBundleImageNamed(@"zwt_hudError", @"ZWTUIKit")
    [ZWTProgressHUD zwt_showMessage:error image: [UIImage imageNamed:@""]];
}

/** 展示失败的Message，带图标，指定View*/
+ (void)zwt_showErrorMessage:(NSString *)error
                    toView:(UIView *)view {
    //SmartBundleImageNamed(@"zwt_hudError", @"ZWTUIKit")
    [ZWTProgressHUD zwt_showMessage:error image:[UIImage imageNamed:@""] toView:view];
}

/** 展示Loading hud (默认在window居中展示)*/
+ (void) zwt_showLoadMessage:(NSString *)title {
    UIView *showView = [UIApplication sharedApplication].keyWindow;
    [ZWTProgressHUD zwt_showLoadMessage:title toView:showView];
}

/** 展示Loading hud (view为nil时默认在window居中展示)*/
+ (void) zwt_showLoadMessage:(NSString *)title
                           toView:(UIView *)view {
    
    
    UIView *showView = (view?view:[UIApplication sharedApplication].keyWindow);
    if (showHUD) {
        if (showHUD.superview == showView) {
            showHUD.detailsLabel.text = title;
            NSLog(@"%s aaa 直接赋值",__FUNCTION__);
            return;
        }else{
            [showHUD removeFromSuperview];
            NSLog(@"%s aaa 已经存在但父视图变了",__FUNCTION__);

        }
    }
    NSLog(@"%s aaa 创建",__FUNCTION__);
    showHUD = [[MBProgressHUD alloc] initWithView:showView];
    showHUD.margin = 15.0f;

    [showView addSubview:showHUD];
    
    /** 展示环形loading动画 */
    [showHUD setMode:MBProgressHUDModeCustomView];
     
    
    CGFloat loadWidth = 46.0f;//(title&&title.length>0)?110.0f:46.0f;
    UIView *loadView = nil;
    
//    if ([SmartKitTools isqh]) {
//
//        showHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        showHUD.bezelView.backgroundColor = UIColor.clearColor;
//
//        loadWidth = 81;
//
//        loadView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, loadWidth, loadWidth)];
//        [loadView setBackgroundColor:UIColor.clearColor];
//
//        UIImage *loadImage = [UIImage imageNamed:@"icon_loading"];
//
//        UIImageView *loadImgView = [[UIImageView alloc] initWithFrame:CGRectMake((loadWidth - 71.0f)/2, 5.0f, 71.0f, 71.0f)];
//        [loadImgView setImage:loadImage];
//
//        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        animation.toValue = [NSNumber numberWithFloat:M_PI*2];
//        animation.duration = 1.0;
//        animation.cumulative = YES;
//        animation.repeatCount = INT_MAX;
//        [loadImgView.layer addAnimation:animation forKey:@"ZWTHubLoadAnimation"];
//        [loadView addSubview:loadImgView];
//
//        UIImageView *logo = [[UIImageView alloc] initWithFrame:(CGRect){(loadWidth-37)/2,(loadWidth-38)/2,37,38}];
//        logo.image = [UIImage imageNamed:@"logo_loading"];
//        [loadView addSubview:logo];
//
//    }else{
    showHUD.bezelView.backgroundColor = [UIColor colorWithHexString:@"#333333" withAlpha:0.8];
        
        loadWidth = 46.0f;//(title&&title.length>0)?110.0f:46.0f;
        
        loadView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, loadWidth, 46.0f)];
        [loadView setBackgroundColor:UIColor.clearColor];
        
        UIImage *loadImage = [UIImage imageNamed:@"common_ic_loading_center"];
//        if(!loadImage){
//            loadImage = SmartBundleImageNamed(@"zwtRemind_loading", @"ZWTUIKit");
//        }
        UIImageView *loadImgView = [[UIImageView alloc] initWithFrame:CGRectMake((loadWidth - 36.0f)/2, 5.0f, 36.0f, 36.0f)];
        [loadImgView setImage:loadImage];
        
        CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat:M_PI*2];
        animation.duration = 1.0;
        animation.cumulative = YES;
        animation.repeatCount = INT_MAX;
        [loadImgView.layer addAnimation:animation forKey:@"ZWTHubLoadAnimation"];
        [loadView addSubview:loadImgView];
//    }
    
    
    
    [showHUD setCustomView:loadView];
    
    [showHUD.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(loadWidth);
        make.centerX.equalTo(showHUD);
    }];

    
    /* - - - - */
    if(title && title.length > 0) {
        showHUD.detailsLabel.font = [UIFont systemFontOfSize:17];
//        if ([SmartKitTools isqh]) {
//            showHUD.detailsLabel.textColor = UIColor.blackColor;
//        }else{
            showHUD.detailsLabel.textColor = UIColor.whiteColor;
//        }
        
        showHUD.detailsLabel.text = title;
    }
    
    [showHUD showAnimated:NO];
}

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)zwt_showProgressHubWithTitle:(NSString *)title {
    
   return [ZWTProgressHUD zwt_showProgressHubWithTitle:title toView:nil];
}

/** 获取一个MBProgressHUD实例用于上传进度的*/
+ (MBProgressHUD *)zwt_showProgressHubWithTitle:(NSString *)title toView:(UIView *)view {
    
    [ZWTProgressHUD zwt_hideLoadHUD];
    UIView *showView = (view?view:[UIApplication sharedApplication].keyWindow);

    showHUD = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    showHUD.mode = MBProgressHUDModeAnnularDeterminate;
    showHUD.label.text = title;

    [showHUD showAnimated:YES];
    return showHUD;
}

/** 显示上传进度的progress*/
+ (void)zwt_showProgress:(float)progress {
    showHUD.progress = progress;
}

/** 直接取消loading hud*/
+ (void) zwt_hideLoadHUD {
    if(showHUD != nil && showHUD.superview != nil) {
        [showHUD removeFromSuperview];
//        [showHUD hideAnimated:NO];
//        [showHUD removeFromSuperViewOnHide];
        showHUD = nil;
        NSLog(@"%s aaa 删除",__FUNCTION__);

    }
}

/** 取消loading hud 并Toast展示相应的文案*/
+ (void) zwt_hideLoadHUDWithRemindTitle:(NSString *)remindTitle {
    
    [ZWTProgressHUD zwt_hideLoadHUD];
    
    [ZWTProgressHUD zwt_showMessage:remindTitle];
    
}

@end
