//
//  MyAttentionViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyAttentionViewCellDelegate;

@interface MyAttentionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (nonatomic ,assign) id<MyAttentionViewCellDelegate>delegate;
- (IBAction)attentionClick:(id)sender;

@end

@protocol MyAttentionViewCellDelegate

- (void)cancelAttention:(UITableViewCell *)cell;

@end

NS_ASSUME_NONNULL_END
