//
//  CommentTableView.m
//  GesturePushAndPop
//
//  Created by hliu on 2018/6/4.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "CommentTableView.h"

@interface CommentTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign, readwrite) BOOL isShow;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL isKeyboardShow;

@property (nonatomic, assign) CGPoint commentToPoint;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *footerView;
@property (nonatomic, strong) UIControl *controlView;
@end

@implementation CommentTableView

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

static CGPoint beginTouchPoint;

static CGRect controlViewOriginRect;

static CGPoint originPoint;
static CGRect originRect;

static CGPoint headerViewOriginPoint;
static CGRect headerViewOriginRect;

static CGPoint footerViewOriginPoint;
static CGRect footerViewOriginRect;

#define BACKGROUND_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit
{
    self.isShow = NO;
    self.isDragging = NO;
    self.isKeyboardShow = NO;
    self.commentToPoint = CGPointZero;
    
    controlViewOriginRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    
    headerViewOriginPoint = CGPointMake(0, 200);
    headerViewOriginRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 30);
    
    originPoint = CGPointMake(0, 230);
    originRect = CGRectMake(0, 230, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 230 - 40);
    
    footerViewOriginPoint = CGPointMake(0, [UIScreen mainScreen].bounds.size.height - 40);
    footerViewOriginRect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40);
    
    self.delegate = self;
    self.dataSource = self;
    
    
    CGRect headerViewBounds = {CGPointZero,headerViewOriginRect.size};
    
    UIVisualEffectView *headerVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    headerVisualEffectView.frame = headerViewBounds;
    headerVisualEffectView.alpha = 0.5;
    
    CAShapeLayer *headerMaskLayer = [CAShapeLayer layer];
    headerMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:headerViewBounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){8.0f, 8.0f}].CGPath;
    
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = headerViewOriginRect;
    self.headerView.layer.masksToBounds = YES;
    self.headerView.layer.mask = headerMaskLayer;
    [self.headerView addSubview:headerVisualEffectView];
    
    //这个button不太相关，只是为了测试
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 0, 100, headerViewBounds.size.height);
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushNext) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:button];
    
    
    CGRect footerViewBounds = {CGPointZero,footerViewOriginRect.size};
    
    CAShapeLayer *footerMaskLayer = [CAShapeLayer layer];
    footerMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:footerViewBounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){8.0f, 8.0f}].CGPath;
    
    self.footerView = [[UITextField alloc] init];
    self.footerView.frame = footerViewOriginRect;
    self.footerView.layer.masksToBounds = YES;
    self.footerView.layer.mask = footerMaskLayer;
    self.footerView.returnKeyType = UIReturnKeySend;
    
    self.controlView = [[UIControl alloc] init];
    self.controlView.frame = controlViewOriginRect;
    [self.controlView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = BACKGROUND_COLOR;
    self.footerView.backgroundColor = [UIColor blackColor];
    
//    self.separatorColor = [UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)pushNext
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNext" object:nil];
}

