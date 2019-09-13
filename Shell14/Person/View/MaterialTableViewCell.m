//
//  MaterialTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/26.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "MaterialTableViewCell.h"

@implementation MaterialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
        self.backgroundColor = UIColorWhite;
    }
    return self;
}

- (void)initSubView{
    
    _nameField = [[CustomTextField alloc]init];
    _nameField.font = [UIFont systemFontOfSize:12];
    
    [self.nameField addTarget:self action:@selector(contentDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *name = [NSMutableDictionary dictionary];
    name[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#D2D2D2"];
    NSAttributedString *stringtwo = [[NSAttributedString alloc] initWithString:@"+食材：如猪肉" attributes:dict];
    _nameField.attributedPlaceholder = stringtwo;
    _nameField.returnKeyType = UIReturnKeyDone;
    
    [self.contentView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo((kScreenW-30)/2);
    }];
    
    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.mas_equalTo(self.nameField.mas_centerY);
        make.width.height.mas_equalTo(20);
    }];
    
    _dosageField = [[CustomTextField alloc]init];
    [self.dosageField addTarget:self action:@selector(dosageFieldContentDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _dosageField.font = [UIFont systemFontOfSize:12];
    _dosageField.returnKeyType = UIReturnKeyDone;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *name1 = [NSMutableDictionary dictionary];
    name1[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#D2D2D2"];//设置占位符字体颜色
    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:@"+用量：如200g" attributes:dict1];
    _dosageField.attributedPlaceholder = string1;
    
    [self.contentView addSubview:_dosageField];
    [_dosageField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10);
        make.left.equalTo(self.contentView).with.offset((kScreenW-30)/2);
        make.right.equalTo(self.deleteBtn.mas_left);
        make.height.mas_equalTo(15);
    }];
}

- (void)contentDidChanged:(id)sender {
    // 调用代理方法，告诉代理，哪一行的文本发生了改变
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentDidChanged:forIndexPath:)]) {
        [self.delegate contentDidChanged:self.nameField.text forIndexPath:self.nameField.indexPath];
    }
}
- (void)dosageFieldContentDidChanged:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dosageFieldContentDidChanged:forIndexPath:)]) {
        [self.delegate dosageFieldContentDidChanged:self.dosageField.text forIndexPath:self.dosageField.indexPath];
    }
}
- (void)deleteClick:(UIButton *)btn{
    [self.delegate deleteCellClick:self];
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
