//
//  SearchViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/31.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "SearchViewController.h"
#import "FoodDetailViewController.h"
#import "HomeFourthModel.h"
#import "SearchTableViewCell.h"
#import "EmptyFourthViewCell.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchTableview;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *backView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenW-100,25)];
    titleView.backgroundColor = UIColorWhite;
    titleView.layer.cornerRadius = 6;
    titleView.layer.masksToBounds = YES;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,kScreenW-100,25)];
    _searchBar.placeholder = @"搜索菜谱、食材";
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor colorWithHexString:@"#E9E9E9"] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColorWhite;
    
    [self creatSearchTableview];
    [self creatBackUI];
    [self initData];
}

- (void)creatBackUI{
    _backView = [[UIView alloc]init];
    
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavBarHAbove7+AutoHeight(155));
        make.height.mas_equalTo(AutoHeight(150));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"搜索"];
    
    [_backView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(108);
        make.right.equalTo(self.backView).with.offset(-108);
        make.top.equalTo(self.backView);
        make.height.mas_equalTo(AutoHeight(130));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"搜索一下，总能找到更多惊喜不是么?";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#919191"];
    
    [_backView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(10);
        make.right.equalTo(self.backView).with.offset(-10);
        make.top.equalTo(imageView.mas_bottom);
    }];
}

- (void)creatSearchTableview{
    _searchTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7-KHeight_TabBar) style:UITableViewStylePlain];
    _searchTableview.delegate = self;
    _searchTableview.dataSource = self;
    _searchTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_searchTableview registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
    _searchTableview.hidden = YES;
    [self.view addSubview:_searchTableview];
}

- (instancetype)init{
    if (self) {
        self = [super init];
        _rightArray = [NSMutableArray new];
        _searchArray = [NSMutableArray new];
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (void)cancelClick{
    [_searchBar resignFirstResponder];
    _searchTableview.hidden = YES;
    _backView.hidden = NO;
}

- (void)initData{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Property List" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSArray *list = [self.dataArray valueForKey:@"content"];
    [self.rightArray addObjectsFromArray:[HomeFourthModel mj_objectArrayWithKeyValuesArray:list]];
    
}
#pragma mark search
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    _backView.hidden = YES;
    _searchTableview.hidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   if (kStringIsEmpty(searchText)) {
        [_searchArray removeAllObjects];
        [_searchTableview reloadData];
    }else{
        self.searchTableview.hidden = NO;
        [_searchArray removeAllObjects];
        for (HomeFourthModel *model in self.rightArray[0]) {
            if ([model.titleName rangeOfString:searchText].location !=NSNotFound) {
                [self.searchArray addObject:model];
            }
        }for (HomeFourthModel *model in self.rightArray[1]) {
            if ([model.titleName rangeOfString:searchText].location !=NSNotFound) {
                [self.searchArray addObject:model];
            }
        }for (HomeFourthModel *model in self.rightArray[2]) {
            if ([model.titleName rangeOfString:searchText].location !=NSNotFound) {
                [self.searchArray addObject:model];
            }
        }for (HomeFourthModel *model in self.rightArray[3]) {
            if ([model.titleName rangeOfString:searchText].location !=NSNotFound) {
                [self.searchArray addObject:model];
            }
        }
        [_searchTableview reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (kArrayIsEmpty(self.searchArray)) {
        return 1;
    }else{
        return self.searchArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.searchArray)) {
        return self.searchTableview.height;
    }else{
        return 110;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.searchArray)) {
        EmptyFourthViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyFourthViewCell"];
        if (!cell) {
            cell = [[EmptyFourthViewCell alloc]initWithStyle:0 reuseIdentifier:@"EmptyFourthViewCell"];
        }
        cell.emptyLabel.text = @"这里空空如也呀～";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
        return cell;
    }else{
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell" forIndexPath:indexPath];
        HomeFourthModel *model = self.searchArray[indexPath.row];
        cell.headIma.image = [UIImage imageNamed:model.titleName];
        cell.titleLabel.text = model.titleName;
        cell.subTitleLabel.text = model.subTitle;
        cell.numberLabe.text = model.loveNumber;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kArrayIsEmpty(self.searchArray)) {
        FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
        HomeFourthModel *model = self.searchArray[indexPath.row];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
