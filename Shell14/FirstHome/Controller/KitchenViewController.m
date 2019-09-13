//
//  KitchenViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/18.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "KitchenViewController.h"
#import "FoodDetailViewController.h"
#import "KitchenDetailTableViewCell.h"
#import "LoginFourthViewController.h"
#import "HomeFourthModel.h"

@interface KitchenViewController ()<UITableViewDelegate,UITableViewDataSource,KitchenDetailTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *saveArray;

@end

@implementation KitchenViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserInfoModel *info = [Utils GetUserInfo];
    [CollectionDataBaseManager openDB];
    NSMutableArray *collectionArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
    HomeFourthModel *homeModel = self.dataArray[0];
    HomeFourthModel *homeModel1 = self.dataArray[1];
    HomeFourthModel *homeModel2 = self.dataArray[2];
    self.saveArray = [[NSMutableArray alloc]init];
    for (MyCollectionModel *model in collectionArray) {
        if ([model.title isEqualToString:homeModel.titleName] || [model.title isEqualToString:homeModel1.titleName] || [model.title isEqualToString:homeModel2.titleName]) {
            [self.saveArray addObject:model.title];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"厨房故事";
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self creatTableView];
    [self creatHeaderView];
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"KitchenDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"KitchenDetailTableViewCell"];
    [self.view addSubview:_tableView];
}
- (void)creatHeaderView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.imageName]];
    imageView.frame = CGRectMake(0, 0, kScreenW, 150);
    self.tableView.tableHeaderView = imageView;
}

- (void)collection:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HomeFourthModel *model = self.dataArray[indexPath.row];
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        KitchenDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.collecBtn.selected = !cell.collecBtn.selected;
        if (cell.collecBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [CollectionDataBaseManager openDB];
            [CollectionDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
            MyCollectionModel *collectionModel = [[MyCollectionModel alloc]init];
            collectionModel.title = model.titleName;
            collectionModel.subTitle = model.subTitle;
            collectionModel.detailContent = model.detailContent;
            collectionModel.speciality = model.speciality;
            collectionModel.name = model.name;
            collectionModel.stepImaNumber = model.stepImaNumber;
            collectionModel.scrollImaNumber = model.scrollImaNumber;
            collectionModel.loveNumber = model.loveNumber;
            collectionModel.ingredients = model.ingredients;
            collectionModel.step = model.step;
            collectionModel.skill = model.skill;
            
            [CollectionDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] model:collectionModel];
            [cell.collecBtn setImage:[UIImage imageNamed:@"收藏-橙色（点击）"] forState:UIControlStateNormal];
            NSLog(@"===========收藏%@==========",model.titleName);
        }else{
            
            UserInfoModel *info = [Utils GetUserInfo];
            [CollectionDataBaseManager openDB];
            NSMutableArray *collectionArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
            NSMutableArray *cancelArray = [NSMutableArray new];
            for (MyCollectionModel *model  in collectionArray) {
                if ([model.title isEqualToString:cell.titleLabel.text]) {
                    [cancelArray addObject:model];
                }
            }
            MyCollectionModel *collectionModel = cancelArray[0];
            [CollectionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] ID:collectionModel.ID];
            [cell.collecBtn setImage:[UIImage imageNamed:@"收藏-灰色（未点击）"] forState:UIControlStateNormal];
            NSLog(@"===========取消收藏%@===========",model.titleName);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 276;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KitchenDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KitchenDetailTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    HomeFourthModel *model = self.dataArray[indexPath.row];
    cell.headIma.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",model.titleName]];
    cell.titleLabel.text = model.titleName;
    cell.subTitleLabel.text = model.subTitle;
    cell.numberLabel.text = model.loveNumber;
    if ([self.saveArray containsObject:cell.titleLabel.text]) {
        cell.collecBtn.selected = YES;
        [cell.collecBtn setImage:[UIImage imageNamed:@"收藏-橙色（点击）"] forState:UIControlStateNormal];
    }else{
        cell.collecBtn.selected = NO;
        [cell.collecBtn setImage:[UIImage imageNamed:@"收藏-灰色（未点击）"] forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeFourthModel *model = self.dataArray[indexPath.row];
    FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
