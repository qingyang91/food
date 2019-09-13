//
//  FoodDetailViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/22.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "LoginFourthViewController.h"
#import "HomeFourthTableViewCell.h"
#import "AttentionModel.h"
#import "MyAttentionViewCell.h"
#import "IngredientsTableViewCell.h"
#import "StepTableViewCell.h"
#import "SkillTableViewCell.h"
#import "HeightFont.h"

@interface FoodDetailViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MyAttentionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *attArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIButton *loveBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *scrollerView;
@property (nonatomic, strong) MyAttentionViewCell *attentionCell;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIView *skillView;


@end

@implementation FoodDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfoModel *info = [Utils GetUserInfo];
    [CollectionDataBaseManager openDB];
    NSMutableArray *saveArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
    [AttentionDataBaseManager openDB];
    NSMutableArray *attentionArray = [AttentionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"attention%@",info.phone]];
    NSMutableArray *array = [NSMutableArray array];
    self.attArray = [NSMutableArray array];
    for (MyCollectionModel *model in saveArray) {
        if ([model.title isEqualToString:self.model.titleName]) {
            [array addObject:model];
        }
    }
    for (MyAttentionModel *model in attentionArray) {
        if ([model.name isEqualToString:self.model.name]) {
            [self.attArray addObject:model.name];
        }
    }
    if (kArrayIsEmpty(array)) {
        _loveBtn.selected = NO;
    }else{
        _loveBtn.selected = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (scrollView.contentOffset.y < 0) {
        
        //向上拖动，隐藏导航栏
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }else if (scrollView.contentOffset.y > 0){
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        CGFloat alpha = scrollView.contentOffset.y /64 >1.0f ? 1:scrollView.contentOffset.y/64;
        if (alpha >= 1) {
            alpha = 0.99;
        }
    }else if(velocity == 0){
      
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
    if (self.model) {
        self.title = self.model.titleName;
    }else{
        self.title = self.creationModel.name;
    }
   
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
  
    [self setTableView];
    [self creatHeadView];
    [self creatDetailView];
    [self creatskillView];
    [self creatUI];
}

- (void)creatUI{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, KHeight_StatusBar)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#FA8C16"];
    [self.view addSubview:topView];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"左退"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(topView.mas_bottom).with.offset(13);
        make.width.height.mas_equalTo(24);
    }];
    
    _loveBtn = [[UIButton alloc]init];
    [_loveBtn setImage:[UIImage imageNamed:@"收藏-圆形"] forState:UIControlStateNormal];
    [_loveBtn setImage:[UIImage imageNamed:@"收藏-圆形 点击"] forState:UIControlStateSelected];
    [_loveBtn addTarget:self action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.model) {
        [self.view addSubview:_loveBtn];
        [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).with.offset(-20);
            make.top.equalTo(topView.mas_bottom).with.offset(13);
            make.width.height.mas_equalTo(24);
        }];
    }
}

