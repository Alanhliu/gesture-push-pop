//
//  ViewController2Detail.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/23.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController2Detail : UIViewController
@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) CGRect currentRect;
@property (nonatomic, strong) UIView *moveShapShotView;
@end
