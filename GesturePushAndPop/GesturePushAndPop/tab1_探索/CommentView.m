//
//  CommentView.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/31.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "CommentView.h"
#import "HitTestTableView.h"
@interface CommentView ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CommentView

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
        self = [[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil].firstObject;
    }
    return self;
}

static CGPoint originPoint;
static CGRect originRect;
static CGPoint beginTouchPoint;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    originPoint = CGPointMake(0, 200);
    originRect = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizers:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// 给加的手势设置代理, 并实现此协议方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint pos = [pan velocityInView:pan.view];
        if (pos.y > 0) {
            if (self.tableView.contentOffset.y <= 0) {
                self.tableView.scrollEnabled = NO;
                return YES;
            }
        } else {
            self.tableView.scrollEnabled = YES;
            return NO;
        }
    }
    
    return NO;
}

- (void)panGestureRecognizers:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        beginTouchPoint = [gestureRecognizer locationInView:self.superview];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint moveTouchPoint = [gestureRecognizer locationInView:self.superview];
        self.frame = CGRectMake(0, originPoint.y+(moveTouchPoint.y - beginTouchPoint.y) , originRect.size.width, originRect.size.height);

    } else if (gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 1) {
        //self.tableView.touchOnSuperView = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.frame.origin.y < originPoint.y) {
            self.frame = originRect;
            //self.tableView.touchOnSuperView = NO;
        }
    }
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
