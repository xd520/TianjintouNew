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
#import "BindCardViewController.h"

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
    
     [self requestLogin:kBusinessTagGetJRupdateUserInfoAgain];
    
}




- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]&&[[jsonDic objectForKey:@"success"] boolValue] == NO) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }else {
    
    if (tag== kBusinessTagGetJRupdateUserInfoAgain) {
        //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.logingUser.count > 0) {
                [delegate.logingUser removeAllObjects];
            }
            delegate.logingUser = jsonDic;
            }
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
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
        } else if ([vc.nibName isEqualToString:@"PassWordMangerViewController"]) {
            [array removeObjectAtIndex:array.count-1];
            [array removeObjectAtIndex:array.count-1];
            
            [self.navigationController setViewControllers:array];
            
        }else if ([vc.nibName isEqualToString:@"AccountInfoViewController"]) {
            [array removeObjectAtIndex:array.count-1];
            [array removeObjectAtIndex:array.count-1];
            
            [self.navigationController setViewControllers:array];
            
        } else {
        
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    //[self.view makeToast:@"该功能还未实现，请先到PC端绑定"];
    
    BindCardViewController *vc = [[BindCardViewController alloc] init];
   // vc.dic = delete.dic;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
