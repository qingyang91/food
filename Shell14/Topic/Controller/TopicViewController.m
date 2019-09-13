//
//  TopicViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/16.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "TopicViewController.h"
#import "LoginFourthViewController.h"
#import "TopicDetailViewController.h"
#import "PXFourthNavViewController.h"
#import "FourthMineViewController.h"
#import "TopicTableViewCell.h"
#import "MyLikeModel.h"
#import "LikeDataBase.h"
#import "TopicModel.h"

@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource,TopicTableViewCellDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *saveArray;
@property (nonatomic, strong) NSMutableArray *saveLikeArray;
@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TopicViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserInfoModel *info = [Utils GetUserInfo];
    [AttentionDataBaseManager openDB];
    NSMutableArray *attentionArray = [AttentionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
    self.saveArray = [NSMutableArray new];
    for (MyAttentionModel *model in attentionArray) {
        if ([model.name isEqualToString:@"Louis"] || [model.name isEqualToString:@"Ruth"] || [model.name isEqualToString:@"Scott Smith"] ||[model.name isEqualToString:@"Darcy"]) {
            [self.saveArray addObject:model.name];
        }
    }
    [LikeDataBaseManager openDB];
    NSMutableArray *likeArray = [LikeDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone]];
    self.saveLikeArray = [NSMutableArray new];
    for (MyLikeModel *model in likeArray) {
        if ([model.content isEqualToString:@"#巧克力脆皮雪糕#"] || [model.content isEqualToString:@"#今天吃什么#"] || [model.content isEqualToString:@"#做一个甜点#"] || [model.content isEqualToString:@"#一起来学习做甜品#"]) {
            [self.saveLikeArray addObject:model.content];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tabBarController.delegate = self;
    [self creatUI];
    [self initData];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 1) {
        [self initData];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *controller = tabBarController.selectedViewController;
    if ([controller isEqual:viewController]) {
        return NO;
    }
    return YES;
}

- (void)creatUI{
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (NSMutableArray *)topicArray{
    if (!_topicArray) {
        _topicArray = [NSMutableArray new];
    }
    return _topicArray;
}
- (void)initData{
    NSMutableArray *nameArray = [NSMutableArray arrayWithObjects:@"Louis",@"Ruth",@"Scott Smith",@"Darcy", nil];
    NSMutableArray *speciallyArray = [NSMutableArray arrayWithObjects:@"烘培、泰国菜",@"营养餐、沙拉",@"烘培、泰国菜",@"日料、西点、法国菜", nil];
    NSMutableArray *imaNameArray = [NSMutableArray arrayWithObjects:@"巧克力脆皮雪糕1",@"丝瓜炖豆腐1",@"萌萌的斑点蛋糕卷1",@"水晶桂花糕1", nil];
    NSMutableArray *tagArray = [NSMutableArray arrayWithObjects:@"#巧克力脆皮雪糕#",@"#今天吃什么#",@"#做一个甜点#",@"#一起来学习做甜品#", nil];
    NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:@"我学会了做巧克力脆皮雪糕",@"“丝瓜炖豆腐”超好吃哟",@"萌萌的斑点蛋糕卷",@"今天做了水晶桂花糕", nil];
    NSMutableArray *likeArray = [NSMutableArray arrayWithObjects:@"32",@"68",@"45",@"89", nil];
    for (NSInteger i = 0; i<nameArray.count; i++) {
        TopicModel *model = [[TopicModel alloc]init];
        model.name = nameArray[i];
        model.speciality = speciallyArray[i];
        model.tagName = tagArray[i];
        model.imageName = imaNameArray[i];
        model.detailContent = contentArray[i];
        model.likeNumber = likeArray[i];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        model.time = [formatter stringFromDate:[NSDate date]];
        [self.dataArray addObject:model];
    }
    
    UserInfoModel *info = [Utils GetUserInfo];
    [TopicDataBaseManager openDB];
    _topicArray = [TopicDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"topic%@",info.phone]];
    [_tableView reloadData];
}
#pragma mark 关注
- (void)attentionClick:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TopicModel *model = self.dataArray[indexPath.row];
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        TopicTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.attentionBtn.selected = !cell.attentionBtn.selected;
        if (cell.attentionBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [AttentionDataBaseManager openDB];
            [AttentionDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
            MyAttentionModel *attentionModel = [[MyAttentionModel alloc]init];
            attentionModel.name = model.name;
            attentionModel.content = model.speciality;
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

#pragma mark 点赞
- (void)likeClick:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TopicModel *model = self.dataArray[indexPath.row];
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        TopicTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.likeBtn.selected = !cell.likeBtn.selected;
        if (cell.likeBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [LikeDataBaseManager openDB];
            [LikeDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"like%@",info.phone]];
            MyLikeModel *likeModel = [[MyLikeModel alloc]init];
            likeModel.content = model.tagName;
            [LikeDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone] model:likeModel];
            [cell.likeBtn setImage:[UIImage imageNamed:@"like 橙色"] forState:UIControlStateNormal];
        }else{
            
            UserInfoModel *info = [Utils GetUserInfo];
            [LikeDataBaseManager openDB];
            NSMutableArray *saveArray = [LikeDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone]];
            NSMutableArray *deleteArray = [NSMutableArray new];
            for (MyLikeModel *model in saveArray) {
                if ([model.content isEqualToString:cell.tagLabel.text]) {
                    [deleteArray addObject:model];
                }
            }
            MyLikeModel *model = deleteArray[0];
            [LikeDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"like%@",info.phone] ID:model.ID];
            [cell.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4+self.topicArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 320;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicTableViewCell" forIndexPath:indexPath];
    if (indexPath.row<4) {
        TopicModel *model = self.dataArray[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.speciallyLabel.text = model.speciality;
        cell.tagLabel.text = model.tagName;
        cell.contentLabel.text = model.detailContent;
        cell.likeNumLabel.text = model.likeNumber;
        cell.timeLabel.text = model.time;
        cell.foodIma.image = [UIImage imageNamed:model.imageName];
        cell.headIma.image = [UIImage imageNamed:model.name];
        cell.attentionBtn.userInteractionEnabled = YES;
        cell.likeBtn.userInteractionEnabled = YES;
        cell.delegate = self;
        if ([self.saveArray containsObject:cell.nameLabel.text]) {
            cell.attentionBtn.selected = YES;
            [cell.attentionBtn setTitle:@"关注中" forState:UIControlStateNormal];
        }else{
            cell.attentionBtn.selected = NO;
            [cell.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
        if ([self.saveLikeArray containsObject:cell.tagLabel.text]) {
            cell.likeBtn.selected = YES;
            [cell.likeBtn setImage:[UIImage imageNamed:@"like 橙色"] forState:UIControlStateNormal];
        }else{
            cell.likeBtn.selected = NO;
            [cell.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        }
    }else{
        UserInfoModel *info = [Utils GetUserInfo];
        MyTopicModel *model = self.topicArray[indexPath.row-4];
        cell.nameLabel.text = info.phone;
        cell.headIma.image = [UIImage imageNamed:@"head"];
        cell.contentLabel.text = model.content;
        cell.tagLabel.text = [NSString stringWithFormat:@"#%@#",model.tagName];
        cell.timeLabel.text = model.time;
        cell.speciallyLabel.text = @"";
        cell.likeNumLabel.text = @"";
        cell.foodIma.image = [UIImage imageWithData:model.imageData];
        cell.likeBtn.userInteractionEnabled = NO;
        [cell.likeBtn setImage:[UIImage imageNamed:@"like 灰"] forState:UIControlStateNormal];
        cell.attentionBtn.userInteractionEnabled = NO;
        [cell.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
    cell.attentionBtn.layer.cornerRadius = 10;
    cell.attentionBtn.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<4) {
        TopicModel *model = self.dataArray[indexPath.row];
        TopicDetailViewController *vc = [[TopicDetailViewController alloc]init];
        vc.model = model;
        TopicTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.attentionBtn.selected == YES) {
            vc.isAttention = 0;
        }else{
            vc.isAttention = 1;
        }
        if (cell.likeBtn.selected == YES) {
            vc.isLike = 0;
        }else{
            vc.isLike = 1;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MyTopicModel *model = self.topicArray[indexPath.row-4];
        TopicDetailViewController *vc = [[TopicDetailViewController alloc]init];
        vc.topModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7-KHeight_TabBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorWhite;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"TopicTableViewCell"];
    }
    return _tableView;
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
