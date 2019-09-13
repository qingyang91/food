//
//  KitchenDetailTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/18.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KitchenDetailTableViewCellDelegate;

@interface KitchenDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *collecBtn;

@property (nonatomic, assign) id<KitchenDetailTableViewCellDelegate>delegate;
- (IBAction)collectionClick:(id)sender;

@end

@protocol KitchenDetailTableViewCellDelegate

- (void)collection:(UITableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
