//
//  ViewController.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/18.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "UIViewController+WHAnimationTransitioningSnapshot.h"
#import "UIView+ScreenCapture.m"
@interface ViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, assign) double progress;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, strong) UIImageView *screenShotView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    CGPoint translation = [recognizer velocityInView:recognizer.view];
    BOOL isGesturePush = NO;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        isGesturePush = translation.x<0 ? YES : NO;
    }
    if (isGesturePush) {
        progress = -progress;
    }
    progress = MIN(1.0, MAX(0.0, progress));
    self.progress = progress;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Create a interactive transition and pop the view controller
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        self.interactiveTransition.completionCurve = UIViewAnimationCurveEaseOut;
        [self push:nil];
        [self.interactiveTransition updateInteractiveTransition:0];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Update the interactive transition's progress
        self.p = [recognizer locationInView:self.view];
        
        [self.interactiveTransition updateInteractiveTransition:progress];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        // Finish or cancel the interactive transition
        if (progress > 0.25) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        
        self.interactiveTransition = nil;
    }
}

//为这个动画添加用户交互
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(nonnull id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

//用来自定义转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(nonnull UIViewController *)fromVC toViewController:(nonnull UIViewController *)toVC
{
    self.operation = operation;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"animateTransition------");
    
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//
//    CGRect thumbFrame = self.button.frame;
//    [toView setFrame:thumbFrame];
//
//    [[transitionContext containerView] addSubview:toView];
//
//    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
//    [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                     animations:^{
//                         [toView setFrame:toViewFinalFrame];
//                     }
//                     completion:^(BOOL finished) {
//                         if (![transitionContext transitionWasCancelled]) {
//                             [fromView removeFromSuperview];
//                             [transitionContext completeTransition:YES];
//                         }
//                         else {
//                             [toView removeFromSuperview];
//                             [transitionContext completeTransition:NO];
//                         }
//                     }];
    

    if (self.operation == UINavigationControllerOperationPush) {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        /**
         *  转场动画是两个控制器视图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
         */
        
        UIImage *fromImg = [fromViewController.view.window captureCurrentView];
        self.screenShotView.image = fromImg;
        self.screenShotView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:self.screenShotView];
        
        [containerView addSubview:toViewController.view];
//        [containerView insertSubview:self.screenShotView belowSubview:fromViewController.view];
        
        UITabBar *tabbar = self.tabBarController.tabBar;
        if (tabbar) {
            tabbar.hidden = YES;
        }
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        toViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        [UIView animateWithDuration:duration animations:^{
//            toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            self.screenShotView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width*0.5, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            toViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            self.screenShotView.image = nil;
            [self.screenShotView removeFromSuperview];
            tabbar.hidden = NO;
        }];
    } else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        /**
         *  转场动画是两个控制器视图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行。
         */
        UIView *containerView = [transitionContext containerView];
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        /**
         *  执行动画，我们让fromVC的视图移动到屏幕最右侧
         */
        [UIView animateWithDuration:duration animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        }completion:^(BOOL finished) {
            /**
             *  当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
             */
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}


- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"end");
}

//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if (viewController.hidesBottomBarWhenPushed) {
//        self.tabBarController.tabBar.hidden = YES;
//    } else {
//        self.tabBarController.tabBar.hidden = NO;
//    }
//}


- (IBAction)push:(id)sender {
    ViewController2 *v2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
    v2.hidesBottomBarWhenPushed;
    [self.navigationController pushViewController:v2 animated:YES];
}

- (UIImageView *)screenShotView
{
    if (!_screenShotView) {
        _screenShotView = [UIImageView new];
    }
    return _screenShotView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
