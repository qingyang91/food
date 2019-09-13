//
//  CustomAlertView.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/11/1.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *shadowView;
@property (nonatomic,   copy) void(^confirmBlock)();

@end

@implementation CustomAlertView

- (instancetype)initWithTitle:(NSString *)text ConfirmBlock:(void (^)())confirmBlock{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    if (self) {
        _confirmBlock = confirmBlock;
        self.backgroundColor = [UIColor clearColor];
        self.shadowView = [[UIButton alloc] initWithFrame:self.frame];
        self.shadowView.backgroundColor = [UIColor blackColor];
        self.shadowView.alpha = 0.4;
        [self addSubview:self.shadowView];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = UIColorWhite;
        self.bgView.layer.cornerRadius = 6;
        self.bgView.layer.masksToBounds = YES;
        
        [self addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(40);
            make.right.equalTo(self).with.offset(-40);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(125);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 2;
        
        [_bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).with.offset(25);
            make.right.equalTo(self.bgView).with.offset(-25);
            make.top.equalTo(self.bgView).with.offset(18);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        
        [_bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(label.mas_bottom).with.offset(18);
            make.height.mas_equalTo(1);
        }];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FA8C16"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [_bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.top.equalTo(line.mas_bottom).with.offset(12);
            make.width.mas_equalTo(200);
        }];
    }
    return self;
}

- (void)confirmClick{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self shadowViewClick];
}

- (void)shadowViewClick {
    [self removeFromSuperview];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