#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.scrollEnabled = NO;
    self.isKeyboardShow = YES;
    
    CGFloat kHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect controlToRect = controlViewOriginRect;
    controlToRect.size.height = [UIScreen mainScreen].bounds.size.height-kHeight-footerViewOriginRect.size.height;
    
    CGRect footerToRect = footerViewOriginRect;
    footerToRect.origin.y = [UIScreen mainScreen].bounds.size.height-kHeight-40;

    CGRect selfToRect = originRect;
    CGRect headerToRect = headerViewOriginRect;
    
    //当评论的cell被遮住时，让自身偏移到评论cell刚刚好在输入框上面的位置
    if (CGPointEqualToPoint(self.commentToPoint,CGPointZero) == NO &&
        ([UIScreen mainScreen].bounds.size.height - kHeight - footerViewOriginRect.size.height) < self.commentToPoint.y) {
        selfToRect.origin.y = originPoint.y - (self.commentToPoint.y - ([UIScreen mainScreen].bounds.size.height - kHeight - footerViewOriginRect.size.height));
        headerToRect.origin.y = headerViewOriginPoint.y - (self.commentToPoint.y - ([UIScreen mainScreen].bounds.size.height - kHeight - footerViewOriginRect.size.height));
    }

    [UIView animateWithDuration:.25 animations:^{
        self.footerView.frame = footerToRect;
        self.controlView.frame = controlToRect;
        self.frame = selfToRect;
        self.headerView.frame = headerToRect;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollEnabled = YES;
    self.isKeyboardShow = NO;
    [UIView animateWithDuration:.25 animations:^{
        self.footerView.frame = footerViewOriginRect;
        self.controlView.frame = controlViewOriginRect;
        self.frame = originRect;
        self.headerView.frame = headerViewOriginRect;
    } completion:^(BOOL finished) {
        self.commentToPoint = CGPointZero;
    }];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0 ||
        self.isDragging == YES) {
        [self panGestureRecognizers:scrollView.panGestureRecognizer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDragging = NO;
    if (self.frame.origin.y - originPoint.y < 150) {
        [UIView animateWithDuration:SHOW_HIDE_DURATION_DEFAULT animations:^{
            self.frame = originRect;
            self.headerView.frame = headerViewOriginRect;
            self.footerView.frame = footerViewOriginRect;
        }];
    } else {
        [self hide:SHOW_HIDE_DURATION_DEFAULT];
    }
}

- (void)panGestureRecognizers:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"not called");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (self.isDragging == NO) {
            self.isDragging = YES;
            
            beginTouchPoint = [gestureRecognizer locationInView:self.superview];
        } else {
            [self setContentOffset:CGPointMake(0, 0)];
        }
        
        CGPoint moveTouchPoint = [gestureRecognizer locationInView:self.superview];
        //NSLog(@"y:%f",moveTouchPoint.y);
        
        if (originPoint.y+(moveTouchPoint.y - beginTouchPoint.y) >= originPoint.y) {
            
            self.frame = CGRectMake(0, originPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , originRect.size.width, originRect.size.height);
            self.headerView.frame = CGRectMake(0, headerViewOriginPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , headerViewOriginRect.size.width, headerViewOriginRect.size.height);
            self.footerView.frame = CGRectMake(0, footerViewOriginPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , footerViewOriginRect.size.width, footerViewOriginRect.size.height);
        }
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        NSLog(@"not called");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"not called");
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [@(indexPath.row) stringValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self convertRect:cell.frame toView:window];
    self.commentToPoint = CGPointMake(0, CGRectGetMaxY(rect));
    [self.footerView becomeFirstResponder];
}

#pragma mark - show / hide
- (void)show:(NSTimeInterval)duration
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window addSubview:self.headerView];
    [window addSubview:self.footerView];
    [window addSubview:self.controlView];
    
    self.headerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, headerViewOriginRect.size.width, headerViewOriginRect.size.height);
    
    self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), originRect.size.width, originRect.size.height);
    
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), footerViewOriginRect.size.width, footerViewOriginRect.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = originRect;
        self.headerView.frame = headerViewOriginRect;
        self.footerView.frame = footerViewOriginRect;
    } completion:^(BOOL finished) {
        self.isShow = YES;
    }];
}

- (void)hide
{
    [self hide:SHOW_HIDE_DURATION_DEFAULT];
}

- (void)hide:(NSTimeInterval)duration
{
    if (self.isKeyboardShow) {
        [self.footerView resignFirstResponder];
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        self.headerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, headerViewOriginRect.size.width, headerViewOriginRect.size.height);
        
        self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), originRect.size.width, originRect.size.height);
        
        self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), footerViewOriginRect.size.width, footerViewOriginRect.size.height);
    } completion:^(BOOL finished) {
        self.isShow = NO;
        [self removeFromSuperview];
        [self.headerView removeFromSuperview];
        [self.footerView removeFromSuperview];
        [self.controlView removeFromSuperview];
    }];
}

#pragma mark - setting
- (void)setIsDragging:(BOOL)isDragging
{
    _isDragging = isDragging;
    if (isDragging) {
        self.showsVerticalScrollIndicator = NO;
    } else {
        self.showsVerticalScrollIndicator = YES;
    }
}

@end
