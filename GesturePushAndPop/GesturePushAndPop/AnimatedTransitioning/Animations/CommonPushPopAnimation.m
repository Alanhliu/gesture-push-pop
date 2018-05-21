//
//  CommonPushPopAnimation.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "CommonPushPopAnimation.h"

@implementation CommonPushPopAnimation

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /**
     *  转场动画是两个控制器视图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
     */
    
    UIView *snapshotView = [fromViewController.view.window snapshotView];
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
    
    /**
     *  转场动画是两个控制器视图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
     */
    
    UIView *snapshotView = [fromViewController.view.window snapshotView];
    snapshotView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:snapshotView];
    
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    toViewController.view.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width*0.5, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
        snapshotView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        toViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        [snapshotView removeFromSuperview];
    }];
}

@end

@implementation CommonPushPopAnimationInteractive

- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext
{
   
}

- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

@end
