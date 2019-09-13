//
//  FourthMineViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/16.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "FourthMineViewController.h"
#import "MyAttentionViewController.h"
#import "LoginFourthViewController.h"
#import "MyCreationViewController.h"
#import "MyCollectionViewController.h"
#import "FeedHelpViewController.h"
#import "MyTableViewCell.h"

@interface FourthMineViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *labelLogin;

@end

@implementation FourthMineViewController

- (void)viewWillAppear:(BOOL)animated{
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        _labelLogin.text = @"请登录";
        _labelLogin.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginClick)];
        [_labelLogin addGestureRecognizer:tap];
    }else{
        _labelLogin.userInteractionEnabled = NO;
        _labelLogin.text = [NSString stringWithFormat:@"%@****%@",[info.phone substringToIndex:3],[info.phone substringFromIndex:7]];
    }
    [self.view layoutIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    [self creatUI];
}

- (void)creatUI{
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(AutoHeight(220));
    }];
    
    [_topView addSubview:self.midView];
    [_midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.view).with.offset(AutoHeight(175));
        make.height.mas_equalTo(AutoHeight(85));
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.midView.mas_bottom).with.offset(AutoHeight(40));
        make.height.mas_equalTo(176);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[@"消息提醒",@"反馈帮助",@"清理缓存",@"退出登录"];
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = array[indexPath.row];
    if (indexPath.row == 0) {
        cell.rightIma.hidden = YES;
        UISwitch *newSwitch = [[UISwitch alloc]init];
        newSwitch.on = YES;
        [cell.contentView addSubview:newSwitch];
        
        [newSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).with.offset(-18);
            make.centerY.equalTo(cell.titleLabel.mas_centerY);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        FeedHelpViewController *vc = [[FeedHelpViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }if (indexPath.row == 2) {
        [SVProgressHUD showInfoWithStatus:@"清除缓存成功"];
    }if (indexPath.row == 3) {
        [Utils Logout];
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)btnClick:(UIButton *)btn{
    MyAttentionViewController *vc = [[MyAttentionViewController alloc]init];
    if (btn.tag == 100) {
        vc.title = @"我的关注";
        [self.navigationController pushViewController:vc animated:YES];
    }if (btn.tag == 101) {
        vc.title = @"我的粉丝";
        [self.navigationController pushViewController:vc animated:YES];
    }if (btn.tag == 102) {
        MyCreationViewController *vc = [[MyCreationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }if (btn.tag == 103) {
        MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)loginClick{
    LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#FA8C16"];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"head"];
        [_topView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView).with.offset(AutoHeight(60));
            make.left.equalTo(self.topView).with.offset((kScreenW-70)/2);
            make.right.equalTo(self.topView).with.offset(-(kScreenW-70)/2);
            make.height.mas_equalTo(70);
        }];
        
        _labelLogin = [[UILabel alloc]init];
        _labelLogin.textColor = UIColorWhite;
        _labelLogin.font = [UIFont systemFontOfSize:16];
        _labelLogin.textAlignment = NSTextAlignmentCenter;
        
        [_topView addSubview:_labelLogin];
        [_labelLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView).with.offset(20);
            make.right.equalTo(self.topView).with.offset(-20);
            make.top.equalTo(imageView.mas_bottom).with.offset(AutoHeight(10));
        }];
    }
    return _topView;
}
- (UIView *)midView{
    if (!_midView) {
        _midView = [[UIView alloc]init];
        _midView.backgroundColor = UIColorWhite;
        [_midView addShadow];
        
        NSArray *titleArray = @[@"关注",@"粉丝",@"作品",@"收藏"];
        CGFloat a = (kScreenW-30-50-124)/3;
        for (NSInteger i = 0; i < titleArray.count; i++) {
            QMUIButton *btn = [[QMUIButton alloc]init];
            btn.frame = CGRectMake((a+31)*i+25, AutoHeight(20), 31, 55);
            btn.imagePosition = QMUIButtonImagePositionTop;
            btn.spacingBetweenImageAndTitle = 10;
            [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:UIColorBlack forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_midView addSubview:btn];
        }
    }
    return _midView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorWhite;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyTableViewCell"];
    }
    return _tableView;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
