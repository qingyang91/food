//
//  HotTableViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/18.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "HotTableViewController.h"
#import "LoginFourthViewController.h"
#import "FoodDetailViewController.h"
#import "HotTableViewCell.h"
#import "HomeFourthModel.h"

@interface HotTableViewController ()<HotTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *saveArray;

@end

@implementation HotTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserInfoModel *info = [Utils GetUserInfo];
    [CollectionDataBaseManager openDB];
    NSMutableArray *collectionArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
    HomeFourthModel *homeModel = self.dataArray[0];
    HomeFourthModel *homeModel1 = self.dataArray[1];
    self.saveArray = [[NSMutableArray alloc]init];
    for (MyCollectionModel *model in collectionArray) {
        if ([model.title isEqualToString:homeModel.titleName] || [model.title isEqualToString:homeModel1.titleName]) {
            [self.saveArray addObject:model.title];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"HotTableViewCell"];
}

- (instancetype)init{
    if (self) {
        self = [super init];
        _dataArray = [NSMutableArray new];
    }
    return self;
}
- (void)initData{
    
    NSMutableArray *hotArray = [NSMutableArray new];
    NSMutableArray *rightArray = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Property List" ofType:@"plist"];
    hotArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSArray *list = [hotArray valueForKey:@"content"];
    [rightArray addObjectsFromArray:[HomeFourthModel mj_objectArrayWithKeyValuesArray:list]];
    
    if ([self.title isEqualToString:@"新手菜桌"]) {
        for (HomeFourthModel *model in rightArray[0]) {
            if ([model.titleName isEqualToString:@"丝瓜炖豆腐"] || [model.titleName isEqualToString:@"胡萝卜土豆肉丝"]) {
                [self.dataArray addObject:model];
            }
        }
    }if ([self.title isEqualToString:@"减肥集中营"]) {
        for (HomeFourthModel *model in rightArray[0]) {
            if ([model.titleName isEqualToString:@"糯米圈圈红豆汤"] || [model.titleName isEqualToString:@"胡萝卜鸡蛋卷"]) {
                [self.dataArray addObject:model];
            }
        }for (HomeFourthModel *model in rightArray[2]) {
            if ([model.titleName isEqualToString:@"糯米圈圈红豆汤"] || [model.titleName isEqualToString:@"胡萝卜鸡蛋卷"]) {
                [self.dataArray addObject:model];
            }
        }
        
    }if ([self.title isEqualToString:@"女神养成记"]) {
        for (HomeFourthModel *model in rightArray[0]) {
            if ([model.titleName isEqualToString:@"糯米圈圈红豆汤"] || [model.titleName isEqualToString:@"牛奶炖蛋"]) {
                [self.dataArray addObject:model];
            }
        }for (HomeFourthModel *model in rightArray[2]) {
            if ([model.titleName isEqualToString:@"糯米圈圈红豆汤"] || [model.titleName isEqualToString:@"牛奶炖蛋"]) {
                [self.dataArray addObject:model];
            }
        }
    }if ([self.title isEqualToString:@"养生馆"]) {
        for (HomeFourthModel *model in rightArray[3]) {
            if ([model.titleName isEqualToString:@"水晶桂花糕"] || [model.titleName isEqualToString:@"姜撞奶"]) {
                [self.dataArray addObject:model];
            }
        }
    }
}

- (void)collection:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HomeFourthModel *homeModel = self.dataArray[indexPath.section];
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        HotTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.loveBtn.selected = !cell.loveBtn.selected;
        if (cell.loveBtn.selected == YES) {
            
            UserInfoModel *info = [Utils GetUserInfo];
            [CollectionDataBaseManager openDB];
            [CollectionDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
            MyCollectionModel *collectionModel = [[MyCollectionModel alloc]init];
            collectionModel.title = homeModel.titleName;
            collectionModel.subTitle = homeModel.subTitle;
            collectionModel.detailContent = homeModel.detailContent;
            collectionModel.speciality = homeModel.speciality;
            collectionModel.name = homeModel.name;
            collectionModel.stepImaNumber = homeModel.stepImaNumber;
            collectionModel.scrollImaNumber = homeModel.scrollImaNumber;
            collectionModel.loveNumber = homeModel.loveNumber;
            collectionModel.ingredients = homeModel.ingredients;
            collectionModel.step = homeModel.step;
            collectionModel.skill = homeModel.skill;
            
            [CollectionDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] model:collectionModel];
            [cell.loveBtn setImage:[UIImage imageNamed:@"收藏-橙色（点击）"] forState:UIControlStateNormal];
            NSLog(@"===========收藏%@==========",homeModel.titleName);
        }else{
            
            UserInfoModel *info = [Utils GetUserInfo];
            [CollectionDataBaseManager openDB];
            NSMutableArray *collectionArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
            NSMutableArray *cancelArray = [NSMutableArray new];
            for (MyCollectionModel *model  in collectionArray) {
                if ([model.title isEqualToString:homeModel.titleName]) {
                    [cancelArray addObject:model];
                }
            }
            MyCollectionModel *collectionModel = cancelArray[0];
            [CollectionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] ID:collectionModel.ID];
            [cell.loveBtn setImage:[UIImage imageNamed:@"收藏-灰色（未点击）"] forState:UIControlStateNormal];
            NSLog(@"===========取消收藏%@===========",homeModel.titleName);
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    HomeFourthModel *model = self.dataArray[section];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = model.titleName;
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(15);
        make.top.equalTo(view).with.offset(20);
    }];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotTableViewCell" forIndexPath:indexPath];
    HomeFourthModel *model = self.dataArray[indexPath.section];
    cell.headIma.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1",model.titleName]];
    cell.nameLabel.text = model.name;
    cell.loveNumberLabel.text = model.loveNumber;
    cell.subTitle.text = model.subTitle;
    cell.personHead.image = [UIImage imageNamed:model.name];
    if ([self.saveArray containsObject:model.titleName]) {
        cell.loveBtn.selected = YES;
        [cell.loveBtn setImage:[UIImage imageNamed:@"收藏-橙色（点击）"] forState:UIControlStateNormal];
    }else{
        cell.loveBtn.selected = NO;
        [cell.loveBtn setImage:[UIImage imageNamed:@"收藏-灰色（未点击）"] forState:UIControlStateNormal];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeFourthModel *model = self.dataArray[indexPath.section];
    FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
