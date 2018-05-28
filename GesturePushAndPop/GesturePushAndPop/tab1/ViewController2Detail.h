//
//  ViewController2Detail.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/23.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewController2DetailDelegate <NSObject>

- (void)collectionViewDidScrollToIndexPath:(NSIndexPath *)indexPath;

@end

@interface ViewController2Detail : UIViewController
@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, assign) NSUInteger presentIndex;
@property (nonatomic, assign) CGRect presentRect;
@property (nonatomic, assign) CGRect presentRectForCal_y;
@property (nonatomic, strong) UIView *moveShapShotView;

@property (nonatomic, weak) id<ViewController2DetailDelegate> delegate;

@end
