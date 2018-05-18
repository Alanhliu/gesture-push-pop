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
@interface ViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, assign) double progress;
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
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.6;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    fromVc.view.hidden = YES;
    

    [[transitionContext containerView] addSubview:fromVc.snapshot];
    [[transitionContext containerView] addSubview:toVc.view];
    [[toVc.navigationController.view superview] insertSubview:fromVc.snapshot belowSubview:toVc.navigationController.view];
    toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(bounds), 0.0);
    
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromVc.snapshot.alpha = 0.5;
                         fromVc.snapshot.transform = CGAffineTransformMakeTranslation(-bounds.size.width/2, 0.0);
                         toVc.navigationController.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                         toVc.view.frame = CGRectMake(self.p.x, self.p.y, toVc.view.frame.size.width*self.progress, toVc.view.frame.size.height*self.progress);
                     }
                     completion:^(BOOL finished) {
                         fromVc.view.hidden = NO;
                         
                         [fromVc.snapshot removeFromSuperview];
                         [toVc.snapshot removeFromSuperview];
                         [[transitionContext containerView] addSubview:toVc.view];
                         [transitionContext completeTransition:YES];
                     }];
}


- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"end");
}

- (IBAction)push:(id)sender {
    ViewController2 *v2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
    [self.navigationController pushViewController:v2 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
