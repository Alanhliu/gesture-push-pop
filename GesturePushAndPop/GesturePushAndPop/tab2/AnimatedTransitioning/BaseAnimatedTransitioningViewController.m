//
//  BaseAnimatedTransitioningViewController.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "BaseAnimatedTransitioningViewController.h"
#import "BaseAnimatedTransitioningNavigationController.h"
@interface BaseAnimatedTransitioningViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL isGesturePush;

@end

@implementation BaseAnimatedTransitioningViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _pushInteractiveEnabel = NO;
    _popInteractiveEnabel = YES;
}

- (void)baseAnimatedInteractiveTransitioningPushAction{}
- (void)baseAnimatedInteractiveTransitioningPopAction{}

- (void)useDefaultAnimatedTransitioning
{
    ((BaseAnimatedTransitioningNavigationController *)self.navigationController).customAnimatedTransitioning = DEFAULT_ANIMATED_TRANSITIONING;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    CGPoint translation = [recognizer velocityInView:recognizer.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.isGesturePush = translation.x<0 ? YES : NO;
    }
    
    if (self.isGesturePush) {
        progress = -progress;
    }
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        // Create a interactive transition and
        // push or pop the view controller
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        if (self.isGesturePush) {
            [self baseAnimatedInteractiveTransitioningPushAction];
        } else {
            [self baseAnimatedInteractiveTransitioningPopAction];
        }
        
        [self.interactiveTransition updateInteractiveTransition:0];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Update the interactive transition's progress
        [self.interactiveTransition updateInteractiveTransition:progress];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        
        // Finish or cancel the interactive transition
        if (progress > 0.25) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
        }
        
        self.interactiveTransition = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer velocityInView:recognizer.view];
    BOOL isGesturePush = translation.x<0 ? YES : NO;
    if (isGesturePush) {
        if (!self.pushInteractiveEnabel)
            return NO;
    } else {
        if (!self.popInteractiveEnabel)
            return NO;
    }
    return YES;
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
