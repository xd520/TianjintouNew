//
//  SuccessViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-14.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "SuccessViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MyInvestViewController.h"
#import "HideViewController.h"
//#import "MainViewController.h"


@interface SuccessViewController ()

@end

@implementation SuccessViewController

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
    _pushAccount.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
    _pushAccount.layer.cornerRadius = 4;
    _pushAccount.layer.masksToBounds = YES;
    
    _goonBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    _goonBtn.layer.cornerRadius = 4;
    _goonBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pushAccount:(id)sender {
    
    
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    UIViewController *vc = [array objectAtIndex:array.count-4];
    
    if ([vc.nibName isEqualToString:@"MessgeCenterViewController"]) {
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [self.navigationController setViewControllers:array];
        /*
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CPVSTabBarViewController *osTabbarVC = delegate.osTabVC;
        UINavigationController *navVC = [osTabbarVC viewControllers][2];
        [navVC popViewControllerAnimated:NO];
        osTabbarVC.selectedViewController = navVC;
        */
    } else if ([vc.nibName isEqualToString:@"MainViewController"]){
    
    //删除最后一个，也就是自己
    [array removeObjectAtIndex:array.count-1];
    [array removeObjectAtIndex:array.count-1];
    [array removeObjectAtIndex:array.count-1];
    //[array removeObjectAtIndex:array.count-1];
    [self.navigationController setViewControllers:array];
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
       // delegate.menuController.delegate = self;
      //  [delegate.menuController showLeftController:YES];
        
        
      //  AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        /*
        CPVSTabBarViewController *osTabbarVC = delegate.osTabVC;
        UINavigationController *navVC = [osTabbarVC viewControllers][2];
        [navVC popViewControllerAnimated:NO];
        osTabbarVC.selectedViewController = navVC;
         */
    } else if ([vc.nibName isEqualToString:@"HideViewController"]){
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
       
        [self.navigationController setViewControllers:array];
    
    }
   
    
}
- (IBAction)goOnMethods:(id)sender {
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    UIViewController *vc = [array objectAtIndex:array.count-4];
    if ([vc.nibName isEqualToString:@"MessgeCenterViewController"]) {
        
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        
        [self.navigationController setViewControllers:array];
  
    }  else if ([vc.nibName isEqualToString:@"MainViewController"]) {
        /*
        DetailViewController *vc = [[DetailViewController alloc] init];
        MyInvestViewController *vc1 = [[MyInvestViewController alloc] initWithNibName:@"MyInvestViewController" bundle:nil];
        vc1.view.tag =2;
        [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],vc,vc1]];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CPVSTabBarViewController *osTabbarVC = delegate.osTabVC;
        UINavigationController *navVC = [osTabbarVC viewControllers][2];
        [navVC popViewControllerAnimated:NO];
        osTabbarVC.selectedViewController = navVC;
       */
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        //[array removeObjectAtIndex:array.count-1];
        [self.navigationController setViewControllers:array];
    }
    
}
@end
