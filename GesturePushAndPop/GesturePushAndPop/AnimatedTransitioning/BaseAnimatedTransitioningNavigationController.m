//
//  BaseAnimatedTransitioningNavigationController.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "BaseAnimatedTransitioningNavigationController.h"
#import "BaseAnimatedTransitioning.h"
#import "BaseAnimatedTransitioningViewController.h"
@interface BaseAnimatedTransitioningNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseAnimatedTransitioningNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
}

//为这个动画添加用户交互
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(BaseAnimatedTransitioning *) animationController  {
    
    return animationController.interactiveTransition;
}

//用来自定义转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(BaseAnimatedTransitioningViewController *)fromVC
                                                 toViewController:(BaseAnimatedTransitioningViewController *)toVC {
    
    Class class = NSClassFromString(@"CommonPushPopAnimation");
    
    if (fromVC.interactiveTransition) {
        
        Class classInteractive = NSClassFromString(@"CommonPushPopAnimation");
        BaseAnimatedTransitioning *baseAnimation = [[classInteractive alloc] initWithType:operation duration:0.6];
        baseAnimation.interactiveTransition = fromVC.interactiveTransition;
        return baseAnimation;  // 手势
    } else{
        return [[class alloc] initWithType:operation duration:0.6];  // 非手势
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
