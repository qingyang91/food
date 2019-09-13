//
//  TopicTableViewCell.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/24.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TopicTableViewCellDelegate;

@interface TopicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speciallyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodIma;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic, assign) id<TopicTableViewCellDelegate>delegate;

- (IBAction)attentionClick:(id)sender;
- (IBAction)likeClick:(id)sender;

@end

@protocol TopicTableViewCellDelegate <NSObject>

- (void)attentionClick:(UITableViewCell *)cell;
- (void)likeClick:(UITableViewCell *)cell;

@end
NS_ASSUME_NONNULL_END
