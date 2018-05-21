//
//  BaseAnimatedTransitioningViewController.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseAnimatedTransitioningViewControllerDelegate <NSObject>

- (void)baseAnimatedTransitioningHandle;

@end

@interface BaseAnimatedTransitioningViewController : UIViewController
@property (nonatomic, weak) id<BaseAnimatedTransitioningViewControllerDelegate> baseAnimatedTransitioningDelegate;
@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end
