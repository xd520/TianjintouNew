//
//  CheckViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "CheckViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PassWordViewController.h"
#import "Child.h"


@interface CheckViewController ()
{
    NSString *str;
     UILabel *sheetLab;
}
@end

@implementation CheckViewController

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
    
    str = @"";
 //输入框设置
    self.checkNumText.backgroundColor = [UIColor whiteColor];
    
    self.checkNumText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.checkNumText.layer.borderWidth = 1;
    
    self.checkNumText.layer.masksToBounds = YES;
    
    self.checkNumText.layer.cornerRadius = 10;
    self.checkNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _checkNumText.keyboardType = UIKeyboardTypeNumberPad;
 //按钮设置
    self.checkNumBtn.backgroundColor = [UIColor lightGrayColor];
    
    self.checkNumBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.checkNumBtn.layer.borderWidth = 1;
    
    self.checkNumBtn.layer.masksToBounds = YES;
    
    self.checkNumBtn.layer.cornerRadius = 20;
    
    //self.checkNumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.checkNumBtn.frame.size.width, self.checkNumBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    [_checkNumBtn addSubview:sheetLab];
    
    
//发送验证码
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //获取验证码
    [self requestLogin:[delegate.dic objectForKey:@"mobilePhone"] tag:kBusinessTagGetJRSendVcode];
    
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_userName tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_userName forKey:@"mobilePhone"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
	if (tag== kBusinessTagGetJRSendVcode) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
           
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            self.titleLabel.text = [NSString stringWithFormat:@"已向%@发送短信,请填写验证码",[[jsonDic objectForKey:@"object"] objectForKey:@"showPhone"]];
            str = [[jsonDic objectForKey:@"object"] objectForKey:@"sessionId"];
            
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
            
            
            
            
           // [self startTime:(int)[[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue]];
        }
    } else if (tag == kBusinessTagGetJRCheckVcode){
        child.age = 0;
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           [self.navigationController pushViewController:[[PassWordViewController alloc] init] animated:YES];
            
        }
    }
    
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

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



//监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        
        sheetLab.text = @"重新获取验证码";
        
        _checkNumBtn.enabled = YES;
        _checkNumBtn.backgroundColor = [UIColor lightTextColor];
       [child removeObserver:self forKeyPath:@"age"]; 
    } else {
        
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        
        _checkNumBtn.enabled = NO;
         _checkNumBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
        
    }

    
}




// 倒计时
- (void)startTime:(int)num {
    
    __block int timeout = num; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                sheetLab.text = @"重新发送验证码";
                _checkNumBtn.enabled = YES;
            });
        } else {
            //            int minutes = timeout / 60;
            NSString *strTime;
            if (timeout/120 == 1) {
                strTime = [NSString stringWithFormat:@"%.2d", timeout];
            }else {
                int seconds = timeout % 120;
                strTime = [NSString stringWithFormat:@"%.2d", seconds];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"%@",strTime);
                sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",strTime];
                _checkNumBtn.enabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//移除观察者
-(void)dealloc {
    
    [child removeObserver:self forKeyPath:@"age"];
}

- (IBAction)back:(id)sender {
   
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
   // delegate.loginVC = [[LoginViewController alloc] init];
   // delegate.loginVC.delegate = self;
    if (delegate.dic.count > 0) {
        [delegate.dic removeAllObjects];
    }

    //[self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],delegate.loginVC]];
    
    //[delegate LogOutViewVC:self loginOK:nil];
   
    
   // [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    if ([self.checkNumText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入短信数字码" duration:1.0 position:@"center"];
    } else {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[delegate.dic setObject:_code.text forKey:@"phoneCaptcha"];
        [delegate.dic setObject:str forKey:@"sessionId"];
        //验证验证码
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        [paraDic setObject:_checkNumText.text forKey:@"phoneCaptcha"];
        
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRCheckVcode owner:self];
        
    }
    
}
/*
- (IBAction)next:(id)sender {
    
    [self.view endEditing:YES];
    if ([self.userName.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入用户名" duration:2.0 position:@"center"];
    }  else if ([self.password.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入密码" duration:1.0 position:@"center"];
    } else if (![self.passwordAgain.text isEqualToString:self.password.text]){
        [self.view makeToast:@"两者密码不一致" duration:1.0 position:@"center"];
        
    }else if (count % 2 != 0) {
        
        [self.view makeToast:@"请同意个人协议" duration:1.0 position:@"center"];
        
        
    } else if ([self.phoneNum.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入有效手机号码" duration:2.0 position:@"center"];
    }else if ([self.code.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机验证码" duration:2.0 position:@"center"];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //[ASIHTTPRequest setSessionCookies:nil];
            ASIFormDataRequest *requestReport  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/doPersonal"]]];
            NSLog(@"%@",requestReport);
            
            NSString *cookieString = [NSString stringWithFormat:@"JSESSIONID=%@",cookieStr];
            
            [requestReport addRequestHeader:@"Cookie" value:cookieString];
            
            [requestReport setPostValue:_userName.text forKey:@"username"];
            [requestReport setPostValue:_password.text forKey:@"password"];
            [requestReport setPostValue:_phoneNum.text forKey:@"mobilePhone"];
            [requestReport setPostValue:_code.text forKey:@"phoneCaptcha"];
            
            
            
            requestReport.delegate = self;
            [requestReport setTimeOutSeconds:5];
            [requestReport setDidFailSelector:@selector(urlRequestField:)];
            [requestReport setDidFinishSelector:@selector(urlRequestSueccss:)];
            
            
            [requestReport startAsynchronous];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
}
 
 
 -(void) urlRequestField:(ASIHTTPRequest *)request {
 NSError *error = [request error];
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 [self.view makeToast:[NSString stringWithFormat:@"%@",error]];
 }
 
 -(void) urlRequestSueccss:(ASIHTTPRequest *)request {
 NSData *data =[request responseData];
 //NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
 // NSLog(@"%@",parser);
 NSLog(@"xml data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
 //[parser setDelegate:self];
 //[parser parse];
 
 NSString *strss = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSMutableDictionary *dic = [strss JSONValue];
 if ([[dic objectForKey:@"success"] boolValue] == YES){
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 PhoneViewController *vc = [[PhoneViewController alloc] init];
 vc.hidesBottomBarWhenPushed = YES;
 [self.navigationController pushViewController:vc animated:YES];
 
 
 
 }  else {
 [self.view makeToast:[dic objectForKey:@"msg"] duration:1.0 position:@"center"];
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 }
 
 }
 

 
 
*/

- (IBAction)checkNumMethods:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //获取验证码
    [self requestLogin:[delegate.dic objectForKey:@"mobilePhone"] tag:kBusinessTagGetJRSendVcode];
}
@end
