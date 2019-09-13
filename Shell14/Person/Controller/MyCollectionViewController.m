//
//  MyCollectionViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "FoodDetailViewController.h"
#import "KitchenDetailTableViewCell.h"
#import "EmptyFourthViewCell.h"
#import "HomeFourthModel.h"

@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,KitchenDetailTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self creatUI];
    [self initData];
}

- (void)creatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"KitchenDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"KitchenDetailTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)initData{
    UserInfoModel *info = [Utils GetUserInfo];
    [CollectionDataBaseManager openDB];
    self.dataArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
    [self.tableView reloadData];
}

- (void)collection:(UITableViewCell *)cell{
    UserInfoModel *info = [Utils GetUserInfo];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [CollectionDataBaseManager openDB];
    MyCollectionModel *model = self.dataArray[indexPath.row];
    [CollectionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] ID:model.ID];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    if (self.dataArray.count>1) {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self initData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (kArrayIsEmpty(self.dataArray)) {
        return 1;
    }else{
         return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.dataArray)) {
        return self.tableView.height;
    }else{
         return 276;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kArrayIsEmpty(self.dataArray)) {
        EmptyFourthViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (!cell) {
            cell = [[EmptyFourthViewCell alloc]initWithStyle:0 reuseIdentifier:@"cellID"];
        }
        cell.emptyLabel.text = @"这里空空如也呀～";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        KitchenDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KitchenDetailTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        MyCollectionModel *model = self.dataArray[indexPath.row];
        cell.headIma.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",model.title]];
        cell.titleLabel.text = model.title;
        cell.subTitleLabel.text = model.subTitle;
        cell.numberLabel.text = model.loveNumber;
        [cell.collecBtn setImage:[UIImage imageNamed:@"收藏-橙色（点击）"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kArrayIsEmpty(self.dataArray)) {
        MyCollectionModel *model = self.dataArray[indexPath.row];
        FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
        HomeFourthModel *homeModel = [[HomeFourthModel alloc]init];
        homeModel.titleName = model.title;
        homeModel.subTitle = model.subTitle;
        homeModel.detailContent = model.detailContent;
        homeModel.name = model.name;
        homeModel.speciality = model.speciality;
        homeModel.step = model.step;
        homeModel.stepImaNumber = model.stepImaNumber;
        homeModel.skill = model.skill;
        homeModel.ingredients = model.ingredients;
        homeModel.scrollImaNumber = model.scrollImaNumber;
        vc.model = homeModel;
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
