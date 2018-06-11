//
//  CommentTableView.h
//  GesturePushAndPop
//
//  Created by hliu on 2018/6/4.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHOW_HIDE_DURATION_DEFAULT 0.2
#define SHOW_HIDE_DURATION_IMEDIATELY 0 

@interface CommentTableView : UITableView

@property (nonatomic, assign, readonly) BOOL isShow;

- (void)show:(NSTimeInterval)duration;
- (void)hide:(NSTimeInterval)duration;

@end