- (void)setTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHeight_StatusBar, kScreenW, kScreenH-KHeight_StatusBar) style:UITableViewStylePlain];
    _tableView.backgroundColor = UIColorWhite;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"HomeFourthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeFourthTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MyAttentionViewCell" bundle:nil] forCellReuseIdentifier:@"MyAttentionViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"IngredientsTableViewCell" bundle:nil] forCellReuseIdentifier:@"IngredientsTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SkillTableViewCell" bundle:nil] forCellReuseIdentifier:@"SkillTableViewCell"];
    [self.view addSubview:_tableView];
}
- (void)creatHeadView{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    if (self.model) {
        for (NSInteger i = 0; i<[self.model.scrollImaNumber integerValue]; i++) {
            NSString *string = [NSString stringWithFormat:@"%@成品-%ld",self.model.titleName,i+1];
            [imageArray addObject:string];
        }
        _scrollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, 165) imageNamesGroup:imageArray];
    }else{
        _scrollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, 165) delegate:self placeholderImage:[UIImage imageWithData:self.creationModel.imageData]];
    }
    _scrollerView.pageControlAliment = SDCycleScrollViewPageContolStyleAnimated;
    _scrollerView.clipsToBounds = NO;
    _scrollerView.backgroundColor = [UIColor clearColor];
    _scrollerView.currentPageDotColor = [UIColor colorWithHexString:@"#FA8C16"];
    _scrollerView.pageControlDotSize = CGSizeMake(3, 3);
    _scrollerView.autoScrollTimeInterval = 2;
    _scrollerView.delegate = self;
    _scrollerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollerView.autoScroll = YES;
}
- (void)creatDetailView{
    CGFloat height;
    if (self.model) {
       height = [HeightFont getStringHeight:self.model.detailContent andFont:12 andWidth:kScreenW-30];
    }else{
        height = [HeightFont getStringHeight:self.creationModel.content andFont:12 andWidth:kScreenW-30];
    }
    
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, height)];
    
    UILabel *label = [[UILabel alloc]init];
    if (self.model) {
        label.text = self.model.detailContent;
    }else{
        label.text = self.creationModel.content;
    }
    
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#282828"];
    label.numberOfLines = 0;
    
    [_detailView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.detailView);
        make.left.equalTo(self.detailView).with.offset(15);
        make.right.equalTo(self.detailView).with.offset(-15);
    }];
}
- (void)creatskillView{
    NSString *string;
    if (self.model) {
        string = [self.model.skill stringByReplacingOccurrencesOfString:@"；" withString:@"\n"];
    }else{
       string = [self.creationModel.skill stringByReplacingOccurrencesOfString:@"；" withString:@"\n"];
    }
    NSLog(@"string==%@",string);
    CGFloat height = [HeightFont getStringHeight:string andFont:12 andWidth:kScreenW-30];
    _skillView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, height+AutoHeight(10))];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = string;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#282828"];
    label.numberOfLines = 0;
    
    [_skillView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skillView).with.offset(AutoHeight(10));
        make.left.equalTo(self.skillView).with.offset(15);
        make.right.equalTo(self.skillView).with.offset(-15);
    }];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 收藏
