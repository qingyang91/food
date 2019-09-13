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

- (instancetype)initWithConfirmBlock:(void (^)(NSInteger))confirmBlock{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    if (self) {
        _confirmBlock = confirmBlock;
        self.backgroundColor = [UIColor clearColor];
        self.shadowView = [[UIButton alloc] initWithFrame:self.frame];
        self.shadowView.userInteractionEnabled = YES;
        [self.shadowView addTarget:self action:@selector(shadowViewClick) forControlEvents:UIControlEventTouchUpInside];
        self.shadowView.backgroundColor = [UIColor blackColor];
        self.shadowView.alpha = 0.4;
        [self addSubview:self.shadowView];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = UIColorWhite;
        
        [self addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(40);
            make.right.equalTo(self).with.offset(-40);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(125);
        }];
    }
    return self;
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
