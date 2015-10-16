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
    nav3.tabBarItem.title = @"账户";
    
    nav3.tabBarItem.image = [[UIImage imageNamed:@"44"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    

    MoreViewController *myVC = [[MoreViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:myVC];
    nav4.delegate = self;
    nav4.tabBarItem.title = @"更多";
    
    nav4.tabBarItem.image = [[UIImage imageNamed:@"33"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        // ...
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    if (bgTask == UIBackgroundTaskInvalid) {
        NSLog(@"failed to start background task!");
    }
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do the work associated with the task, preferably in chunks.
        NSTimeInterval timeRemain = 0;
        do{
            [NSThread sleepForTimeInterval:5];
            if (bgTask!= UIBackgroundTaskInvalid) {
                timeRemain = [application backgroundTimeRemaining];
                NSLog(@"Time remaining: %f",timeRemain);
            }
        }while(bgTask!= UIBackgroundTaskInvalid && timeRemain > 0); // 如果改为timeRemain > 5*60,表示后台运行5分钟
        // done!
        // 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                // 和上面10分钟后执行的代码一样
                // ...
                // if you don't call endBackgroundTask, the OS will exit your app.
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 如果没到10分钟又打开了app,结束后台任务
    if (bgTask!=UIBackgroundTaskInvalid) {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//支持竖屏，不支持横屏

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}




@end
