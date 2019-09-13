//
//  MyAttentionViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "CustomActionSheet.h"
#import "MyAttentionViewCell.h"
#import "EmptyFourthViewCell.h"

@interface MyAttentionViewController ()<UITableViewDelegate,UITableViewDataSource,MyAttentionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyAttentionViewController


- (void)viewWillAppear:(BOOL)animated{
    if ([self.title isEqualToString:@"我的关注"]) {
        [self initData];
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
    [self creatUI];
}

- (void)creatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MyAttentionViewCell" bundle:nil] forCellReuseIdentifier:@"MyAttentionViewCell"];
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
    [AttentionDataBaseManager openDB];
    _dataArray = [AttentionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
    [self.tableView reloadData];
}

- (void)cancelAttention:(UITableViewCell *)cell{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 46)];
    view.backgroundColor = UIColorWhite;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"确定不再关注此人";
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
    
    CustomActionSheet *actionSheet = [[CustomActionSheet alloc]initWithTitleView:view optionsArr:@[@"确定"] cancelTitle:@"取消" selectedBlock:^(NSInteger index) {
        if (index == 0) {
            UserInfoModel *info = [Utils GetUserInfo];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [AttentionDataBaseManager openDB];
            MyAttentionModel *model = self.dataArray[indexPath.row];
            [AttentionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone] ID:model.ID];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            if (self.dataArray.count>1) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self initData];
        }
    } cancelBlock:^{
        
    }];
    [self.view addSubview:actionSheet];
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
        return 68;
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
        MyAttentionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAttentionViewCell" forIndexPath:indexPath];
        MyAttentionModel *model = self.dataArray[indexPath.row];
        cell.headIma.image = [UIImage imageNamed:model.name];
        cell.nameLabel.text = model.name;
        cell.contentLabel.text = model.content;
        cell.attentionBtn.layer.cornerRadius = 10;
        cell.attentionBtn.layer.masksToBounds = YES;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
