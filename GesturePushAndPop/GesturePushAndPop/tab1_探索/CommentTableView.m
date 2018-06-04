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
@property (nonatomic, assign) CGPoint lastContentOffset;
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
- (void)commonInit
{
    _isDragging = NO;
    originPoint = CGPointMake(0, 200);
    originRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    
    self.delegate = self;
    self.dataSource = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0 ||
        scrollView.contentOffset.y - self.lastContentOffset.y > 0) {
        [self panGestureRecognizers:scrollView.panGestureRecognizer];
    }
    self.lastContentOffset = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _isDragging = NO;
    if (self.frame.origin.y - originPoint.y < 100) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = originRect;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, originRect.size.width, originRect.size.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)panGestureRecognizers:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"not called");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (_isDragging == NO) {
            beginTouchPoint = [gestureRecognizer locationInView:self];
        }
        
        if (_isDragging == NO) {
            _isDragging = YES;
        }
        
        CGPoint moveTouchPoint = [gestureRecognizer locationInView:self];
        NSLog(@"%@",NSStringFromCGPoint(moveTouchPoint));
        
        self.frame = CGRectMake(0, originPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , originRect.size.width, originRect.size.height);
        
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
    self.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-200);
}

- (void)hide
{
    [self removeFromSuperview];
}

@end
