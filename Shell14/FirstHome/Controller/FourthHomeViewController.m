//
//  FourthHomeViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/16.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "FourthHomeViewController.h"
#import "LoginFourthViewController.h"
#import "SearchViewController.h"
#import "FoodDetailViewController.h"
#import "UploadViewController.h"
#import "HotViewController.h"
#import "CategoryViewController.h"
#import "KitchenViewController.h"
#import "HomeFourthTableViewCell.h"
#import "AttentionTableViewCell.h"
#import "KitchenTableViewCell.h"
#import "HomeFourthModel.h"
#import "AttentionModel.h"
#import "KitchenModel.h"

@interface FourthHomeViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,AttentionTableViewCellDelegate>
{
    QMUIButton *selectedBtn;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *headView;
@property (nonatomic, strong) UIView      *menuView;
@property (nonatomic, strong) UIView      *midView;
@property (nonatomic, strong) UIView      *bottomView;
@property (nonatomic, strong) UILabel     *tipLabel;
@property (nonatomic, strong) UILabel     *leftLabel;
@property (nonatomic, strong) UILabel     *rightLabel;
@property (nonatomic, strong) UIImageView *leftImaView;
@property (nonatomic, strong) UIImageView *rightImaView;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) AttentionTableViewCell *cellAttention;
@property (nonatomic, strong) NSMutableArray *attentionArray;
@property (nonatomic, strong) NSMutableArray *kitchenArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *xiafanTitle;
@property (nonatomic, strong) NSMutableArray *feizhaiTitle;
@property (nonatomic, strong) NSMutableArray *tianpinTitle;
@property (nonatomic, strong) NSMutableArray *saveArray;

@end

@implementation FourthHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserInfoModel *info = [Utils GetUserInfo];
    [AttentionDataBaseManager openDB];
    NSMutableArray *attentionArray = [AttentionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
    self.saveArray = [NSMutableArray new];
    for (MyAttentionModel *model in attentionArray) {
        if ([model.name isEqualToString:@"Adam"] || [model.name isEqualToString:@"Louis"] || [model.name isEqualToString:@"Darcy"]) {
            [self.saveArray addObject:model.name];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorWhite;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:0 target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"列表分类"] style:0 target:self action:@selector(listClick)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorWhite;
    self.navigationItem.leftBarButtonItem.tintColor = UIColorWhite;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenW-100,25)];
    titleView.backgroundColor = UIColorWhite;
    titleView.layer.cornerRadius = 6;
    titleView.layer.masksToBounds = YES;
    titleView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push)];
    [titleView addGestureRecognizer:tap];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,kScreenW-100,25)];
    _searchBar.placeholder = @"搜索菜谱、食材";
    _searchBar.userInteractionEnabled = NO;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor colorWithHexString:@"#E9E9E9"] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;

    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initData];
    [self creatTableView];
    [self creatHeadView];
    [self creatBottomView];
    [self creatBtn];
}

