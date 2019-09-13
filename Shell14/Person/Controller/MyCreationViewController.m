//
//  MyCreationViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "MyCreationViewController.h"
#import "FoodDetailViewController.h"
#import "UploadMenuViewController.h"
#import "CustomActionSheet.h"
#import "MyCreationTableViewCell.h"
#import "EmptyFourthViewCell.h"

@interface MyCreationViewController ()<UITableViewDelegate,UITableViewDataSource,MyCreationTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCreationViewController

- (void)viewWillAppear:(BOOL)animated{
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的作品";
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self creatUI];
}

- (void)creatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MyCreationTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCreationTableViewCell"];
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
    [CreationDataBaseManager openDB];
    _dataArray = [CreationDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"creation%@",info.phone]];
    [self.tableView reloadData];
}

- (void)creaditCreation:(UITableViewCell *)cell{
    NSIndexPath *inexPath = [self.tableView indexPathForCell:cell];
    MyCreationModel *model = self.dataArray[inexPath.row];
    UploadMenuViewController *vc = [[UploadMenuViewController alloc]init];
    vc.title = @"修改菜谱";
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteCreation:(UITableViewCell *)cell{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 46)];
    view.backgroundColor = UIColorWhite;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"确定删除此作品?";
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#919191"];
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(15);
        make.left.equalTo(view).with.offset(10);
        make.right.equalTo(view).with.offset(-10);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 45, kScreenW, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [view addSubview:line];
    
    NSArray *array = @[@"确定"];
    CustomActionSheet *optionsView = [[CustomActionSheet alloc]initWithTitleView:view optionsArr:array cancelTitle:@"取消" selectedBlock:^(NSInteger index) {
        NSString *optionsStr = array[index];
        if ([optionsStr isEqualToString:@"确定"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            UserInfoModel *info = [Utils GetUserInfo];
            [CreationDataBaseManager openDB];
            MyCreationModel *model = self.dataArray[indexPath.row];
            [CreationDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"creation%@",info.phone] ID:model.ID];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            if (self.dataArray.count>1) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self initData];
        }
    } cancelBlock:^{
        
    }];
    [self.view addSubview:optionsView];
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
        return 240;
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
        MyCreationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCreationTableViewCell" forIndexPath:indexPath];
        MyCreationModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.time;
        cell.nameLabel.text = model.name;
        cell.foodIma.image = [UIImage imageWithData:model.imageData];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!kArrayIsEmpty(self.dataArray)) {
        MyCreationModel *model = self.dataArray[indexPath.row];
        FoodDetailViewController *vc = [[FoodDetailViewController alloc]init];
        vc.creationModel = model;
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
