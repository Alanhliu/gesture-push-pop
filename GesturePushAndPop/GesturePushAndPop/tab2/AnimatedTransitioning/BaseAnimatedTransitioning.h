//
//  BaseAnimatedTransitioning.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Snapshot.h"
#import "UIViewController+Snapshot.h"
@interface BaseAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactiveTransition;

/// 创建动画效果的实例对象并设置动画类型, push or pop
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType;

/// 创建动画效果的实例对象并设置动画类型和间隔时间
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration;

/// 创建动画效果实例对象并设置动画类型/间隔时间/可交互属性
+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration interactiveTransition:(UIPercentDrivenInteractiveTransition *)interactiveTransition;

- (instancetype)initWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration;

#pragma mark - 真正实现 push, pop 动画的方法, 具体实现交给子类
- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext;

- (void)pushEnded;
- (void)popEnded;

@end
