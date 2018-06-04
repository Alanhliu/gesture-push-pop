//
//  BaseAnimatedTransitioningViewController.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

//
static NSString *const AnimatedTransitioning_DragPop = @"DragPopAnimation";

@interface BaseAnimatedTransitioningViewController : UIViewController
@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactiveTransition;

/**
 default NO
 */
@property (nonatomic, assign) BOOL pushInteractiveEnabel;

/**
 default YES
 */
@property (nonatomic, assign) BOOL popInteractiveEnabel;

- (void)baseAnimatedInteractiveTransitioningPushAction;
- (void)baseAnimatedInteractiveTransitioningPopAction;

- (void)baseAnimatedInteractiveTransitioningTouch;

- (void)useDefaultAnimatedTransitioning;
- (void)setCustomAnimatedTransitioning:(NSString *)customAT;
@end
