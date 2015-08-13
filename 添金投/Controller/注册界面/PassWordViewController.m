//
//  PassWordViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "PassWordViewController.h"
#import "AppDelegate.h"

@interface PassWordViewController ()

@end

@implementation PassWordViewController

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
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *str = [delegate.dic objectForKey:@"mobilePhone"];
    NSRange range;
    range.length = 4;
    range.location = 3;
    NSString *sr = [str stringByReplacingCharactersInRange:range withString:@"****"];
    
    self.titleLabel.text = [NSString stringWithFormat:@"手机号 %@",sr];
    
    
    self.password.secureTextEntry = YES;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    self.passWordAgain.secureTextEntry = YES;
    _passWordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
//设置文本框1
    
    self.password.backgroundColor = [UIColor whiteColor];
    
    self.password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.password.layer.borderWidth = 1;
    
    self.password.layer.masksToBounds = YES;
    
    self.password.layer.cornerRadius = 10;
 //设置文本框2
    self.passWordAgain.backgroundColor = [UIColor whiteColor];
    
    self.passWordAgain.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.passWordAgain.layer.borderWidth = 1;
    
    self.passWordAgain.layer.masksToBounds = YES;
    
    self.passWordAgain.layer.cornerRadius = 10;
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSString *emailRegex = @"^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (!sfzNo) {
        //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
        [self.view makeToast:@"请输入正确的密码格式" duration:1.0 position:@"center"];
        textField.text = @"";
    }
    
}

#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = self.password.frame;
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


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //delegate.loginVC = [[LoginViewController alloc] init];
   // delegate.loginVC.delegate = self;
    //[self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],delegate.loginVC]];
    
    //[delegate LogOutViewVC:self loginOK:nil];
    
}

- (IBAction)next:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.password.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入密码" duration:1.0 position:@"center"];
    } else if (![self.passWordAgain.text isEqualToString:self.password.text]){
        [self.view makeToast:@"请输入正确的密码" duration:1.0 position:@"center"];
        self.password.text = @"";
        self.passWordAgain.text = @"";
    } else {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.dic setObject:self.password.text forKey:@"password"];
        [delegate.dic setObject:@"" forKey:@"email"];
        
        //添加指示器及遮罩
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"注册中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            ASIFormDataRequest *requestReport  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/register/doPersonal"]]];
            NSLog(@"%@",requestReport);
            
            NSString *cookieString = [NSString stringWithFormat:@"JSESSIONID=%@",[delegate.dic objectForKey:@"sessionId"]];
            
            [requestReport addRequestHeader:@"Cookie" value:cookieString];
            
            [requestReport setPostValue:[delegate.dic objectForKey:@"username"] forKey:@"username"];
            [requestReport setPostValue:_password.text forKey:@"password"];
            // [requestReport setPostValue:[delegate.dic objectForKey:@"phoneCaptcha"] forKey:@"phoneCaptcha"];
            [requestReport setPostValue:@"" forKey:@"email"];
            [requestReport setPostValue:[delegate.dic objectForKey:@"mobilePhone"] forKey:@"mobilePhone"];
            
            //[requestReport buildPostBody];
            
            requestReport.delegate = self;
            [requestReport setTimeOutSeconds:5];
            [requestReport setDidFailSelector:@selector(urlRequestField:)];
            [requestReport setDidFinishSelector:@selector(urlRequestSueccss:)];
            
            
            [requestReport startAsynchronous];//异步传输
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
        
        __block int timeout = 2; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if (timeout <= 0) { //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.dic removeAllObjects];
                   // delegate.loginVC = [[LoginViewController alloc] init];
                   
                  //  delegate.loginVC = (LoginViewController *)self;
                    //[delegate LogOutViewVC:self loginOK:nil];
                });
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:@"注册成功" duration:2 position:@"center"];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
    }  else {
        [self.view makeToast:[dic objectForKey:@"msg"] duration:1.0 position:@"center"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}






@end
