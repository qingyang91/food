//
//  MyCreationTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "MyCreationTableViewCell.h"

@implementation MyCreationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteClick:(id)sender {
    [self.delegate deleteCreation:self];
}

- (IBAction)creditClick:(id)sender {
    [self.delegate creaditCreation:self];
}
@end
