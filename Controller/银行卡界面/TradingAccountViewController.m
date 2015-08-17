//
//  TradingAccountViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "TradingAccountViewController.h"
#import "AppDelegate.h"
#import "BindCardViewController.h"

@interface TradingAccountViewController ()

@end

@implementation TradingAccountViewController

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
    self.bindBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
     self.bindBtn.layer.cornerRadius = 15;
     //[self.bindBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    self.readyBtn.layer.cornerRadius = 15;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
         [self requestLogin:kBusinessTagGetJRupdateUserInfoAgain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
   
    
}


-(void)reloadDataWithNoCardBank:(NSDictionary *)dicData{
    self.dic = dicData;
    if (dicData.count > 0) {
        _moneyAccount.text = [dicData objectForKey:@"FID_ZJZH"];
    } else {
        _moneyAccount.text = @"--";
    }


}


#pragma mark - Request Methods
//请求登陆
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
    
    if (tag== kBusinessTagGetJRupdateUserInfoAgain) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self reloadDataWithNoCardBank:dataArray];
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}
-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    // if (tag==kBusinessTagGetProjectDetail) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //}
    [[NetworkModule sharedNetworkModule] cancel:tag];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)bindCard:(id)sender {
    
   
    BindCardViewController *vc = [[BindCardViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dic = self.dic;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)readyMethods:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}
@end
