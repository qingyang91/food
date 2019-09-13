//
//  HotTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/18.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HotTableViewCellDelegate;

@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *personHead;
@property (weak, nonatomic) IBOutlet UILabel *loveNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (nonatomic, assign) id<HotTableViewCellDelegate>delegate;
- (IBAction)loveBtn:(id)sender;

@end

@protocol HotTableViewCellDelegate

- (void)collection:(UITableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
