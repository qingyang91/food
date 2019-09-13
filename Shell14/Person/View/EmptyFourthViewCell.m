//
//  EmptyFourthViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/22.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "EmptyFourthViewCell.h"

@implementation EmptyFourthViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.backgroundColor=[UIColor clearColor];
        [self initSubView];
    }
    
    return self;
}
- (void)initSubView{
    _imageEmptyView = [[UIImageView alloc]init];
    _imageEmptyView.image = [UIImage imageNamed:@"空"];
    _imageEmptyView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageEmptyView];
    [self.imageEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(AutoHeight(190));
        make.left.equalTo(self.contentView).with.offset(AutoWidth(85));
        make.right.equalTo(self.contentView).with.offset(-AutoWidth(85));
        make.height.mas_equalTo(AutoHeight(80));
    }];
    _emptyLabel = [[UILabel alloc]init];
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    _emptyLabel.font = [UIFont systemFontOfSize:12];
    _emptyLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(30);
        make.right.equalTo(self.contentView).with.offset(-30);
        make.top.equalTo(self.imageEmptyView.mas_bottom).with.offset(AutoHeight(20));
        make.height.mas_equalTo(15);
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
