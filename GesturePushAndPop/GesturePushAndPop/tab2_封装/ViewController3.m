//
//  ViewController3.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController3.h"
#import "ViewController4.h"
@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushInteractiveEnabel = YES;
}

- (void)baseAnimatedInteractiveTransitioningPushAction
{
    [self push:nil];
}

- (void)baseAnimatedInteractiveTransitioningPopAction
{

}

- (IBAction)push:(id)sender {
    ViewController4 *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController4"];
    vc4.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc4 animated:YES];
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
