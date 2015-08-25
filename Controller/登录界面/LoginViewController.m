//
//  LoginViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "LoginViewController.h"
#import "RegesterViewController.h"
#import "AppDelegate.h"
#import "FoggterViewController.h"
#import "Base64XD.h"



@interface LoginViewController ()
{
    float addHight;
}
@end

@implementation LoginViewController
@synthesize loginStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // UIView *baseView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    // darkGrayColor;
    //lightGrayColor;
   // baseView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    //baseView.backgroundColor = [UIColor lightGrayColor];
    // self.view = baseView;
   // [baseView addSubview:self.view];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    
    statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
       
    }
    
    _logoView.frame = CGRectMake((ScreenWidth - 180)/2, 90 + addHight, 180, 85);
    
    
    _loginBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    
    
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
   // [self.navigationController setNavigationBarHidden:YES];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 265.5 +  addHight, ScreenWidth - 10, 0.5)];
     lineView.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
   [self.view addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 305.5 +  addHight, ScreenWidth - 10, 0.5)];
     lineView1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 345.5 + addHight, ScreenWidth - 10, 0.5)];
    lineView2.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [self.view addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 366 + 9.5 + addHight, ScreenWidth, 0.5)];
    lineView3.backgroundColor = [ColorUtil  colorWithHexString:@"eeeeee"];
    //[self.view addSubview:lineView3];
    
    
//设置文本框
    _userName.clearButtonMode = UITextFieldViewModeAlways;
    _userName.text = @"";
    //设置密码
    self.password.secureTextEntry = YES;
   // self.password.keyboardType = UIKeyboardTypeNamePhonePad;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.text = @"";
    //设置图形键盘
    
    self.code.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    _code.text = @"";
    
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    _userName.autocorrectionType = UITextAutocorrectionTypeNo;
    //是否自动纠错
    
    _codeImgve.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestCategoryList)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [_codeImgve addGestureRecognizer:singleTap1];
    
    
    _codeImgve.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _codeImgve.layer.cornerRadius = 4;
    _codeImgve.layer.borderWidth = 1;
    _codeImgve.layer.masksToBounds = YES;
    
    
     [self requestCategoryList];
    
    [self readUserInfo]; 
}

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_userN withPass:(NSString *)_passwd withCode:(NSString *)_cod tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSString* openUDID = [OpenUDID value];
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_userN forKey:@"username"];
    [paraDic setObject:_passwd forKey:@"password"];
    [paraDic setObject:_cod forKey:@"captcha"];
    [paraDic setObject:openUDID forKey:@"mac"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
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
    NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
	if (tag== kBusinessTagGetJRLogin) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:[jsonDic objectForKey:@"msg"]];
            
            if ([[jsonDic objectForKey:@"msg"] isEqualToString:@"您输入的验证码有误"]) {
                [self.view makeToast:[jsonDic objectForKey:@"msg"]];
                 [self requestCategoryList];
            } else if ([[jsonDic objectForKey:@"msg"] isEqualToString:@"-109:用户名或者密码不存在"]){
                [self.view makeToast:@"用户名或密码错误"];
            
            } else if ([[jsonDic objectForKey:@"msg"] isEqualToString:@"-102:用户名或密码错误"]){
                
                [self.view makeToast:@"用户名或密码错误"];
            } else {
            
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            }
            
           
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
           //保存用户名
            [self saveData];
            
            
             [self requestLogin:kBusinessTagGetJRIndex];
            
            AppDelegate *delate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //delate.loginVC.delegate = self.delegate;
            delate.logingUser = jsonDic;
            delate.strlogin = @"2";
            
            
            //[self.delegate LoginViewVC:self loginOK:nil];
            
           

        }
    }else if (tag== kBusinessTagGetJRIndex) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            // [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"获取数据异常"];
            //            subing = NO;
        } else {
             AppDelegate *delate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delate.dictionary = dataArray;
            
            
                [self.navigationController popViewControllerAnimated:YES];
          
        

            
            
         //  [self dismissViewControllerAnimated:YES completion:nil];
            
            
            // [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark-文本框代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    // stutas = YES;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    // [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES animated:YES];
    [UIView commitAnimations];
    
}




-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //    }else{
    // [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
     self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    
    
    //    }
}




- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}



