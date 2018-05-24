


//
//  DetailTableViewCell.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/24.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint startPoint;
    CGPoint originCenter;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = [recognizer locationInView:self];
        originCenter = self.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint movePoint = [recognizer locationInView:self];
        
        NSLog(@"%@",NSStringFromCGPoint(movePoint));
        if (movePoint.x - startPoint.x > 0) {
            //->右移
        } else {
            
        }
        
//        self.bounds = CGRectMake(0, 0, 100, 200);
//        self.center = CGPointMake(movePoint.x - startPoint.x+ originCenter.x, movePoint.y  - startPoint.y+originCenter.y);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
