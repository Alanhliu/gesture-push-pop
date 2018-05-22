//
//  BaseAnimatedTransitioningNavigationController.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const DEFAULT_ANIMATED_TRANSITIONING = @"CommonPushPopAnimation";
@interface BaseAnimatedTransitioningNavigationController : UINavigationController

@property (nonatomic, copy) NSString *customAnimatedTransitioning;

@end
