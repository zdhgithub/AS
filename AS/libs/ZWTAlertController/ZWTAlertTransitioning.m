//
//  ZWTAlertTransitioning.m
//  AlertDemo
//
//  Created by 游兵 on 2019/3/19.
//  Copyright © 2019 游兵. All rights reserved.
//

#import "ZWTAlertTransitioning.h"
#import "ZWTAlertController.h"
#import "ZWTAlertBaseView.h"

@implementation ZWTAlertTransitioning

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
        toVC.contentView.textFields = toVC.textFields;
        toVC.contentView.textViews = toVC.textViews;
        toVC.contentView.actions = toVC.actions;
        toVC.bgView.alpha = 0.4;
        [UIView animateWithDuration:duration animations:^{
            toVC.bgView.alpha = 0.4;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else if (fromVC.isBeingDismissed) {
        
        fromVC.bgView.alpha = 0;
        [UIView animateWithDuration:duration animations:^{
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
