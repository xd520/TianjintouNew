//
//  PassWordMangerViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "PassWordMangerViewController.h"
#import "AppDelegate.h"
#import "LoginPassWordViewController.h"
#import "ChangerPassWordViewController.h"
#import "ReSetPassWordViewController.h"
#import "ChangeLoginPWViewController.h"
#import "BindCardViewController.h"
#import "RiskEvaluationViewController.h"

@interface PassWordMangerViewController ()
{
    NSDictionary *dicData;
}
@end

@implementation PassWordMangerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestLogin:kBusinessTagGetJRIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self reloadDataWith:delegate.dictionary];
     */
   
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
  
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    
    //单点触摸
    singleTap.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap.numberOfTapsRequired = 1;
    //交易密码
    [self.resetView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    //登录密码
    [self.sureLoginView addGestureRecognizer:singleTap1];
    
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    
    //单点触摸
    singleTap2.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap2.numberOfTapsRequired = 1;
    //安全设置
    [self.loginView addGestureRecognizer:singleTap2];

   
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    
    //单点触摸
    singleTap3.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap3.numberOfTapsRequired = 1;
    //银行卡  1
    [self.changView addGestureRecognizer:singleTap3];
    
    //加边框
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 0.5)];
    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dedede"]];
    [_resetView addSubview:subView];
    
    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, ScreenWidth - 10, 0.5)];
    [subView1 setBackgroundColor:[ColorUtil colorWithHexString:@"dedede"]];
    [_resetView addSubview:subView1];
    
    
    UIView *subView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, ScreenWidth - 10, 0.5)];
    [subView2 setBackgroundColor:[ColorUtil colorWithHexString:@"dedede"]];
    [_sureLoginView addSubview:subView2];
    
    
    UIView *subView3 = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, ScreenWidth - 10, 0.5)];
    [subView3 setBackgroundColor:[ColorUtil colorWithHexString:@"dedede"]];
    [_changView addSubview:subView3];
    
    UIView *subView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth , 0.5)];
    [subView4 setBackgroundColor:[ColorUtil colorWithHexString:@"dedede"]];
    [_loginView addSubview:subView4];
    
    
}

-(void)reloadDataWith:(NSDictionary *)dic {
    
    dicData = dic;
    self.forthLab.text = @"修改|找回";
      if ([[dic objectForKey:@"isSetCert"] boolValue]) {
         
          self.firstLab.text = @"已完善";
         
         // self.loginView.userInteractionEnabled = NO;
      } else {
          
         
          self.firstLab.text = @"未完善";
          
      self.loginView.userInteractionEnabled = YES;
      }

    
    if ([[dic objectForKey:@"isBingingCard"] boolValue]) {
       
        self.secondLab.text = @"已绑定";
        self.bankCard.hidden = YES;
        self.changView.userInteractionEnabled = NO;
    } else {
    
       
        self.secondLab.text = @"未绑定";
       
        self.changView.userInteractionEnabled = YES;
    }
    
    if ([[dic objectForKey:@"isSetDealpwd"] boolValue]) {
       
        self.thirdLab.text = @"修改|找回";
    } else {
       
        self.thirdLab.text = @"未设置";
    }
    
    if ([[dic objectForKey:@"isFXCP"] boolValue]) {
            self.firstLab.text = @"已测评";
        //self.riskImgView.hidden = YES;
       // self.loginView.userInteractionEnabled = NO;
        
    } else {
       
        self.firstLab.text = @"未测评";
        //self.riskImgView.hidden = NO;
        //self.loginView.userInteractionEnabled = YES;
    }
   
}

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    //[paraDic setObject:self.strGqdm forKey:@"gqdm"];
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

    
    if (tag== kBusinessTagGetJRIndex) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self reloadDataWith:dataArray];
        }
    } else if (tag== kBusinessTagGetJRupdateUserInfo) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            BindCardViewController *vc = [[BindCardViewController alloc] init];
           // vc.dic = dataArray;
            vc.pushStr = @"1";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            }
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






- (IBAction)callPhone:(UITouch *)sender
{
    UIView *view = [sender view];
    
    
    if (view.tag == 2){
        ChangerPassWordViewController *vc = [[ChangerPassWordViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (view.tag == 0){
        
        RiskEvaluationViewController *vc = [[RiskEvaluationViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        // [self.view makeToast:@"该功能未实现，请先到PC端操作"];
    }else if (view.tag == 3){
        ChangeLoginPWViewController *vc = [[ChangeLoginPWViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        //vc.vcCtrl = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
    
    if (! [[dicData objectForKey:@"isBingingCard"] boolValue]) {
        if (view.tag == 1){
            /*
             获取银行卡界面更新信息
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            hud.delegate = self;
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中...";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [self requestLogin:kBusinessTagGetJRupdateUserInfo];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
 */
            
            if ([[dicData objectForKey:@"isSetCert"] boolValue]){
               // [self.view makeToast:@"该功能未实现，请先到PC端操作"];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                BindCardViewController *vc = [[BindCardViewController alloc] init];
                //vc.dic = delegate.dic;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] initWithNibName:@"LoginPassWordViewController" bundle:nil];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            
                }
           
            
            }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}
@end
