//
//  AppDelegate.m
//  添金投
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewCtrl.h"
#import "ProductViewCtrl.h"
#import "TransferViewCtrl.h"
#import "MoreViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.dic = [[NSMutableDictionary alloc] init];
    self.logingUser = [[NSMutableDictionary alloc] init];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    [self initTabBarControllerUI];
    
    [_window makeKeyAndVisible];
    
    
    return YES;
}

-(void)initTabBarControllerUI{
    _tabBarController = [[UITabBarController alloc] init];
    
    FirstViewCtrl *fisrtVC = [[FirstViewCtrl alloc] init];
     UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fisrtVC];
    nav1.delegate = self;
    nav1.tabBarItem.title = @"首页";
   
   nav1.tabBarItem.image = [[UIImage imageNamed:@"11"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
  
    ProductViewCtrl *proVC = [[ProductViewCtrl alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:proVC];
    nav2.delegate = self;
    nav2.tabBarItem.title = @"产品";
    
    nav2.tabBarItem.image = [[UIImage imageNamed:@"22"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    TransferViewCtrl *tranferVC = [[TransferViewCtrl alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:tranferVC];
    nav3.delegate = self;
    nav3.tabBarItem.title = @"转让";
    
    nav3.tabBarItem.image = [[UIImage imageNamed:@"33"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    

    MoreViewController *myVC = [[MoreViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:myVC];
    nav4.delegate = self;
    nav4.tabBarItem.title = @"我";
    
    nav4.tabBarItem.image = [[UIImage imageNamed:@"44"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
     _tabBarController.viewControllers =[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4, nil];
    [_tabBarController.tabBar setTintColor:[ColorUtil colorWithHexString:@"fe8103"]];
    
    
    self.window.rootViewController = _tabBarController;
}


#pragma mark - UINavigationController Delegate Methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBarHidden = YES;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