- (void)push{
    SearchViewController *vc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark UI
- (void)creatBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"填写菜谱"] forState:UIControlStateNormal];
    btn.tag = 600;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-15);
        make.width.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(-(KHeight_StatusBar+AutoHeight(50)));
    }];
}
- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7-KHeight_TabBar) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"HomeFourthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFourthTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AttentionTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttentionTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"KitchenTableViewCell" bundle:nil] forCellReuseIdentifier:@"KitchenTableViewCell"];
    [self.view addSubview:_tableView];
}
- (void)creatHeadView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(92)+402)];
    _headView.backgroundColor = UIColorWhite;
    [self.view addSubview:self.headView];
    
    [self.headView addSubview:self.menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.headView).with.offset(AutoHeight(20));
        make.height.mas_equalTo(70);
    }];
    
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.text = @"每日推荐·早餐";
    _tipLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [self.headView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).with.offset(15);
        make.top.equalTo(self.menuView.mas_bottom).with.offset(AutoHeight(18));
    }];
    
    UIButton *more = [[UIButton alloc]init];
    [more setImage:[UIImage imageNamed:@"右"] forState:UIControlStateNormal];
    more.tag = 110;
    [more addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headView addSubview:more];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView).with.offset(-18);
        make.centerY.mas_equalTo(self.tipLabel.mas_centerY);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    UIButton *seeMore = [[UIButton alloc]init];
    [seeMore setTitle:@"查看更多" forState:UIControlStateNormal];
    [seeMore setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    [seeMore addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    seeMore.tag = 120;
    seeMore.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.headView addSubview:seeMore];
    [seeMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tipLabel.mas_centerY);
        make.right.equalTo(more.mas_left).with.offset(-5);
    }];
    
    [self.headView addSubview:self.leftImaView];
    [_leftImaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).with.offset(15);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(AutoHeight(10));
        make.width.mas_equalTo((kScreenW-40)/2);
        make.height.mas_equalTo(110);
    }];
    
    [self.headView addSubview:self.rightImaView];
    [_rightImaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView).with.offset(-15);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(AutoHeight(10));
        make.width.mas_equalTo((kScreenW-40)/2);
        make.centerY.mas_equalTo(self.leftImaView.mas_centerY);
    }];
    
    [self.headView addSubview:self.midView];
    [_midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.top.equalTo(self.leftImaView.mas_bottom).with.offset(AutoHeight(12));
        make.height.mas_equalTo(25);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"热门专题";
    label.font = [UIFont boldSystemFontOfSize:18];
    
    [self.headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel);
        make.top.equalTo(self.midView.mas_bottom).with.offset(AutoHeight(20));
    }];
    
    NSArray *array = @[[UIImage imageNamed:@"跟着《如懿传》做清宫美食！"], [UIImage imageNamed:@"民间传统小食，老幼均皆宜！"], [UIImage imageNamed:@"普通的面条，也能有大创意！"]];
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageNamesGroup:array];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolStyleAnimated;
    _scrollView.clipsToBounds = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.currentPageDotColor = UIColorWhite;
    _scrollView.pageControlDotSize = CGSizeMake(3, 3);
    _scrollView.autoScrollTimeInterval = 2;
    _scrollView.delegate = self;
    _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollView.autoScroll = YES;
    
    [self.headView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView).with.offset(15);
        make.right.equalTo(self.headView).with.offset(-15);
        make.top.equalTo(label.mas_bottom).with.offset(AutoHeight(10));
        make.height.mas_equalTo(150);
    }];
    
    self.tableView.tableHeaderView = self.headView;
}

