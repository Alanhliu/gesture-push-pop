//
//  UIViewController+Snapshot.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/22.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "UIViewController+Snapshot.h"
#import <objc/runtime.h>

@implementation UIViewController (Snapshot)

- (UIView *)snapshotView {
    
    UIView *view = objc_getAssociatedObject(self, @"AnimatedTransitioningSnapshot");
    if (!view) {
        view = [self.view.window snapshotViewAfterScreenUpdates:NO];
        [self setSnapshotView:view];
    }
    
    return view;
}

- (void)setSnapshotView:(UIView *)snapshotView {
    
    objc_setAssociatedObject(self, @"AnimatedTransitioningSnapshot", snapshotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
@end
