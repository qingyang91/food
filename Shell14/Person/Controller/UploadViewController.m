//
//  UploadViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/22.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "UploadViewController.h"
#import "UploadMenuViewController.h"
#import "WriteTopicViewController.h"
#import "LoginFourthViewController.h"

@interface UploadViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *close;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *leftImaView;
@property (nonatomic, strong) UIImageView *rightImaView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    [self creatUI];
}
- (void)creatUI{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
    imageView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    [imageView addSubview:self.close];
    [_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).with.offset(25);
        make.top.equalTo(imageView).with.offset(AutoHeight(35));
        make.width.height.mas_equalTo(14);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView);
        make.top.equalTo(imageView);
        make.width.height.mas_equalTo(110);
    }];
    
    [imageView addSubview:self.tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.close);
        make.right.equalTo(imageView).with.offset(-25);
        make.top.equalTo(self.close.mas_bottom).with.offset(AutoHeight(65));
    }];
    
    [imageView addSubview:self.leftImaView];
    [_leftImaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(AutoHeight(105));
        make.width.mas_equalTo((kScreenW-80)/2);
        make.height.mas_equalTo(AutoHeight(204));
    }];
    
    [_leftImaView addSubview:self.leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImaView).with.offset(5);
        make.right.equalTo(self.leftImaView).with.offset(-5);
        make.top.equalTo(self.leftImaView).with.offset(AutoHeight(15));
    }];
    
    [imageView addSubview:self.rightImaView];
    [_rightImaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imageView).with.offset(-25);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(AutoHeight(105));
        make.centerY.mas_equalTo(self.leftImaView.mas_centerY);
        make.width.mas_equalTo((kScreenW-80)/2);
        make.height.mas_equalTo(AutoHeight(204));
    }];
    
    [_rightImaView addSubview:self.rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImaView).with.offset(5);
        make.right.equalTo(self.rightImaView).with.offset(-5);
        make.top.equalTo(self.rightImaView).with.offset(AutoHeight(15));
    }];
}
- (void)closeClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)leftPush{
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UploadMenuViewController *vc = [[UploadMenuViewController alloc]init];
        vc.title = @"传菜谱";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)rightPush{
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        WriteTopicViewController *vc = [[WriteTopicViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (UIButton *)close{
    if (!_close) {
        _close = [[UIButton alloc]init];
        [_close setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _close;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"生活不止远方和诗，还有面前这些好吃的啊！";
        _tipLabel.textColor = [UIColor colorWithHexString:@"#5A5A5A"];
        _tipLabel.font = [UIFont systemFontOfSize:24];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}
- (UIImageView *)leftImaView{
    if (!_leftImaView) {
        _leftImaView = [[UIImageView alloc]init];
        _leftImaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftPush)];
        [_leftImaView addGestureRecognizer:tap1];
        _leftImaView.image = [UIImage imageNamed:@"传菜谱"];
    }
    return _leftImaView;
}
- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.text = @"传菜谱";
        _leftLabel.font = [UIFont boldSystemFontOfSize:18];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#C1A256"];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
- (UIImageView *)rightImaView{
    if (!_rightImaView) {
        _rightImaView = [[UIImageView alloc]init];
        _rightImaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightPush)];
        [_rightImaView addGestureRecognizer:tap1];
        _rightImaView.image = [UIImage imageNamed:@"写食话"];
    }
    return _rightImaView;
}
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.text = @"写食话";
        _rightLabel.font = [UIFont boldSystemFontOfSize:18];
        _rightLabel.textColor = [UIColor colorWithHexString:@"#BC766B"];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
