//
//  LoginFourthViewController.m
//  BorrowingMoney
//
//  Created by Qingyang Xu on 2018/8/24.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "LoginFourthViewController.h"
#import "PXFourthTabBarViewController.h"
#define _codeBtn [JKCountDownButton sharedInstance]

@interface  LoginFourthViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *subhLabel;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *close;
@property (nonatomic, strong) UIButton *choose;
@property (nonatomic, copy)   NSString *mesStr;

@end

@implementation LoginFourthViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    [self creatUI];
}

- (void)creatUI{
    _close = [[UIButton alloc]init];
    [_close setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [_close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_close];
    [_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(self.view).with.offset(AutoHeight(35));
        make.width.height.mas_equalTo(14);
    }];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.height.mas_equalTo(110);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"手机快捷登录";
    _titleLabel.font = [UIFont boldSystemFontOfSize:23];
    [self.view addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(self.view).with.offset(AutoHeight(90));
        make.height.mas_equalTo(@23);
    }];
    
    _subhLabel = [[UILabel alloc]init];
    _subhLabel.text = @"未注册过的手机号将自动创建账号";
    _subhLabel.font = [UIFont systemFontOfSize:13];
    _subhLabel.textColor = GrayTextColor;
    [self.view addSubview:_subhLabel];
    
    [_subhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(AutoHeight(10));
        make.height.mas_equalTo(@15);
    }];
    
    self.phoneTF = [[UITextField alloc] init];
    _phoneTF.borderStyle = UITextBorderStyleNone;
    _phoneTF.placeholder = @"请输入手机号";
    _phoneTF.font = [UIFont systemFontOfSize:15];
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTF.delegate = self;
    [_phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:_phoneTF];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subhLabel);
        make.right.equalTo(self.view).with.offset(-AutoWidth(110));
        make.height.offset(30);
        make.top.equalTo(self.subhLabel).with.offset(AutoHeight(40));
    }];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:lineView1];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).with.offset(AutoHeight(15));
        make.left.equalTo(self.phoneTF);
        make.right.equalTo(self.view).with.offset(-25);
        make.height.offset(1);
    }];
    
    self.codeTF = [[UITextField alloc] init];
    _codeTF.borderStyle = UITextBorderStyleNone;
    _codeTF.placeholder = @"请输入验证码";
    _codeTF.font = [UIFont systemFontOfSize:14];
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTF.delegate = self;
    [_codeTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.view addSubview:_codeTF];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subhLabel);
        make.right.equalTo(lineView1);
        make.height.offset(30);
        make.top.equalTo(lineView1.mas_bottom).with.offset(AutoHeight(15));
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.view addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom).with.offset(AutoHeight(15));
        make.left.equalTo(self.codeTF);
        make.right.equalTo(lineView1);
        make.height.offset(1);
    }];
    
    _choose = [[UIButton alloc]init];
    _choose.selected = YES;
    [_choose setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
    [_choose setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateSelected];
    [_choose addTarget:self action:@selector(chooseClcik:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_choose];
    [_choose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTF);
        make.top.equalTo(lineView2.mas_bottom).with.offset(AutoHeight(20));
        make.width.height.mas_equalTo(14);
    }];
    
    UILabel *read = [[UILabel alloc]init];
    read.text = @"注册/登陆即代表同意《用户协议》";
    read.font = [UIFont systemFontOfSize:12];
    read.textColor = [UIColor colorWithHexString:@"#CED1D6"];
    
    [self.view addSubview:read];
    [read mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.choose.mas_centerY);
        make.left.equalTo(self.choose.mas_right).with.offset(10);
    }];
    
    _codeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_codeBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [_codeBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _codeBtn.userInteractionEnabled = NO;
    [self.view addSubview:_codeBtn];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView1);
        make.centerY.equalTo(self.phoneTF);
        make.width.offset(80);
        make.height.offset(15);
    }];
    
    [_codeBtn countDownButtonHandler:^(JKCountDownButton *countDownButton, NSInteger tag) {
        
        NSMutableDictionary  *parmers = [NSMutableDictionary dictionary];
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [parmers setObject:self.phoneTF.text forKey:@"mobile"];
        [parmers setObject:deviceUUID forKey:@"regcode"];
        
        //        [HMHttpTool GET:[NSString stringWithFormat:@"%@%@",Base_URL,GetCode] params:parmers success:^(NSURLSessionDataTask *task, id responseObject) {
        //            self.mesStr = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        //            if ([self.mesStr isEqualToString:@"200"]) {
        //                [countDownButton startCountDownWithSecond:60.0];
        //                [countDownButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        //                [countDownButton countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        //                    countDownButton.enabled = NO;
        //                    NSString *title = [NSString stringWithFormat:@"剩余%lu秒",(unsigned long)second];
        //                     [countDownButton setTitleColor:GrayTextColor forState:UIControlStateNormal];
        //                    return title;
        //                }];
        //
        //                [countDownButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        //
        //                    countDownButton.enabled = YES;
        //                    [countDownButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        //                    return @"重新获取";
        //
        //                }];
        //            }
        //
        //            [SVProgressHUD showWithStatus:responseObject[@"message"]];
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
        //                dispatch_get_main_queue(), ^{
        //                    [SVProgressHUD dismiss];
        //        });
        //        } fail:^(NSURLSessionDataTask *task, NSError *error) {
        //
        //        }];
        [HMHttpTool post:[NSString stringWithFormat:@"%@%@",Base_URL,GetCode] params:parmers success:^(NSDictionary *JSONDic) {
            self.mesStr = [NSString stringWithFormat:@"%@",JSONDic[@"status"]];
            if ([self.mesStr isEqualToString:@"200"]) {
                [countDownButton startCountDownWithSecond:60.0];
                [countDownButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
                [countDownButton countDownChanging:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                    countDownButton.enabled = NO;
                    NSString *title = [NSString stringWithFormat:@"剩余%lu秒",(unsigned long)second];
                    [countDownButton setTitleColor:GrayTextColor forState:UIControlStateNormal];
                    return title;
                }];
                
                [countDownButton countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                    
                    countDownButton.enabled = YES;
                    [countDownButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
                    return @"重新获取";
                    
                }];
            }
            
            [SVProgressHUD showWithStatus:JSONDic[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [SVProgressHUD dismiss];
                           });
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    self.loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    _loginBtn.backgroundColor = RGBA(248, 140, 44, 0.5);
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _loginBtn.userInteractionEnabled = NO;
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_loginBtn];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.choose.mas_bottom).with.offset(AutoHeight(25));
        make.left.equalTo(lineView2);
        make.right.equalTo(lineView2);
        make.height.offset(50);
    }];
    _loginBtn.layer.cornerRadius = 26;
    _loginBtn.layer.masksToBounds = YES;
    
}

