//
//  AppDelegate.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/16.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "AppDelegate.h"
#import "PXFourthTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    PXFourthTabBarViewController *tabVC = [[PXFourthTabBarViewController alloc]init];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    [[UITabBar appearance] setTranslucent:NO];
    
    [self network];
    return YES;
}

- (void)network{
    // 监控网络
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                
//                [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络设置！"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [SVProgressHUD dismiss];
//                });
//                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                
//                [SVProgressHUD showSuccessWithStatus:@"手机自带网络"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    [SVProgressHUD dismiss];
//                });
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
//                [SVProgressHUD showSuccessWithStatus:@"WIFI"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [SVProgressHUD dismiss];
//                });
                
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
