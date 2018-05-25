//
//  DetailCollectionViewCell.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/24.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "DetailCollectionViewCell.h"
#import "UIView+Snapshot.h"
@interface DetailCollectionViewCell ()<UIGestureRecognizerDelegate>

//@property (nonatomic, strong) UIView *moveSnapshotView;

@end

@implementation DetailCollectionViewCell
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.moveContentView addGestureRecognizer:panGestureRecognizer];
}

static CGPoint startPoint;
static CGPoint originCenter;
static CGRect startRect;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = [recognizer locationInView:self];
        originCenter = self.moveContentView.center;
        startRect = self.moveContentView.frame;
        
//        self.moveSnapshotView = [self.moveContentView snapshotView];
//        self.moveSnapshotView.frame = startRect;
//        [self addSubview:self.moveSnapshotView];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint movePoint = [recognizer locationInView:self];
        
//        NSLog(@"%@",NSStringFromCGPoint(movePoint));
        
        self.moveContentView.center = CGPointMake(movePoint.x - startPoint.x+ originCenter.x, movePoint.y  - startPoint.y+originCenter.y);
        
//        self.moveSnapshotView.center = CGPointMake(movePoint.x - startPoint.x+ originCenter.x, movePoint.y  - startPoint.y+originCenter.y);
//
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        startPoint = CGPointZero;
        originCenter = CGPointZero;
        
        if (self.moveContentView.frame.origin.x > [UIScreen mainScreen].bounds.size.width*0.5) {
            if ([self.delegate respondsToSelector:@selector(dismissControllerFromCell:)]) {
                [self.delegate dismissControllerFromCell:self];
            }
        } else {
            self.moveContentView.frame = startRect;
        }
//        [self.moveSnapshotView removeFromSuperview];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer
{
    if ([recognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        CGFloat translation = [panRecognizer translationInView:recognizer.view].x;
        CGPoint velocity = [panRecognizer velocityInView:recognizer.view];
        if (velocity.x > 0 &&
            fabs(velocity.x) > fabs(velocity.y)) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

@end
