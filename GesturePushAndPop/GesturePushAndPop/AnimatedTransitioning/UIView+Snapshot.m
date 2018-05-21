//
//  UIView+Snapshot.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "UIView+Snapshot.h"
#import <objc/runtime.h>

@implementation UIView (Snapshot)
- (UIImage *)snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)snapshot {
    
    UIView *view = objc_getAssociatedObject(self, @"AnimatedTransitioningSnapshot");
    if (!self) {
        view = [self snapshotViewAfterScreenUpdates:NO];
        [self setSnapshot:view];
    }
    
    return view;
}

- (void)setSnapshot:(UIView *)snapshot {
    
    objc_setAssociatedObject(self, @"AnimatedTransitioningSnapshot", snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
@end
