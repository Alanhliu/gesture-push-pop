//
//  ViewController4.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController4.h"

@interface ViewController4 ()<BaseAnimatedTransitioningViewControllerDelegate>

@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseAnimatedTransitioningDelegate = self;
}

- (void)baseAnimatedTransitioningHandle
{
    [self back:nil];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
