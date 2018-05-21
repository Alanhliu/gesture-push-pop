//
//  BaseAnimatedTransitioning.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "BaseAnimatedTransitioning.h"

const static NSTimeInterval AnimationTransitioningDuration = 0.6;
@interface BaseAnimatedTransitioning ()

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) UINavigationControllerOperation transitionType;

@end

@implementation BaseAnimatedTransitioning


- (instancetype)init {
    
    if (self = [self initWithType:UINavigationControllerOperationPush duration:AnimationTransitioningDuration]) {
    }
    return self;
}

// 主要的构造方法
- (instancetype)initWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration {
    
    if (self = [super init]) {
        self.duration = duration;
        self.transitionType = transitionType;
    }
    return self;
}

+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType {
    
    return [self transitionWithType:transitionType duration:AnimationTransitioningDuration];
}

+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType
                          duration:(NSTimeInterval)duration {
    
    return [self transitionWithType:transitionType duration:duration interactiveTransition:nil];
}

+ (instancetype)transitionWithType:(UINavigationControllerOperation)transitionType duration:(NSTimeInterval)duration interactiveTransition:(UIPercentDrivenInteractiveTransition *)interactiveTransition {
    
    BaseAnimatedTransitioning *animationTransitioning = [[self alloc] initWithType:transitionType duration:duration];
    animationTransitioning.interactiveTransition = interactiveTransition;
    return animationTransitioning;
}


- (void)push:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)pop:(id<UIViewControllerContextTransitioning>)transitionContext {}
- (void)pushEnded {}
- (void)popEnded {}



#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.transitionType == UINavigationControllerOperationPush) {
        [self push:transitionContext];
    }
    else if (self.transitionType == UINavigationControllerOperationPop) {
        [self pop:transitionContext];
    }
}


- (void)animationEnded:(BOOL) transitionCompleted {
    
    if (!transitionCompleted) return;
    
    if (self.transitionType == UINavigationControllerOperationPush) {
        [self pushEnded];
    }
    else if (self.transitionType == UINavigationControllerOperationPop) {
        [self popEnded];
    }
}

@end
