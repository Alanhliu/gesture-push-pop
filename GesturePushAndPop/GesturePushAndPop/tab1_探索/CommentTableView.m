//
//  CommentTableView.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/6/4.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "CommentTableView.h"

@interface CommentTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) BOOL isDragging;

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

static CGPoint originPoint;
static CGRect originRect;

static CGPoint headerViewOriginPoint;
static CGRect headerViewOriginRect;

static CGPoint footerViewOriginPoint;
static CGRect footerViewOriginRect;

#define BACKGROUND_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]
//#define BACKGROUND_COLOR [UIColor clearColor]

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit
{
    self.isDragging = NO;
    
    CGRect controlViewRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    
    headerViewOriginPoint = CGPointMake(0, 200);
    headerViewOriginRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 30);
    
    originPoint = CGPointMake(0, 230);
    originRect = CGRectMake(0, 230, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 230 - 40);
    
    footerViewOriginPoint = CGPointMake(0, [UIScreen mainScreen].bounds.size.height - 40);
    footerViewOriginRect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, [UIScreen mainScreen].bounds.size.width, 40);
    
    self.delegate = self;
    self.dataSource = self;
    
    
    
    UIVisualEffectView *headerVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    CGRect headerViewBounds = {CGPointZero,headerViewOriginRect.size};
    headerVisualEffectView.frame = headerViewBounds;
    headerVisualEffectView.alpha = 0.5;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:headerViewBounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){8.0f, 8.0f}].CGPath;
    
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = headerViewOriginRect;
    self.headerView.layer.masksToBounds = YES;
    self.headerView.layer.mask = maskLayer;
    [self.headerView addSubview:headerVisualEffectView];
    
    
    self.footerView = [[UITextField alloc] init];
    self.footerView.frame = footerViewOriginRect;
    self.footerView.layer.cornerRadius = 8.0;
    self.footerView.layer.masksToBounds = YES;
    
    self.controlView = [[UIControl alloc] init];
    self.controlView.frame = controlViewRect;
    [self.controlView addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = BACKGROUND_COLOR;
    self.footerView.backgroundColor = [UIColor blackColor];
    
//    self.separatorColor = [UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>]
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.scrollEnabled = NO;
    CGFloat kHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = footerViewOriginRect;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height-kHeight-40;
    [UIView animateWithDuration:.25 animations:^{
        self.footerView.frame = rect;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollEnabled = YES;
    [UIView animateWithDuration:.25 animations:^{
        self.footerView.frame = footerViewOriginRect;
    }];
}

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
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = originRect;
            self.headerView.frame = headerViewOriginRect;
            self.footerView.frame = footerViewOriginRect;
        }];
    } else {
        [self hide];
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
        cell.backgroundColor = [UIColor clearColor];
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
    
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window addSubview:self.headerView];
    [window addSubview:self.footerView];
    [window addSubview:self.controlView];
    
    self.headerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, headerViewOriginRect.size.width, headerViewOriginRect.size.height);
    
    self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), originRect.size.width, originRect.size.height);
    
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), footerViewOriginRect.size.width, footerViewOriginRect.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = originRect;
        self.headerView.frame = headerViewOriginRect;
        self.footerView.frame = footerViewOriginRect;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.headerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, headerViewOriginRect.size.width, headerViewOriginRect.size.height);
        
        self.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), originRect.size.width, originRect.size.height);
        
        self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), footerViewOriginRect.size.width, footerViewOriginRect.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.headerView removeFromSuperview];
        [self.footerView removeFromSuperview];
        [self.controlView removeFromSuperview];
    }];
}

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
