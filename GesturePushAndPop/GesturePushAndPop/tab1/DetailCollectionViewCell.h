//
//  DetailCollectionViewCell.h
//  GesturePushAndPop
//
//  Created by siasun on 2018/5/24.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailCollectionViewCellDelegate <NSObject>

- (void)dismissControllerFromCell:(UICollectionViewCell *)cell;
//- (void)

@end

@interface DetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *moveContentView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, weak) id<DetailCollectionViewCellDelegate> delegate;
@end
