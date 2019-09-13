//
//  AttentionTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/18.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AttentionTableViewCellDelegate;

@interface AttentionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *despriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (nonatomic, assign) id<AttentionTableViewCellDelegate>delegate;
- (IBAction)attentionClick:(id)sender;

@end

@protocol AttentionTableViewCellDelegate

- (void)attention:(UITableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
