//
//  TopicTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/24.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "TopicTableViewCell.h"

@implementation TopicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionClick:(id)sender {
    [self.delegate attentionClick:self];
}

- (IBAction)likeClick:(id)sender {
    [self.delegate likeClick:self];
}
@end