- (void)collectionClick:(UIButton *)btn{
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        btn.selected = !btn.selected;
        if (btn.selected == YES) {
            [self collectionFood];
        }else{
            [self deleteFood];
        }
    }
}
- (void)collectionFood{
    
    UserInfoModel *info = [Utils GetUserInfo];
    [CollectionDataBaseManager openDB];
    [CollectionDataBaseManager creatTableWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
    MyCollectionModel *model = [[MyCollectionModel alloc]init];
    model.title = _model.titleName;
    model.subTitle = _model.subTitle;
    model.detailContent = _model.detailContent;
    model.speciality = _model.speciality;
    model.name = _model.name;
    model.stepImaNumber = _model.stepImaNumber;
    model.scrollImaNumber = _model.scrollImaNumber;
    model.loveNumber = _model.loveNumber;
    model.ingredients = _model.ingredients;
    model.step = _model.step;
    model.skill = _model.skill;
    [CollectionDataBaseManager insertDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] model:model];
}
- (void)deleteFood{
    
    UserInfoModel *info = [Utils GetUserInfo];
    [CollectionDataBaseManager openDB];
    NSMutableArray *collectionArray = [CollectionDataBaseManager selectAllDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone]];
    NSMutableArray *deleteArray = [NSMutableArray new];
    for (MyCollectionModel *model in collectionArray) {
        if ([model.title isEqualToString:self.model.titleName]) {
            [deleteArray addObject:model];
        }
    }
    MyCollectionModel *model = deleteArray[0];
    [CollectionDataBaseManager deleteDataWithTableName:[NSString stringWithFormat:@"collection%@",info.phone] ID:model.ID];
}
#pragma mark 关注
- (void)cancelAttention:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AttentionModel *model = [[AttentionModel alloc]init];
    model.name = self.model.name;
    model.content = self.model.speciality;
    UserInfoModel *info = [Utils GetUserInfo];
    if (kStringIsEmpty(info.phone)) {
        LoginFourthViewController *vc = [[LoginFourthViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        MyAttentionViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        if (self.model) {
            NSArray *array = [self.model.ingredients componentsSeparatedByString:@";"];
            return array.count;
        }else{
            NSArray *array = [self.creationModel.material componentsSeparatedByString:@";"];
            return array.count;
        }
    }if (section == 4) {
        if (self.model) {
            return [self.model.stepImaNumber integerValue];
        }else{
            return [self.creationModel.stepNumber integerValue];
        }
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 4 ) {
        return AutoHeight(40);
    }if (section == 2) {
        return AutoHeight(20);
    }if (section == 3) {
        return AutoHeight(25)+18;
    }if (section == 5) {
        if (self.model) {
            if (kStringIsEmpty(self.model.skill)) {
                return 0.1;
            }else{
                return AutoHeight(40);
            }
        }
        else{
            return AutoHeight(40);
        }
    }else{
        return 0.1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(40))];
        view.backgroundColor = UIColorWhite;
        
        UILabel *label = [[UILabel alloc]init];
        if (self.model) {
            label.text = self.model.titleName;
        }else{
            label.text = self.creationModel.name;
        }
       
        label.font = [UIFont boldSystemFontOfSize:18];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(AutoHeight(20));
        }];
        return view;
    }if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(20))];
        view.backgroundColor = UIColorWhite;
        return view;
    }if (section == 3) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(25)+18)];
        view.backgroundColor = UIColorWhite;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"所需食材";
        label.font = [UIFont boldSystemFontOfSize:16];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(AutoHeight(20));
        }];
        return view;
    }if (section == 4) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(40))];
        view.backgroundColor = UIColorWhite;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"烹饪步骤";
        label.font = [UIFont boldSystemFontOfSize:16];
        
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).with.offset(15);
            make.top.equalTo(view).with.offset(AutoHeight(20));
        }];
        return view;
    }if (section == 5) {
        if (self.model) {
            if (kStringIsEmpty(self.model.skill)) {
                return nil;
            }else{
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(40))];
                view.backgroundColor = UIColorWhite;
                
                UILabel *label = [[UILabel alloc]init];
                label.text = @"烹饪技巧";
                label.font = [UIFont boldSystemFontOfSize:16];
                
                [view addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view).with.offset(15);
                    make.top.equalTo(view).with.offset(AutoHeight(20));
                }];
                return view;
            }
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, AutoHeight(40))];
            view.backgroundColor = UIColorWhite;
            
            UILabel *label = [[UILabel alloc]init];
            label.text = @"烹饪技巧";
            label.font = [UIFont boldSystemFontOfSize:16];
            
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).with.offset(15);
                make.top.equalTo(view).with.offset(AutoHeight(20));
            }];
            return view;
        }
        
    }else{
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = UIColorWhite;
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 165;
    }if (indexPath.section == 2) {
        if (self.model) {
            CGFloat height = [HeightFont getStringHeight:self.model.detailContent andFont:12 andWidth:kScreenW-30];
            return height;
        }else{
            CGFloat height = [HeightFont getStringHeight:self.creationModel.content andFont:12 andWidth:kScreenW-30];
            return height;
        }
        
    }if (indexPath.section == 3) {
        return 45;
    }if (indexPath.section == 4) {
        if (self.model) {
            CGFloat height = [HeightFont getStringHeight:[self.model.step componentsSeparatedByString:@"；"][indexPath.row] andFont:12 andWidth:kScreenW-30];
            return 165+AutoHeight(25)+height;
        }else{
            CGFloat height = [HeightFont getStringHeight:[self.creationModel.step componentsSeparatedByString:@"；"][indexPath.row] andFont:12 andWidth:kScreenW-30];
            return 165+AutoHeight(25)+height;
        }
        
    }if (indexPath.section == 5) {
        if (self.model) {
            CGFloat height = [HeightFont getStringHeight:[self.model.skill stringByReplacingOccurrencesOfString:@"；" withString:@"\n"]andFont:12 andWidth:kScreenW-30];
            return height+AutoHeight(10);
        }else{
            CGFloat height = [HeightFont getStringHeight:[self.creationModel.skill stringByReplacingOccurrencesOfString:@"；" withString:@"\n"]andFont:12 andWidth:kScreenW-30];
            return height+AutoHeight(10);
        }
        
    }else{
        return 66;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeFourthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFourthTableViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:self.scrollerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }if (indexPath.section == 2) {
        HomeFourthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeFourthTableViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:self.detailView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }if (indexPath.section == 3) {
        IngredientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientsTableViewCell" forIndexPath:indexPath];
        NSArray *dataArray;
        if (self.model) {
            dataArray = [self.model.ingredients componentsSeparatedByString:@";"];
        }else{
            dataArray = [self.creationModel.material componentsSeparatedByString:@";"];
        }
        NSLog(@"材料%@",dataArray[indexPath.row]);
        cell.nameLabel.text = [dataArray[indexPath.row] componentsSeparatedByString:@"-"][0];
        cell.dosageLabel.text = [dataArray[indexPath.row] componentsSeparatedByString:@"-"][1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }if (indexPath.section == 4) {
        StepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (!cell) {
            cell = [[StepTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cellID"];
        }
        cell.stepOneLabel.text = [NSString stringWithFormat:@"步骤%ld/",indexPath.row+1];
        if (self.model) {
            cell.stepImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%ld",self.model.titleName,indexPath.row+1]];
            cell.stepTwoLabel.text = self.model.stepImaNumber;
            cell.stepDesLabel.text = [self.model.step componentsSeparatedByString:@"；"][indexPath.row];
            NSLog(@"步骤%@",[self.model.step componentsSeparatedByString:@"；"][indexPath.row]);
        }else{
            _imageArray = [NSMutableArray new];
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * documentsDirectory = [paths objectAtIndex:0];
            
            for (NSInteger i = 0; i < [self.creationModel.stepNumber integerValue]; i++) {
                NSString * path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents%@%ld.png", self.creationModel.name, i]];;
                NSData * data = [NSData dataWithContentsOfFile:path];
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    [_imageArray addObject:image];
                }
            }
            cell.stepImageView.image = _imageArray[indexPath.row];
            cell.stepTwoLabel.text = self.creationModel.stepNumber;
            cell.stepDesLabel.text = [self.creationModel.step componentsSeparatedByString:@"；"][indexPath.row];
        }
        cell.stepImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }if (indexPath.section == 5) {
        SkillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkillTableViewCell" forIndexPath:indexPath];
        [cell.contentView addSubview:self.skillView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        _attentionCell = [tableView dequeueReusableCellWithIdentifier:@"MyAttentionViewCell" forIndexPath:indexPath];
        if (self.model) {
            _attentionCell.headIma.image = [UIImage imageNamed:self.model.name];
            _attentionCell.nameLabel.text = self.model.name;
            _attentionCell.contentLabel.text = self.model.speciality;
            _attentionCell.attentionBtn.layer.cornerRadius = 10;
            _attentionCell.attentionBtn.layer.masksToBounds = YES;
            if ([self.attArray containsObject:_attentionCell.nameLabel.text]) {
                _attentionCell.attentionBtn.selected = YES;
                [_attentionCell.attentionBtn setTitle:@"关注中" forState:UIControlStateNormal];
            }else{
                _attentionCell.attentionBtn.selected = NO;
                [_attentionCell.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
            }
            _attentionCell.delegate = self;
        }else{
            UserInfoModel *info = [Utils GetUserInfo];
            _attentionCell.headIma.image = [UIImage imageNamed:@"head"];
            _attentionCell.nameLabel.text = info.phone;
            _attentionCell.contentLabel.text = @"";
            _attentionCell.attentionBtn.hidden = YES;
        }
        _attentionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _attentionCell;
    }
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
