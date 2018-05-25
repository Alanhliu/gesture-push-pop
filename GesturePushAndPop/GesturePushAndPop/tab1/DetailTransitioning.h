//
//  DetailTransitioning.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/24.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DetailTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *moveShapShotView;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGRect currentRect;
@property (nonatomic, assign) CGRect fromRect;
@end