- (void)closeClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)chooseClcik:(UIButton *)btn{
    btn.selected = !btn.selected;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if ([Utils validateMobile:self.phoneTF.text] == YES) {
        [_codeBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
        if (self.codeTF.text.length == 6) {
            self.loginBtn.backgroundColor = RGBA(248, 140, 44, 1.0);
            _loginBtn.userInteractionEnabled = YES;
        } else {
            self.loginBtn.backgroundColor = RGBA(248, 140, 44, 0.5);
            _loginBtn.userInteractionEnabled = NO;
        }
    } else {
        [_codeBtn setTitleColor:GrayTextColor forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = NO;
        self.loginBtn.backgroundColor = RGBA(248, 140, 44, 0.5);
        _loginBtn.userInteractionEnabled = NO;
    }
}

- (void)loginAction{
    if (_choose.selected == YES) {
        NSMutableDictionary  *parmers = [NSMutableDictionary dictionary];
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [parmers setObject:self.phoneTF.text forKey:@"mobile"];
        [parmers setObject:deviceUUID forKey:@"regcode"];
        [parmers setObject:self.codeTF.text forKey:@"code"];
        [parmers setObject:@"rnaios" forKey:@"form"];
        [parmers setObject:@"leshi" forKey:@"channel"];
        
        [HMHttpTool post:[NSString stringWithFormat:@"%@%@",Base_URL,LoginUrl] params:parmers success:^(NSDictionary *JSONDic) {
            NSString *status = [NSString stringWithFormat:@"%@", JSONDic[@"status"]];
            NSLog(@"%@",JSONDic);
            if ([status isEqualToString:@"200"]) {
                [self.codeTF resignFirstResponder];
                [self.phoneTF resignFirstResponder];
                NSString *userID = JSONDic[@"data"];
                UserInfoModel *model = [[UserInfoModel alloc] init];
                model.phone = self.phoneTF.text;
                model.uid = userID;
                [Utils saveUserInfoToUserDefault:model];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [SVProgressHUD showWithStatus:JSONDic[@"message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"选择同意用户协议"];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneTF){
        if (string.length == 11 ) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11 ){
            return NO;
        }
        return YES;
    }
    else {
        if (string.length == 6 ) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6 ){
            return NO;
        }
        return YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
