//
//  ViewController2.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/18.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController2Detail.h"
#import "Message.h"
#import "VC2CollectionViewCell.h"
@interface ViewController2 ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGPoint p;
@property (nonatomic, assign) double progress;
@property (nonatomic, strong) NSMutableArray *messageArray;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.messageArray = [NSMutableArray new];
    for (int i = 1; i<= 20; i++) {
        Message *message = [Message new];
        message.msgId = i;
        [self.messageArray addObject:message];
    }
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
        self.interactiveTransition.completionCurve = UIViewAnimationCurveLinear;
        [self.navigationController popViewControllerAnimated:YES];
        [self.interactiveTransition updateInteractiveTransition:0];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        // Update the interactive transition's progress
        self.p = [recognizer locationInView:self.view];
        NSLog(@"%@",NSStringFromCGPoint(self.p));
        
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

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                                 interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC
{
    return self;
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
    
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];

    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    
    
    fromViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration animations:^{
       
        fromViewController.view.frame = CGRectMake(100, 100, 100, 100);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        [fromViewController.view removeFromSuperview];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self.view.superview];
    CGPoint previousPoint = [touch previousLocationInView:self.view.superview];
    
    CGPoint center = self.view.center;
    
    center.x += (currentPoint.x - previousPoint.x);
    center.y += (currentPoint.y - previousPoint.y);
    self.view.center = center;
}

- (void)animationEnded:(BOOL) transitionCompleted {
    NSLog(@"end");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VC2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Message *message = self.messageArray[indexPath.row];
    cell.textLabel.text = [@(message.msgId) stringValue];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController2Detail *vc2d = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2Detail"];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = cell.frame;
    
    vc2d.messageArray = self.messageArray;
    vc2d.currentIndex = indexPath.row;
    vc2d.moveShapShotView = [cell snapshotViewAfterScreenUpdates:NO];
    vc2d.currentRect = rect;
    
    [self presentViewController:vc2d animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-10)/3, 160) ;
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
