//
//  NameRealSuccessViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-16.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "NameRealSuccessViewController.h"
#import "AppDelegate.h"
#import "PhoneViewController.h"
#import "LoginViewController.h"
//#import "MainViewController.h"

@interface NameRealSuccessViewController ()

@end

@implementation NameRealSuccessViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quit:(id)sender {
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    
    //删除最后一个，也就是自己
    
    if (array.count == 2) {
        [array removeObjectAtIndex:array.count-1];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
       // [array removeObjectAtIndex:array.count-1];
        /*
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
         MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
       
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
        
        [menuController setRootController:mainController animated:YES];
        
        */
        
    } else {
    
    
    UIViewController *vc = [array objectAtIndex:array.count-3];
   
    if ([vc.nibName isEqualToString:@"PhoneViewController"]) {
        //LoginViewController *vc = [[LoginViewController alloc] init];
        
        //[self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],vc]];
        
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [self.navigationController setViewControllers:array];
    } else{
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        
        [self.navigationController setViewControllers:array];
    
        }
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (IBAction)bankCarBindMethods:(id)sender {
    [self.view makeToast:@"该功能还未实现，请先到PC端绑定"];
}
@end
