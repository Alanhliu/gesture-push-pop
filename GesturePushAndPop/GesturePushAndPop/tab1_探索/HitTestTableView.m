//
//  HitTestTableView.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/31.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "HitTestTableView.h"

@interface HitTestTableView()
@end

@implementation HitTestTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    _touchOnSuperView = NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (self.touchOnSuperView) {
        return hitView.superview.superview.superview;
    } else {
        return hitView;
    }
}

@end
