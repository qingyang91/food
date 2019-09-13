//
//  StepTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/23.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "StepTableViewCell.h"
#import "HeightFont.h"

@implementation StepTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    
    _stepOneLabel = [[UILabel alloc]init];
    _stepOneLabel.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:_stepOneLabel];
    [_stepOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(AutoHeight(10));
    }];
    
    _stepTwoLabel = [[UILabel alloc]init];
    _stepTwoLabel.textColor = [UIColor colorWithHexString:@"#D9D9D9"];
    _stepTwoLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView addSubview:_stepTwoLabel];
    [_stepTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stepOneLabel.mas_right);
        make.bottom.equalTo(self.stepOneLabel);
    }];
    
    _stepImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_stepImageView];
    [_stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.stepOneLabel.mas_bottom).with.offset(AutoHeight(10));
        make.height.mas_equalTo(150);
    }];
    
    _stepDesLabel = [[UILabel alloc]init];
    _stepDesLabel.numberOfLines = 0;
    _stepDesLabel.font = [UIFont systemFontOfSize:12];
    _stepDesLabel.textColor = [UIColor colorWithHexString:@"#282828"];
   
    [self.contentView addSubview:_stepDesLabel];
    [_stepDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.stepImageView.mas_bottom).with.offset(AutoHeight(5));
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
