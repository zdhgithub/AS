//
//  KTCenterAnimationController.m
//  ZWTAlertController
//
//  Created by Kevin on 16/8/14.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ZWTActionSheetTransitioning.h"
#import "ZWTAlertController.h"
#import "ZWTAlertBaseView.h"

@implementation ZWTActionSheetTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = (ZWTAlertController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (toVC.isBeingPresented) {
        return 0.3;
    }
    else if (fromVC.isBeingDismissed) {
        return 0.1;
    }
    
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ZWTAlertController *toVC = (ZWTAlertController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ZWTAlertController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (!toVC || !fromVC) {
        return;
    }
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (toVC.isBeingPresented) {
        [containerView addSubview:toVC.view];
        toVC.view.frame = CGRectMake(0.0, 0.0, containerView.frame.size.width, containerView.frame.size.height);
        toVC.contentView.actions = toVC.actions;
        toVC.contentView.transform = CGAffineTransformMakeTranslation(0, toVC.contentView.frame.size.height);
        toVC.bgView.alpha = 0;
        [UIView animateWithDuration:duration animations:^{
            toVC.contentView.transform = CGAffineTransformIdentity;
            toVC.bgView.alpha = 0.4;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else if (fromVC.isBeingDismissed) {
        
        [UIView animateWithDuration:duration animations:^{
            fromVC.contentView.transform = CGAffineTransformMakeTranslation(0, fromVC.contentView.frame.size.height);
            fromVC.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
