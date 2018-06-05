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
@end

@implementation CommentTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

static CGPoint originPoint;
static CGRect originRect;
static CGPoint beginTouchPoint;

static CGPoint headerViewOriginPoint;
static CGRect headerViewOriginRect;

- (void)commonInit
{
    self.isDragging = NO;
    originPoint = CGPointMake(0, 200);
    originRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    
    headerViewOriginPoint = CGPointMake(0, 170);
    headerViewOriginRect = CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 30);
    
    self.delegate = self;
    self.dataSource = self;
    
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = headerViewOriginRect;
    self.headerView.backgroundColor = [UIColor blackColor];
    
    self.footerView = [[UITextField alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
    self.footerView.backgroundColor = [UIColor blackColor];
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
    if (self.frame.origin.y - originPoint.y < 100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = originRect;
            self.headerView.frame = headerViewOriginRect;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, originRect.size.width, originRect.size.height);
            self.headerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, originRect.size.width, 30);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.headerView removeFromSuperview];
        }];
    }
}

- (void)panGestureRecognizers:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"not called");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (self.isDragging == NO) {
            beginTouchPoint = [gestureRecognizer locationInView:self.superview];
        }
        
        if (self.isDragging == NO) {
            self.isDragging = YES;
        }
        
        if (self.isDragging) {
            [self setContentOffset:CGPointMake(0, 0)];
        }
        
        CGPoint moveTouchPoint = [gestureRecognizer locationInView:self.superview];
        NSLog(@"y:%f",moveTouchPoint.y);
        
        if (originPoint.y+(moveTouchPoint.y - beginTouchPoint.y) >= originPoint.y) {
            
            self.frame = CGRectMake(0, originPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , originRect.size.width, originRect.size.height);
            self.headerView.frame = CGRectMake(0, headerViewOriginPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , headerViewOriginRect.size.width, headerViewOriginRect.size.height);
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
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+30, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-200);
    self.headerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, originRect.size.width, 30);
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-200);
        self.headerView.frame = headerViewOriginRect;
    }];
    
    [window addSubview:self.headerView];
}

- (void)hide
{
    [self removeFromSuperview];
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
