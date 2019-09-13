//
//  PXFourthTabBarViewController.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/16.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "PXFourthTabBarViewController.h"
#import "PXFourthNavViewController.h"
#import "FourthHomeViewController.h"
#import "FourthMineViewController.h"
#import "TopicViewController.h"
#import "LoginFourthViewController.h"
#import "DHGuidePageHUD.h"

@interface PXFourthTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation PXFourthTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate = self;
    FourthHomeViewController *statistVC = [[FourthHomeViewController alloc] init];
    [self addChildVc:statistVC title:@"首页" image:@"首页" selectedImage:@"首页-hover"];
    TopicViewController *shopVC = [[TopicViewController alloc]init];
    [self addChildVc:shopVC title:@"食话" image:@"食话" selectedImage:@"食话-hover"];
    FourthMineViewController *bookVC = [[FourthMineViewController alloc]init];
    [self addChildVc:bookVC title:@"个人中心" image:@"个人中心" selectedImage:@"个人中心-hover"];
    [self setupGuidePage];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#969696"];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#FA8C16"];
    selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //文字上移
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    PXFourthNavViewController *nav = [[PXFourthNavViewController alloc] initWithRootViewController:childVc];
    
    // 添加为子控制器
    [self addChildViewController:nav];
}

//设置引导页
-(void)setupGuidePage{
    NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [usrDefault objectForKey:BOOLFORKEY];
        if (![appVersion isEqualToString:lastVersion]) {
            
            [self setStaticGuidePage];
    
        }
    [usrDefault setObject:appVersion forKey:BOOLFORKEY];
    [usrDefault synchronize]; 
}
#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray;
    if (IS_IPHONE_Xs_Max||kIs_iPhoneX||IS_IPHONE_Xr) {
        imageNameArray = @[@"1-1",@"2-2",@"3-3"];
    }else{
        imageNameArray = @[@"1",@"2",@"3"];
    }
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    [self.view addSubview:guidePage];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    PXFourthNavViewController *nav = (PXFourthNavViewController *)viewController;
//    if([nav.viewControllers[0] isKindOfClass:[FourthMineViewController class]]){
//        UserInfoModel *model = [Utils GetUserInfo];
//        if(kStringIsEmpty(model.phone)){
//            LoginFourthViewController *vcLogin = [[LoginFourthViewController alloc] init];
//            PXFourthNavViewController *vcNavigation = [[PXFourthNavViewController alloc] initWithRootViewController:vcLogin];
//            [viewController presentViewController:vcNavigation animated:YES completion:nil];
//            return NO;
//        }else{
//            return YES;
//        }
//    }
//    
    return YES;
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
