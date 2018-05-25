//
//  DetailTransitioning.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/24.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "DetailTransitioning.h"

@implementation DetailTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.show)//显示出来
    {
        UIView *containerView = [transitionContext containerView];
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        self.moveShapShotView.frame = self.currentRect;
        
        [containerView addSubview:toViewController.view];
        [containerView addSubview:self.moveShapShotView];
        
        [UIView animateWithDuration:duration animations:^{
            self.moveShapShotView.frame = [UIScreen mainScreen].bounds;
        } completion:^(BOOL finished) {
            [self.moveShapShotView removeFromSuperview];
            self.moveShapShotView = nil;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else//隐藏
    {
        UIView *containerView = [transitionContext containerView];
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        [containerView addSubview:toViewController.view];
        [containerView addSubview:self.moveShapShotView];
        [containerView addSubview:fromViewController.view];
        
        self.moveShapShotView.frame = self.fromRect;
        [UIView animateWithDuration:duration animations:^{
            self.moveShapShotView.frame = self.currentRect;
        } completion:^(BOOL finished) {
//            [self.moveShapShotView removeFromSuperview];
//            self.moveShapShotView = nil;
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
