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

        self.moveShapShotView.frame = self.presentRect;

        [containerView addSubview:toViewController.view];
        [containerView addSubview:self.moveShapShotView];

        [UIView animateWithDuration:duration animations:^{
            self.moveShapShotView.frame = [UIScreen mainScreen].bounds;
        } completion:^(BOOL finished) {
            [self.moveShapShotView removeFromSuperview];
            self.moveShapShotView = nil;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
        
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView *containerView = [transitionContext containerView];
//        NSTimeInterval duration = [self transitionDuration:transitionContext];
//
//        // 对fromVC.view的截图添加动画效果
//        UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
//        tempView.frame = fromVC.view.frame;
//
//        // 对截图添加动画，则fromVC可以隐藏
//        fromVC.view.hidden = YES;
//
//        // 要实现转场，必须加入到containerView中
//        [containerView addSubview:tempView];
//        [containerView addSubview:toVC.view];
//
//        // 我们要设置外部所传参数
//        // 设置呈现的高度
//        toVC.view.frame = CGRectMake(0,
//                                     containerView.frame.size.height,
//                                     containerView.frame.size.width,
//                                     600);
//
//        // 开始动画
//        [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:0 animations:^{
//            // 在Y方向移动指定的高度
//            toVC.view.transform = CGAffineTransformMakeTranslation(0, -600);
//
//            // 让截图缩放
//            tempView.transform = CGAffineTransformMakeScale(0.5,0.5);
//        } completion:^(BOOL finished) {
//            if (finished) {
//                [transitionContext completeTransition:YES];
//            }
//        }];
        
    }
    else//隐藏
    {
        UIView *containerView = [transitionContext containerView];
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        NSTimeInterval duration = [self transitionDuration:transitionContext];


        self.moveShapShotView.frame = self.dismissRect;
        [UIView animateWithDuration:duration animations:^{
            self.moveShapShotView.frame = self.presentRect;
        } completion:^(BOOL finished) {
            [self.moveShapShotView removeFromSuperview];
            self.moveShapShotView = nil;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
//        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.moveShapShotView.frame = self.presentRect;
//        } completion:^(BOOL finished) {
//            [self.moveShapShotView removeFromSuperview];
//            self.moveShapShotView = nil;
//            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//        }];
        
        
        // 取出present时的截图用于动画
//        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView *containerView = [transitionContext containerView];
//        UIView *tempView = containerView.subviews.lastObject;
//        NSTimeInterval duration = [self transitionDuration:transitionContext];
//
//        // 开始动画
//        [UIView animateWithDuration:duration animations:^{
//            toVC.view.transform = CGAffineTransformIdentity;
//            fromVC.view.transform = CGAffineTransformIdentity;
//
//        } completion:^(BOOL finished) {
//            if (finished) {
//                [transitionContext completeTransition:YES];
//                toVC.view.hidden = NO;
//
//                // 将截图去掉
//                [tempView removeFromSuperview];
//            }
//        }];
    }
}

@end
