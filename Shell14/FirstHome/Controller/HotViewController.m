//
//  HotViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/18.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "HotViewController.h"
#import "HotTableViewController.h"
#import "YHSegmentView.h"

@interface HotViewController ()

@property (nonatomic, strong) YHSegmentView *segmentView;

@end

@implementation HotViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   [self creatUI];
}
- (void)creatUI{
    NSArray *titleArray = @[@"新手菜桌",@"减肥集中营",@"女神养成记",@"养生馆"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < titleArray.count; i++) {
        HotTableViewController *tabVC = [[HotTableViewController alloc]init];
        tabVC.title = titleArray[i];
        [array addObject:tabVC];
    }
    
    _segmentView = [[YHSegmentView alloc]initWithFrame:CGRectMake(0, kNavBarHAbove7, kScreenW, kScreenH-kNavBarHAbove7) ViewControllersArr:[array copy] TitleArr:titleArray TitleNormalSize:12 TitleSelectedSize:14 SegmentStyle:YHSegementStyleIndicate ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        
    }];
    
    _segmentView.yh_titleNormalColor = UIColorWhite;
    _segmentView.yh_titleSelectedColor = UIColorWhite;
    _segmentView.yh_segmentTintColor = UIColorWhite;
    _segmentView.yh_defaultSelectIndex = self.number;
    [self.view addSubview:_segmentView];
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
