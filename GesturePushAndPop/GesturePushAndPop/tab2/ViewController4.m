//
//  ViewController4.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/21.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController4.h"
#import "ViewController5.h"
@interface ViewController4 ()

@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushInteractiveEnabel = YES;
}

- (void)baseAnimatedInteractiveTransitioningPopAction
{
    [self back:nil];
}

- (void)baseAnimatedInteractiveTransitioningPushAction
{
    [self push:nil];
}

- (IBAction)push:(id)sender {
    ViewController5 *vc5 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController5"];
    [self.navigationController pushViewController:vc5 animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)alert:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"测试alertController在自定义push/pop转场时的可用性" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:confirm];
    [self presentViewController:alertController animated:YES completion:nil];
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
