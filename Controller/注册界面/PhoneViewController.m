//
//  PhoneViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "PhoneViewController.h"
#import "CheckViewController.h"
#import "AppDelegate.h"
#import "LoginPassWordViewController.h"
#import "LoginViewController.h"


@interface PhoneViewController ()

@end

@implementation PhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
         statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
   // LoginViewController *vc = [[LoginViewController alloc] init];
    
    //[self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],vc]];
   // [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    //删除最后一个，也就是自己
    
    UIViewController *vc = [array objectAtIndex:array.count-2];
    if ([vc.nibName isEqualToString:@"RegesterViewController"]) {
         //LoginViewController *vc = [[LoginViewController alloc] init];
        
        //[self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],vc]];
        
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        
        [self.navigationController setViewControllers:array];
    }
    /*
     
     else {
     MainViewController *vc = [[MainViewController alloc] init];
     
     [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],vc]];
     
     }

    [array removeObjectAtIndex:array.count-1];
    [array removeObjectAtIndex:array.count-1];
    
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CPVSTabBarViewController *osTabbarVC = delegate.osTabVC;
    UINavigationController *navVC = [osTabbarVC viewControllers][2];
    [navVC popViewControllerAnimated:NO];
    osTabbarVC.selectedViewController = navVC;
    */
}



- (IBAction)next:(id)sender {
    LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
