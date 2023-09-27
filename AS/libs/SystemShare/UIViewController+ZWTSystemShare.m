//
//  UIViewController+ZWTSystemShare.m
//  ZWTCommonWebVC
//
//  Created by 李名扬 on 2019/1/23.
//  Copyright © 2019 李名扬. All rights reserved.
//

#import "UIViewController+ZWTSystemShare.h"
#import "ZWTUIActivity.h"

@implementation UIViewController (ZWTSystemShare)

/** 系统分享*/
- (void)presentSystemShareContent:(NSString * _Nullable)content image:(UIImage * _Nullable)image linkURL:(NSURL * _Nullable)url data:(NSData* _Nullable)data completion:(UIActivityViewControllerCompletionWithItemsHandler)itemsBlock {
    
    // 1、设置分享的内容，并将内容添加到数组中
   
    NSMutableArray *activityItemsArray = [NSMutableArray array];
    
    if (content && ![content isEqualToString:@""]) {
        [activityItemsArray addObject:content];
    }
    
    if (image) {
        [activityItemsArray addObject:image];
    }
    
    if (url && [url isKindOfClass:[NSURL class]]) {
        [activityItemsArray addObject:url];
    }
    
    if (data && data.length > 0) {
        [activityItemsArray addObject:data];
    }
    
    ZWTUIActivity *customActivity = [[ZWTUIActivity alloc] initWithTitle:content activityImage:image linkUrl:url ActivityType:@"Custom"];
    
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:nil/*activityArray*/];
    activityVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    activityVC.modalInPopover = YES;
    
    // 3、设置回调
    activityVC.completionWithItemsHandler = itemsBlock;
    
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
}

/** 系统分享*/
- (void)presentSystemShareContent:(NSString *)content image:(UIImage *)image linkURL:(NSURL *)url completion:(UIActivityViewControllerCompletionWithItemsHandler)itemsBlock {
    
    // 1、设置分享的内容，并将内容添加到数组中
   
    NSMutableArray *activityItemsArray = [NSMutableArray array];
    
    if (content && ![content isEqualToString:@""]) {
        [activityItemsArray addObject:content];
    }
    
    if (image) {
        [activityItemsArray addObject:image];
    }
    
    if (url && [url isKindOfClass:[NSURL class]]) {
        [activityItemsArray addObject:url];
    }
    
    ZWTUIActivity *customActivity = [[ZWTUIActivity alloc] initWithTitle:content activityImage:image linkUrl:url ActivityType:@"Custom"];
    
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    activityVC.modalInPopover = YES;
    
    // 3、设置回调
    activityVC.completionWithItemsHandler = itemsBlock;
    
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
