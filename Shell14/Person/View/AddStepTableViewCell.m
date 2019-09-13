//
//  StepTableViewCell.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/26.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "AddStepTableViewCell.h"

@implementation AddStepTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *name = [NSMutableDictionary dictionary];
    name[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#999999"];
    NSAttributedString *stringtwo = [[NSAttributedString alloc] initWithString:@"+添加步骤说明" attributes:dict];
    self.stepDetailField.font = [UIFont systemFontOfSize:12];
    self.stepDetailField.attributedPlaceholder = stringtwo;
    self.stepDetailField.returnKeyType = UIReturnKeyDone;
    [self.stepDetailField addTarget:self action:@selector(contentDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.stepIma.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentImaChanged:)];
    [self.stepIma addGestureRecognizer:tap];
}

- (void)contentDidChanged:(id)sender {
    // 调用代理方法，告诉代理，哪一行的文本发生了改变
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentStepDidChanged:forIndexPath:)]) {
        [self.delegate contentStepDidChanged:self.stepDetailField.text forIndexPath:self.stepDetailField.indexPath];
    }
}
- (void)contentImaChanged:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentStepImaDidChanged:forIndexPath:)]) {
        [self.delegate contentStepImaDidChanged:self.stepIma.imageData forIndexPath:self.stepIma.indexPath];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteClick:(id)sender {
    [self.delegate deleteStep:self];
}
@end
