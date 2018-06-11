//
//  ViewController.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/18.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "UIView+Snapshot.h"
#import "UIViewController+Snapshot.h"
#import "CommentView.h"
#import "CommentTableView.h"
@interface ViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, assign) double progress;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, strong) UIImageView *screenShotView;

@property (nonatomic, strong) CommentTableView *commentTableView;

@property (nonatomic, assign) BOOL isShow;
@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次进入时查看之前记录的状态
    if (self.isShow) {
        //如果为打开状态，则恢复打开状态
        [self.commentTableView show:SHOW_HIDE_DURATION_DEFAULT];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //每次离开时记录commentTableView是否为打开状态
    self.isShow = self.commentTableView.isShow;
    if (self.commentTableView.isShow) {
        //如果为打开状态，则关闭
        [self.commentTableView hide:SHOW_HIDE_DURATION_IMEDIATELY];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.commentTableView = [[CommentTableView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNext) name:@"pushNext" object:nil];
}

- (void)pushNext
{
    [self push:nil];
}

- (IBAction)show:(id)sender {
    //这种方式通过，在临界点时切换手势作用在子view还是父view上，实现简单，
    //但在拖拽时，在临界点处始终无法，连贯流畅的拖拽，因为手势作用在不同view之间切换
    //所以，show2是目前比较好的实现方案
    CommentView *commentView = [[CommentView alloc] init];
    [commentView show];
}

- (IBAction)show2:(id)sender {
    
    [self.commentTableView show:SHOW_HIDE_DURATION_DEFAULT];
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
    if (self.operation == UINavigationControllerOperationPush) {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *snapshotView = fromViewController.snapshotView;
        
        snapshotView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:snapshotView];
        [containerView addSubview:toViewController.view];
        
        UITabBar *tabbar = fromViewController.tabBarController.tabBar;
        if (tabbar) {
            tabbar.hidden = YES;
        }
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        toViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [UIView animateWithDuration:duration animations:^{
            
            snapshotView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width*0.5, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            toViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            [snapshotView removeFromSuperview];
            tabbar.hidden = NO;
        }];
    } else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        
        fromViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UIView *snapshotView = toViewController.snapshotView;
        
        UIView *containerView = [transitionContext containerView];
        
        
        [containerView addSubview:toViewController.view];
        [containerView addSubview:snapshotView];
        [containerView addSubview:fromViewController.view];
        
        UITabBar *tabbar = toViewController.tabBarController.tabBar;
        if (tabbar) {
            tabbar.hidden = YES;
        }
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        snapshotView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width*0.5, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [UIView animateWithDuration:duration animations:^{
            
            fromViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            snapshotView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            [snapshotView removeFromSuperview];
            tabbar.hidden = NO;
        }];
    }
}


- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"end");
}


- (IBAction)push:(id)sender {
    ViewController2 *v2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
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
