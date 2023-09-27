//
//  UIViewController+ZWTSystemShare.h
//  ZWTCommonWebVC
//
//  Created by 李名扬 on 2019/1/23.
//  Copyright © 2019 李名扬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZWTSystemShare)
/** 系统分享*/
- (void)presentSystemShareContent:(NSString * _Nullable)content image:(UIImage * _Nullable)image linkURL:(NSURL * _Nullable)url data:(NSData* _Nullable)data completion:(UIActivityViewControllerCompletionWithItemsHandler)itemsBlock;
/** 系统分享*/
- (void)presentSystemShareContent:(NSString *)content image:(UIImage *)image linkURL:(NSURL *)url completion:(UIActivityViewControllerCompletionWithItemsHandler)itemsBlock;

@end

NS_ASSUME_NONNULL_END