- (void)creatBottomView{
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 170)];
    
    UIImageView *imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"新手菜桌"];
    imageView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1Click)];
    [imageView1 addGestureRecognizer:tap1];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.font = [UIFont boldSystemFontOfSize:12];
    label1.text = @"新手菜桌";
    
    [imageView1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1).with.offset(8);
        make.top.equalTo(imageView1).with.offset(4);
    }];
    
    UILabel *subLable1 = [[UILabel alloc]init];
    subLable1.textColor = [UIColor colorWithHexString:@"#919191"];
    subLable1.font = [UIFont systemFontOfSize:10];
    subLable1.text = @"0门槛学做菜";
    
    [imageView1 addSubview:subLable1];
    [subLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1);
        make.top.equalTo(label1.mas_bottom).with.offset(5);
    }];
    
    [_bottomView addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(15);
        make.top.equalTo(self.bottomView);
        make.width.mas_equalTo((kScreenW-40)/2);
        make.height.mas_equalTo((self.bottomView.height-10)/2);
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageNamed:@"减肥集中营"];
    imageView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2Click)];
    [imageView2 addGestureRecognizer:tap2];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.font = [UIFont boldSystemFontOfSize:12];
    label2.text = @"减肥集中营";
    
    [imageView2 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2).with.offset(8);
        make.top.equalTo(imageView2).with.offset(4);
    }];
    
    UILabel *subLable2 = [[UILabel alloc]init];
    subLable2.textColor = [UIColor colorWithHexString:@"#919191"];
    subLable2.font = [UIFont systemFontOfSize:10];
    subLable2.text = @"照着吃 就能瘦";
    
    [imageView2 addSubview:subLable2];
    [subLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2);
        make.top.equalTo(label2.mas_bottom).with.offset(5);
    }];
    
    [_bottomView addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-15);
        make.top.equalTo(self.bottomView);
        make.width.mas_equalTo((kScreenW-40)/2);
        make.height.mas_equalTo((self.bottomView.height-10)/2);
    }];
    
    UIImageView *imageView3 = [[UIImageView alloc]init];
    imageView3.image = [UIImage imageNamed:@"女神养成记"];
    imageView3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3Click)];
    [imageView3 addGestureRecognizer:tap3];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.font = [UIFont boldSystemFontOfSize:12];
    label3.text = @"女神养成记";
    
    [imageView3 addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView3).with.offset(8);
        make.top.equalTo(imageView3).with.offset(4);
    }];
    
    UILabel *subLable3 = [[UILabel alloc]init];
    subLable3.textColor = [UIColor colorWithHexString:@"#919191"];
    subLable3.font = [UIFont systemFontOfSize:10];
    subLable3.text = @"成为更美的自己";
    
    [imageView3 addSubview:subLable3];
    [subLable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3);
        make.top.equalTo(label3.mas_bottom).with.offset(5);
    }];
    
    [_bottomView addSubview:imageView3];
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(15);
        make.top.equalTo(imageView1.mas_bottom).with.offset(10);
        make.width.mas_equalTo((kScreenW-40)/2);
        make.height.mas_equalTo((self.bottomView.height-10)/2);
    }];
    
    UIImageView *imageView4 = [[UIImageView alloc]init];
    imageView4.image = [UIImage imageNamed:@"养生馆"];
    imageView4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap4Click)];
    [imageView4 addGestureRecognizer:tap4];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.font = [UIFont boldSystemFontOfSize:12];
    label4.text = @"养生馆";
    
    [imageView4 addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView4).with.offset(8);
        make.top.equalTo(imageView4).with.offset(4);
    }];
    
    UILabel *subLable4 = [[UILabel alloc]init];
    subLable4.textColor = [UIColor colorWithHexString:@"#919191"];
    subLable4.font = [UIFont systemFontOfSize:10];
    subLable4.text = @"养生不用靠枸杞";
    
    [imageView4 addSubview:subLable4];
    [subLable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label4);
        make.top.equalTo(label4.mas_bottom).with.offset(5);
    }];
    
    [_bottomView addSubview:imageView4];
    [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-15);
        make.top.equalTo(imageView1.mas_bottom).with.offset(10);
        make.width.mas_equalTo((kScreenW-40)/2);
        make.height.mas_equalTo((self.bottomView.height-10)/2);
    }];
}
#pragma mark 添加
- (void)addClick{
    UploadViewController *vc = [[UploadViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 点击事件
- (void)listClick{
    CategoryViewController *vc = [[CategoryViewController alloc]init];
    vc.row = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)btnClick:(UIButton *)btn{
   
    if (btn.tag < 110) {
        CategoryViewController *vc = [[CategoryViewController alloc]init];
        vc.row = btn.tag-100;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 110 || btn.tag == 120) {
        CategoryViewController *vc = [[CategoryViewController alloc]init];
        vc.row = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 600) {
        UploadViewController *vc = [[UploadViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)selectClick:(QMUIButton *)btn{
    
    NSArray *leftArray = @[@"白菜·猪肉馅饼",@"家常·红烧肉",@"萌萌的·斑点蛋糕卷",@"家常·炒面",@"胡萝卜·鸡蛋卷"];
    NSArray *rightArray = @[@"家常·鸡蛋饼",@"糖醋·素排骨",@"水晶·桂花糕",@"家常·盐酒鸡",@"糯米·圈圈红豆汤"];
    NSArray *array = @[@"早餐",@"午餐",@"下午茶",@"晚餐",@"夜宵"];
    _leftImaView.image = [UIImage imageNamed:leftArray[btn.tag-200]];
    _leftLabel.text = leftArray[btn.tag-200];
    _rightImaView.image = [UIImage imageNamed:rightArray[btn.tag-200]];
    _rightLabel.text = rightArray[btn.tag-200];
    self.tipLabel.text = [NSString stringWithFormat:@"每日推荐·%@",array[btn.tag-200]];
    if (selectedBtn) {
        [selectedBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    }
    selectedBtn = btn;
    [selectedBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
}

#pragma mark 推荐
- (void)leftPush{
    FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
    NSMutableArray *leftArray = [NSMutableArray new];
    NSString *leftStr = [NSString stringWithFormat:@"%@%@",[_leftLabel.text componentsSeparatedByString:@"·"][0],[_leftLabel.text componentsSeparatedByString:@"·"][1]];
    for (HomeFourthModel *model in self.rightArray[0]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }for (HomeFourthModel *model in self.rightArray[1]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }for (HomeFourthModel *model in self.rightArray[2]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }for (HomeFourthModel *model in self.rightArray[3]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }
    HomeFourthModel *model = leftArray[0];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightPush{
    FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
    NSMutableArray *leftArray = [NSMutableArray new];
    NSString *leftStr = [NSString stringWithFormat:@"%@%@",[_rightLabel.text componentsSeparatedByString:@"·"][0],[_rightLabel.text componentsSeparatedByString:@"·"][1]];
    for (HomeFourthModel *model in self.rightArray[0]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }for (HomeFourthModel *model in self.rightArray[1]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }for (HomeFourthModel *model in self.rightArray[2]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }for (HomeFourthModel *model in self.rightArray[3]) {
        if ([model.titleName isEqualToString:leftStr]) {
            [leftArray addObject:model];
        }
    }
    HomeFourthModel *model = leftArray[0];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tap1Click{
    HotViewController *vc = [[HotViewController alloc]init];
    vc.title = @"新手菜桌";
    vc.number = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tap2Click{
    HotViewController *vc = [[HotViewController alloc]init];
    vc.title = @"减肥集中营";
    vc.number = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tap3Click{
    HotViewController *vc = [[HotViewController alloc]init];
    vc.title = @"女神养成记";
    vc.number = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tap4Click{
    HotViewController *vc = [[HotViewController alloc]init];
    vc.title = @"养生馆";
    vc.number = 3;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 数据

- (instancetype)init{
    if (self) {
        self = [super init];
        _attentionArray = [NSMutableArray new];
        _kitchenArray = [NSMutableArray new];
        _dataArray = [NSMutableArray new];
        _rightArray = [NSMutableArray new];
        _xiafanTitle = [NSMutableArray new];
        _feizhaiTitle = [NSMutableArray new];
        _tianpinTitle = [NSMutableArray new];
    }
    return self;
}
- (void)initData{
    NSMutableArray *nameArray = [NSMutableArray arrayWithObjects:@"Adam",@"Louis",@"Darcy", nil];
    NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:@"营养餐、沙拉",@"烘培、泰国菜",@"日料、西点、法国菜", nil];
    for (NSInteger i = 0; i < nameArray.count; i++) {
        AttentionModel *model = [[AttentionModel alloc]init];
        model.name = nameArray[i];
        model.content = contentArray[i];
        [self.attentionArray addObject:model];
    }
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"Group 1",@"Group 2",@"Group 3", nil];
    NSMutableArray *numberArray = [NSMutableArray arrayWithObjects:@"201",@"193",@"122", nil];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        KitchenModel *model = [[KitchenModel alloc]init];
        model.imageName = titleArray[i];
        model.number = numberArray[i];
        NSDateFormatter *formate = [[NSDateFormatter alloc]init];
        [formate setDateFormat:@"YYYY-MM-dd"];
        model.time = [formate stringFromDate:[NSDate date]];
        [self.kitchenArray addObject:model];
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Property List" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSArray *list = [self.dataArray valueForKey:@"content"];
    [self.rightArray addObjectsFromArray:[HomeFourthModel mj_objectArrayWithKeyValuesArray:list]];
    
    for (HomeFourthModel *model in self.rightArray[0]) {
        if ([model.titleName isEqualToString:@"南乳莲藕蒸鸡"] || [model.titleName isEqualToString:@"胡萝卜土豆肉丝"] || [model.titleName isEqualToString:@"家常红烧肉"]) {
            [_xiafanTitle addObject:model];
        }if ([model.titleName isEqualToString:@"丝瓜炖豆腐"] || [model.titleName isEqualToString:@"糯米圈圈红豆汤"] || [model.titleName isEqualToString:@"酸甜藕片"]) {
            [_feizhaiTitle addObject:model];
        }
    }
    for (HomeFourthModel *model in self.rightArray[1]) {
        if ([model.titleName isEqualToString:@"南乳莲藕蒸鸡"] || [model.titleName isEqualToString:@"胡萝卜土豆肉丝"] || [model.titleName isEqualToString:@"家常红烧肉"]) {
            [_xiafanTitle addObject:model];
        }
    }
    for (HomeFourthModel *model in self.rightArray[3]) {
        if ([model.titleName isEqualToString:@"萌萌的斑点蛋糕卷"] || [model.titleName isEqualToString:@"摩卡布朗尼"] || [model.titleName isEqualToString:@"水晶桂花糕"]) {
            [_tianpinTitle addObject:model];
        }
    }
}
#pragma mark 关注
- (void)attention:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AttentionModel *model = self.attentionArray[indexPath.row];
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        AttentionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.attentionBtn.selected = !cell.attentionBtn.selected;
        if (cell.attentionBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [AttentionDataBaseManager openDB];
            [AttentionDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
            MyAttentionModel *attentionModel = [[MyAttentionModel alloc]init];
            attentionModel.name = model.name;
            attentionModel.content = model.content;
            [AttentionDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone] model:attentionModel];
            [cell.attentionBtn setTitle:@"关注中" forState:UIControlStateNormal];
            NSLog(@"===========关注%@==========",model.name);
        }else{
            
            UserInfoModel *info = [Utils GetUserInfo];
            [AttentionDataBaseManager openDB];
            NSMutableArray *saveArray = [AttentionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
            NSMutableArray *deleteArray = [NSMutableArray new];
            for (MyAttentionModel *model in saveArray) {
                if ([model.name isEqualToString:cell.nameLabel.text]) {
                    [deleteArray addObject:model];
                }
            }
            MyAttentionModel *model = deleteArray[0];
            [AttentionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone] ID:model.ID];
            [cell.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
            NSLog(@"===========取消%@===========",model.name);
        }
    }
}
#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return 3;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }if (section == 1) {
        return self.attentionArray.count;
    }else{
        return self.kitchenArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 170;
    }if (indexPath.section == 1) {
        return 66;
    }else{
        return 180;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 45;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = UIColorWhite;
        return view;
    }if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
        view.backgroundColor = UIColorWhite;
            
        UILabel *label = [[UILabel alloc]init];
        label.text = @"缤纷达人";
        label.font = [UIFont boldSystemFontOfSize:18];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(20);
        }];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
        view.backgroundColor = UIColorWhite;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"厨房故事";
        label.font = [UIFont boldSystemFontOfSize:18];
    
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(10);
        }];
        
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"我们,更懂你!";
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = [UIColor colorWithHexString:@"#919191"];
            
        [view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).with.offset(10);
            make.centerY.mas_equalTo(label.mas_centerY);
        }];
        return view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeFourthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFourthTableViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:self.bottomView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }if (indexPath.section == 1) {
        _cellAttention = [tableView dequeueReusableCellWithIdentifier:@"AttentionTableViewCell" forIndexPath:indexPath];
            AttentionModel *model = self.attentionArray[indexPath.row];
        _cellAttention.nameLabel.text = model.name;
        _cellAttention.despriptionLabel.text = model.content;
        _cellAttention.headIma.image = [UIImage imageNamed:model.name];
        if ([self.saveArray containsObject:_cellAttention.nameLabel.text]) {
            _cellAttention.attentionBtn.selected = YES;
            [_cellAttention.attentionBtn setTitle:@"关注中" forState:UIControlStateNormal];
        }else{
            _cellAttention.attentionBtn.selected = NO;
            [_cellAttention.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
        _cellAttention.attentionBtn.layer.cornerRadius = 10;
        _cellAttention.attentionBtn.layer.masksToBounds = YES;
        _cellAttention.delegate = self;
        _cellAttention.selectionStyle = UITableViewCellSelectionStyleNone;
        return _cellAttention;
    }else{
        KitchenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KitchenTableViewCell" forIndexPath:indexPath];
        KitchenModel *model = self.kitchenArray[indexPath.row];
        cell.headIma.image = [UIImage imageNamed:model.imageName];
        cell.timeLabel.text = model.time;
        cell.numberLabel.text = model.number;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section == 2) {
        KitchenModel *model = self.kitchenArray[indexPath.row];
        KitchenViewController *vc = [[KitchenViewController alloc]init];
        vc.imageName = model.imageName;
        if (indexPath.row == 0) {
            vc.dataArray = _xiafanTitle;
        }if (indexPath.row == 1) {
            vc.dataArray = _feizhaiTitle;
        }if (indexPath.row == 2) {
            vc.dataArray = _tianpinTitle;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark cycleScrollView delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    //NSLog(@"didScrollToIndex----index:%ld",index);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
    if (index == 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (HomeFourthModel *model in self.rightArray[3]) {
            if ([model.titleName isEqualToString:@"水晶桂花糕"]) {
                [array addObject:model];
            }
        }
        vc.model = array[0];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 1) {
        NSMutableArray *array = [NSMutableArray new];
        for (HomeFourthModel *model in self.rightArray[3]) {
            if ([model.titleName isEqualToString:@"姜撞奶"]) {
                [array addObject:model];
            }
        }
        vc.model = array[0];
        [self.navigationController pushViewController:vc animated:YES];
    }if (index == 2) {
        NSMutableArray *array = [NSMutableArray new];
        for (HomeFourthModel *model in self.rightArray[1]) {
            if ([model.titleName isEqualToString:@"家常炒面"]) {
                [array addObject:model];
            }
        }
        vc.model = array[0];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

#pragma mark 懒加载
- (UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc]init];

        CGFloat a = (kScreenW - 40 - 200)/3;
        NSArray *titleArray = @[@"热门推荐",@"家常菜谱",@"一日三餐",@"烘培甜品"];
        for (int i = 0; i<titleArray.count; i++) {
            QMUIButton *btn = [[QMUIButton alloc]init];
            btn.frame = CGRectMake((a + 50) * i + 20, 0, 50, 60);
            btn.imagePosition = QMUIButtonImagePositionTop;
            btn.spacingBetweenImageAndTitle = 15;
            [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:UIColorBlack forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, -5);
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_menuView addSubview:btn];
        }
    }
    return _menuView;
}
- (UIImageView *)leftImaView{
    if (!_leftImaView) {
        _leftImaView = [[UIImageView alloc]init];
        _leftImaView.image = [UIImage imageNamed:@"白菜·猪肉馅饼"];
        _leftImaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftPush)];
        [_leftImaView addGestureRecognizer:tap];
        
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.text = @"白菜·猪肉馅饼";
        _leftLabel.textColor = UIColorWhite;
        _leftLabel.font = [UIFont boldSystemFontOfSize:10];
        
        [_leftImaView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImaView).with.offset(8);
            make.bottom.equalTo(self.leftImaView).with.offset(-5);
        }];
    }
    return _leftImaView;
}
- (UIImageView *)rightImaView{
    if (!_rightImaView) {
        _rightImaView = [[UIImageView alloc]init];
        _rightImaView.image = [UIImage imageNamed:@"家常·鸡蛋饼"];
        _rightImaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightPush)];
        [_rightImaView addGestureRecognizer:tap];
        
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.text = @"家常·鸡蛋饼";
        _rightLabel.textColor = UIColorWhite;
        _rightLabel.font = [UIFont boldSystemFontOfSize:10];
        
        [_rightImaView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rightImaView).with.offset(8);
            make.bottom.equalTo(self.rightImaView).with.offset(-5);
        }];
    }
    return _rightImaView;
}
- (UIView *)midView{
    if (!_midView) {
        _midView = [[UIView alloc]init];

        CGFloat a = (kScreenW - 60 - 175)/4;
        NSArray *titleArray = @[@"早餐",@"午餐",@"下午茶",@"晚餐",@"夜宵"];
        for (int i = 0; i<titleArray.count; i++) {
            QMUIButton *btn = [[QMUIButton alloc]init];
            btn.frame = CGRectMake((a + 35) * i + 30, 0, 35, 25);
            btn.imagePosition = QMUIButtonImagePositionRight;
            btn.spacingBetweenImageAndTitle = 15;
            [btn setImage:[UIImage imageNamed:titleArray[i]] forState:UIControlStateNormal];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, -15);
            btn.tag = 200+i;
            if (btn.tag == 200) {
                [btn setTitleColor:UIColorBlack forState:UIControlStateNormal];
                selectedBtn = btn;
            }else{
                [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
            [_midView addSubview:btn];
        }
    }
    return _midView;
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
