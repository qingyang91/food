//
//  FeedHelpViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "FeedHelpViewController.h"
#import "LoginFourthViewController.h"

@interface FeedHelpViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) UILabel *textLimit;
@property (nonatomic, retain) UIButton *button;

@end

@implementation FeedHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"反馈帮助";
    [self creatUI];
}

- (void)creatUI{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7+AutoHeight(15), kScreenW, kScreenW+AutoHeight(40)+20)];
    topView.backgroundColor = UIColorWhite;
    [self.view addSubview:topView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap1];
    __block UIView *topBackView = [[UIView alloc] init];
    topBackView.backgroundColor = UIColorWhite;
    topBackView.translatesAutoresizingMaskIntoConstraints = NO;
    topBackView.layer.cornerRadius = 15;
    topBackView.layer.masksToBounds = YES;
    topBackView.layer.borderWidth = 1;
    topBackView.layer.borderColor = [UIColor colorWithHexString:@"#C5C5C5"].CGColor;
    [topView addSubview:topBackView];
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView).with.offset(AutoHeight(5));
        make.left.equalTo(topView).with.offset(15);
        make.right.equalTo(topView).with.offset(-15);
        make.height.mas_equalTo(AutoHeight(220));
    }];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10,kScreenW - 46, AutoHeight(220)-10)];
    self.textView.delegate = self;
    self.textView.backgroundColor = UIColorWhite;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = UIColorBlack;
    self.textView.returnKeyType = UIReturnKeyDone;
    [topBackView addSubview:self.textView];
    
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.font = [UIFont systemFontOfSize:15];
    _placeHolderLabel.textColor = [UIColor colorWithHexString:@"#818181"];
    _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _placeHolderLabel.text = @"请输入您宝贵的意见";
    _placeHolderLabel.numberOfLines = 0;
    [self.textView addSubview:self.placeHolderLabel];
    
    [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_equalTo(@0);
    }];
    
    _textLimit = [[UILabel alloc] init];
    _textLimit.font = [UIFont systemFontOfSize:13];
    _textLimit.textColor = [UIColor colorWithHexString:@"#2D2D2D"];
    _textLimit.translatesAutoresizingMaskIntoConstraints = NO;
    _textLimit.text = @"您还可以输入二百个字";
    [topView addSubview:_textLimit];
    
    [_textLimit mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(topView).with.offset(-18);
        make.top.equalTo(topBackView.mas_bottom).offset(AutoHeight(10));
    }];
    
    _button = [[UIButton alloc]init];
    [_button setTitle:@"确认反馈" forState:UIControlStateNormal];
    [_button setTitleColor:UIColorWhite forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor colorWithHexString:@"#FA8C16"];
    _button.layer.cornerRadius = 8;
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).with.offset(50);
        make.right.equalTo(topView).with.offset(-50);
        make.top.equalTo(self.textLimit.mas_bottom).with.offset(AutoHeight(30));
        make.height.mas_equalTo(50);
    }];
}
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}
- (void)confirmClick{
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        if (kStringIsEmpty(self.textView.text)) {
            [SVProgressHUD showInfoWithStatus:@"请输入您的宝贵意见"];
            return;
        }else{
            [SVProgressHUD showInfoWithStatus:@"反馈成功"];
            [self performBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } afterDelay:1.0];
        }
    }
}
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _placeHolderLabel.hidden = YES;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.textView.text length] > 200) {
        [SVProgressHUD showInfoWithStatus:@"不能超过200个字"];
        self.textView.text = [self.textView.text substringToIndex:200];
        self.textLimit.text = @"您还可以输入0个字";
        return;
    }
    if ([self isBlankString:textView.textInputMode.primaryLanguage]) {
        return;
    }
    NSInteger a = 200 - [textView.text length];
    NSString *str = [NSString stringWithFormat:@"您还可以输入%ld个字",(long)a];
    self.textLimit.text = str;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self isBlankString:textView.textInputMode.primaryLanguage]) {
        return NO;
    };if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        _placeHolderLabel.hidden = NO;
    }
    return YES;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (void) hideAllKeyBoards{
    [_textView resignFirstResponder];
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
