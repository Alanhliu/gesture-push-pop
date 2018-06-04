//
//  ViewController2Detail.m
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/23.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController2Detail.h"
#import "DetailCollectionViewCell.h"
#import "DetailTableViewCell.h"
#import "Message.h"
#import "DetailTransitioning.h"
@interface ViewController2Detail ()<UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,DetailCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DetailTransitioning *transitioning;
@property (nonatomic, assign) NSInteger lastRow;

@property (nonatomic, assign) CGRect dismissRect;
@end

@implementation ViewController2Detail

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //设置modal的方式，这样背后的控制器的view不会消失
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //转场管理者
    self.transitioningDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    [self.collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.presentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    self.lastRow = self.presentIndex / 3;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    Message *message = self.messageArray[indexPath.row];
    cell.textLabel.text = [@(message.msgId) stringValue];
    return cell;
}

static CGFloat init_y = 64;
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visibleCells = [collectionView visibleCells];
    NSIndexPath *needPath = [collectionView indexPathForCell:visibleCells.firstObject];
    
    CGFloat width = self.presentRect.size.width;
    CGFloat height = self.presentRect.size.height;
    
    NSInteger column = needPath.row % 3;
    NSInteger row = needPath.row / 3;

    CGFloat x = column*width + column*5;
    CGFloat y = self.presentRect.origin.y;
    
    CGFloat presentViewHeight = [UIScreen mainScreen].bounds.size.height-init_y;
    
    
    NSInteger minus = self.presentIndex - needPath.row;
    if (minus > 0) {//看旧的，视图上滚，手指下滑，y值变大
        if (self.lastRow != row)
            y = y + (row*height + row*5);
        
        if (y > presentViewHeight) {
            if ([self.delegate respondsToSelector:@selector(collectionViewDidScrollToPoint:)]) {
                [self.delegate collectionViewDidScrollToPoint:CGPointMake(0, -y)];
            }
            y = init_y;
        }
    } else if (minus < 0){//看新的，视图下滚，手指上滑，y值变小
        if (self.lastRow != row)
            y = y - (row*height + row*5);
        
        if (y < 0) {
            if ([self.delegate respondsToSelector:@selector(collectionViewDidScrollToPoint:)]) {
                [self.delegate collectionViewDidScrollToPoint:CGPointMake(0, -(y-init_y))];
            }
            y = init_y;
        }
    } else {//y不变，没有进行上下滑动
        
    }
    
    self.lastRow = row;
    self.presentRect = CGRectMake(x, y, width, height);
}

- (void)dismissControllerFromCell:(DetailCollectionViewCell *)cell
{
    CGRect rect = [cell convertRect:cell.moveContentView.frame toView:self.view];
    self.dismissRect = rect;
    self.transitioning.dismissRect = self.dismissRect;
    self.moveShapShotView = cell.moveContentView;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return [UIScreen mainScreen].bounds.size;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitioning.show = YES;
    self.transitioning.moveShapShotView = self.moveShapShotView;
    self.transitioning.presentRect = self.presentRect;
    return self.transitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitioning.show = NO;
    self.transitioning.moveShapShotView = self.moveShapShotView;
    self.transitioning.presentRect = self.presentRect;
    self.transitioning.dismissRect = self.dismissRect;
    return self.transitioning;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (DetailTransitioning *)transitioning
{
    if (!_transitioning) {
        _transitioning = [[DetailTransitioning alloc] init];
    }
    return _transitioning;
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