//获取验证图形
- (void)requestCategoryList
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];//创建数据请求对象
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:5];
    [request setDelegate:self];//设置代理
    [request startAsynchronous];//发送异步请求
    
    //设置网络请求完成后调用的block
    [request setCompletionBlock:^{
        
        //         NSLog(@"%@",request.responseHeaders);
        
        //NSData *data = request.responseData;
        self.codeImgve.image = [UIImage imageWithData:request.responseData];
        
        //---------------判断数据的来源:网络 or缓存------------------
        if (request.didUseCachedResponse) {
            NSLog(@"数据来自缓存");
        } else {
            NSLog(@"数据来自网络");
        }
        
    }];
    
    //请求失败调用的block
    [request setFailedBlock:^{
        
        NSError *error = request.error;
        NSLog(@"请求网络出错：%@",error);
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}




- (IBAction)push:(id)sender {
    RegesterViewController *controller = [[RegesterViewController alloc] init];
   // controller.modalTransitionStyle = UIModalTransitionStyle;
    
   // [self presentViewController:controller animated:YES completion:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)loginBtn:(id)sender {
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.code resignFirstResponder];
    
    if ([self.userName.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入用户名" duration:1.0 position:@"center"];
    } else if ([self.password.text isEqualToString:@""]){
        [self.view makeToast:@"请输入密码" duration:1.0 position:@"center"];
    }else if ([self.code.text isEqualToString:@""]){
        [self.view makeToast:@"请输入验证码" duration:1.0 position:@"center"];
    }  else {
        
        if (self.rember.selected == YES) {
            [self saveData];
            //[self.button2 setSelected:NO];
        }else {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [self removeUserInfo];
            [userDefault setBool:self.rember.selected forKey:@"isRemember"];
            [userDefault synchronize];
        }
        
        Base64XD * passwordBase64 = [Base64XD encodeBase64String:self.password.text];
        NSLog(@"%@",passwordBase64.strBase64);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLogin:self.userName.text withPass:passwordBase64.strBase64 withCode:_code.text tag:kBusinessTagGetJRLogin];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
        
    }
 
}


#pragma mark - rember passWord and username
- (IBAction)remberMetholdBtn:(id)sender {
    if (self.rember.selected == YES) {
        //设置按钮点击事件，是否保存用户信息，点击一次改变它的状态---selected,normal,同时在不同状态显示不同图片
        [self.rember setSelected:NO];
        [self.rember setImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
    }else {
        [self.rember setSelected:YES];
        [self.rember setImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateSelected];
    }

}

- (IBAction)foggoterPW:(id)sender {
    [self.view endEditing:YES];
    /*
    FoggterViewController *vc = [[FoggterViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
     */
    [self.view makeToast:@"该功能还未实现，请先到PC端操作"];
    
}

- (IBAction)quit:(id)sender {
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    //删除最后一个，也就是自己
    
    UIViewController *vc = [array objectAtIndex:array.count-2];
    if ([vc.nibName isEqualToString:@"TransferViewCtrl"]) {
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.tabBarController.selectedIndex = 0;
        //CPVSTabBarViewController *osTabbarVC = delegate.osTabVC;
        //UINavigationController *navVC = [osTabbarVC viewControllers][0];
        //[navVC popViewControllerAnimated:NO];
        // osTabbarVC.selectedViewController = navVC;
        
        
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
    
    
    // [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}


-(void)saveData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.userName.text forKey:@"name"];
    //[userDefault setObject:self.password.text forKey:@"password"];
    [userDefault setBool:self.rember.selected forKey:@"isRemember"];
    [userDefault synchronize];
    
}

-(void)readUserInfo {
    //读取用户信息，是否保存信息状态和登陆状态
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userName.text = [userDefault objectForKey:@"name"];
   // self.password.text = [userDefault objectForKey:@"password"];
    BOOL isOpen = [userDefault boolForKey:@"isRemember"];
    
    [self.rember setSelected:isOpen];              //设置与退出时相同的状态
    [self.rember setImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
    [self.rember setImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateSelected];
}

-(void)removeUserInfo {
    //当不保存用户信息时，清除记录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"name"];
   // [userDefault removeObjectForKey:@"password"];
    [userDefault removeObjectForKey:@"isRemember"];
}

-(void)dealloc {
    _code.delegate = nil;
    [_code removeFromSuperview];
    _code = nil;
    
    _userName.delegate = nil;
    [_userName removeFromSuperview];
    _userName = nil;
    
    
    _password.delegate = nil;
    [_password removeFromSuperview];
    _password = nil;
    
    [_loginBtn removeFromSuperview];
    _loginBtn = nil;
    
    [_logoView removeFromSuperview];
    _logoView = nil;
    loginStr = nil;

}



@end
