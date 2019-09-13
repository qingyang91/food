//
//  CategoryViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/16.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "CategoryViewController.h"
#import "FoodDetailViewController.h"
#import "SearchViewController.h"
#import "HomeFourthModel.h"
#import "FoodTableViewCell.h"
#import "LeftTableViewCell.h"


@interface CategoryViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSIndexPath *lastPath;
@property (nonatomic, assign) BOOL isRepeatRolling;

@end

@implementation CategoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenW-80,25)];
    titleView.backgroundColor = UIColorWhite;
    titleView.layer.cornerRadius = 6;
    titleView.layer.masksToBounds = YES;
    titleView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(push)];
    [titleView addGestureRecognizer:tap];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,kScreenW-80,25)];
    _searchBar.placeholder = @"搜索菜谱、食材";
    _searchBar.userInteractionEnabled = NO;
    _searchBar.tintColor = [UIColor colorWithHexString:@"#E9E9E9"];
    UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor colorWithHexString:@"#E9E9E9"] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    self.isRepeatRolling = NO;
    
    if (@available(iOS 11.0, *)) {
        _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self creatTabView];
}
- (void)push{
    SearchViewController *vc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)creatTabView{
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW/4, kScreenH-kNavBarHAbove7) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeftTableViewCell"];
    [self.view addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenW/4+18, kNavBarHAbove7, kScreenW-kScreenW/4-36, kScreenH-kNavBarHAbove7) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.showsVerticalScrollIndicator = NO;
    [_rightTableView registerNib:[UINib nibWithNibName:@"FoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoodTableViewCell"];
    [self.view addSubview:_rightTableView];
}
- (NSMutableArray *)rightArray{
    if (!_rightArray) {
        _rightArray = [NSMutableArray new];
    }
    return _rightArray;
}
- (void)initData{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Property List" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSArray *list = [self.dataArray valueForKey:@"content"];
    [self.rightArray addObjectsFromArray:[HomeFourthModel mj_objectArrayWithKeyValuesArray:list]];
    
    self.isRepeatRolling = YES;
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.rightTableView) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.dataArray.count;
    }else{
        return ((NSMutableArray *)self.rightArray[section]).count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        return 38;
    }else{
        return 105;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        return 38;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = [self.dataArray valueForKey:@"title"][indexPath.row];
        NSInteger row = [indexPath row];
        NSInteger oldRow = [_lastPath row];
        if (row == oldRow && _lastPath != nil) {
            // 被选中状态
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#FA8C16"];
        }else{
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        
        return cell;
    }else{
        FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodTableViewCell" forIndexPath:indexPath];
        HomeFourthModel *model = self.rightArray[indexPath.section][indexPath.row];
        cell.headIma.image = [UIImage imageNamed:model.titleName];
        cell.titleLabel.text = model.titleName;
        cell.subTitleLabel.text = model.subTitle;
        cell.numberLabel.text = model.loveNumber;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.rightTableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.rightTableView.width, 38)];
        view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = [self.dataArray valueForKey:@"title"][section];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"#BFBFBF"];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.top.equalTo(view).with.offset(10);
        }];
        return view;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        NSInteger newRow = [indexPath row];
        NSInteger oldRow = (self .lastPath != nil)?[self .lastPath row]:-1;
        if (newRow != oldRow) {
            LeftTableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.titleLabel.textColor = [UIColor colorWithHexString:@"#FA8C16"];
            LeftTableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastPath];
            oldCell.textLabel.textColor = [UIColor blackColor];
        }
        self.lastPath = indexPath;
        self.isRepeatRolling = YES;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }if (tableView == self.rightTableView) {
        HomeFourthModel *model = self.rightArray[indexPath.section][indexPath.row];
        FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.rightTableView) {
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        if (bottomOffset <= height) {
            NSIndexPath *bottomIndexPath = [[self.rightTableView indexPathsForVisibleRows] lastObject];
            NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:bottomIndexPath.section inSection:0];
            if (self.isRepeatRolling == NO) { // 防止重复滚动
                [self.leftTableView selectRowAtIndexPath:moveIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        } else {
            NSIndexPath *topIndexPath = [[self.rightTableView indexPathsForVisibleRows]firstObject];
            NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:topIndexPath.section inSection:0];
            if (self.isRepeatRolling == NO) {
                [self.leftTableView selectRowAtIndexPath:moveIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }else{
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isRepeatRolling = NO;
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
