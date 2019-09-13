
//
//  LeftTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/17.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? [UIColor colorWithHexString:@"#F7F7F7"] : [UIColor clearColor];
    self.titleLabel.textColor =  selected ? [UIColor colorWithHexString:@"#FA8C16"] : [UIColor blackColor];
    // Configure the view for the selected state
}

@end
