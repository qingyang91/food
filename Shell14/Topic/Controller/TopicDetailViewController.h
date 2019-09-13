//
//  TopicDetailViewController.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "QMUICommonViewController.h"
#import "TopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicDetailViewController : QMUICommonViewController

@property (nonatomic, assign) NSInteger isAttention;
@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, strong) TopicModel *model;
@property (nonatomic, strong) MyTopicModel *topModel;
@property (weak, nonatomic) IBOutlet UIImageView *headIma;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speciaLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodIma;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *loveNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;



- (IBAction)likeClick:(id)sender;

- (IBAction)attentionClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
