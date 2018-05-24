//
//  DragPopAnimation.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/22.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "DragPopAnimation.h"

@implementation DragPopAnimation

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *snapshotView = fromViewController.snapshotView;
    
    snapshotView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:snapshotView];
    [containerView addSubview:toViewController.view];
    
    UITabBar *tabbar = fromViewController.tabBarController.tabBar;
    if (tabbar) {
        tabbar.hidden = YES;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    toViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
        snapshotView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width*0.5, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        toViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        [snapshotView removeFromSuperview];
        tabbar.hidden = NO;
    }];
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    fromViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIView *snapshotView = toViewController.snapshotView;
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:snapshotView];
    [containerView addSubview:fromViewController.view];
    
    UITabBar *tabbar = toViewController.tabBarController.tabBar;
    if (tabbar) {
        tabbar.hidden = YES;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    snapshotView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
        fromViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        snapshotView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        [snapshotView removeFromSuperview];
        tabbar.hidden = NO;
    }];
}


@end
