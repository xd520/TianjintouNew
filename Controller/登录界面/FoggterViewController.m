//
//  FoggterViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "FoggterViewController.h"
#import "AppDelegate.h"
#import "FoggterAgainViewController.h"
#import "Child.h"
#import "LoginViewController.h"

@interface FoggterViewController ()
{
     UILabel *sheetLab;
    Child *child;
}
@end

@implementation FoggterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    seddionId = @"";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 15;
    
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
   
    self.sheetBtn.backgroundColor =  [ColorUtil colorWithHexString:@"087dcd"];
    self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 4;
    
    _codeText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textColor = [UIColor whiteColor];
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    [_sheetBtn addSubview:sheetLab];
    
    _phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _phoneNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
    if (tag== kBusinessTagGetJRforgetpwdsendVcode) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            child.age = 0;
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
           
        }
    } else if (tag == kBusinessTagGetJRforgetpwdresetPwd){
     child.age = 0;
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[jsonDic objectForKey:@"object"] isMemberOfClass:[NSNull class]]) {
              [self.view makeToast:@"重置密码失败"];
            } else {
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            }
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController.view makeToast:[jsonDic objectForKey:@"msg"]];
            
            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [array removeObjectAtIndex:array.count-1];
            [array removeObjectAtIndex:array.count-1];
            [self.navigationController setViewControllers:array];
            
            
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _phoneNum ||textField == _passWord) {
    
        NSString *emailRegex = @"^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if (!sfzNo) {
            //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
            [self.view makeToast:@"请输入正确的密码格式" duration:1.0 position:@"center"];
            textField.text = @"";
            }
        }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
   
    // dispatch_resume(_timer);
}
- (IBAction)sureMethods:(id)sender {
    
    if ([_passWord.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入有效密码" duration:1 position:@"center"];
    } else if (![_passWord.text isEqualToString:_phoneNum.text]){
    [self.view makeToast:@"请与上密码一致" duration:1 position:@"center"];
    _phoneNum.text = @"";
    } else if ([_codeText.text isEqualToString:@""]){
    
    [self.view makeToast:@"请输入手机验证码" duration:1 position:@"center"];
    
    } else {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       /*
        ASIFormDataRequest *requestReport  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/forgetpwd/resetPwd"]]];
        NSLog(@"%@",requestReport);
        
        NSString *cookieString = [NSString stringWithFormat:@"JSESSIONID=%@",_sessionId];
        
        [requestReport addRequestHeader:@"Cookie" value:cookieString];
        
        [requestReport setPostValue:[[Base64XD encodeBase64String:_passWord.text] strBase64] forKey:@"newPwd1"];
        [requestReport setPostValue:[[Base64XD encodeBase64String:_phoneNum.text] strBase64] forKey:@"newPwd2"];
        [requestReport setPostValue:_codeText.text forKey:@"yzm"];
        
        requestReport.delegate = self;
        [requestReport setTimeOutSeconds:5];
        [requestReport setDidFailSelector:@selector(urlRequestField:)];
        [requestReport setDidFinishSelector:@selector(urlRequestSueccss:)];
        
        
        [requestReport startAsynchronous];
        */
        
        
        
       
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        [paraDic setObject:[[Base64XD encodeBase64String:_passWord.text] strBase64] forKey:@"newPwd1"];
        [paraDic setObject:[[Base64XD encodeBase64String:_phoneNum.text] strBase64] forKey:@"newPwd2"];
        [paraDic setObject:_codeText.text forKey:@"yzm"];
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRforgetpwdresetPwd owner:self];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    }
}

- (IBAction)sheetMehtods:(id)sender {
   
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"短信发送中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        [paraDic setObject:_phoneNumStr forKey:@"mobilePhone"];
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRforgetpwdsendVcode owner:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}


-(void) urlRequestField:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view makeToast:[NSString stringWithFormat:@"%@",error]];
}


-(void) urlRequestSueccss1:(ASIHTTPRequest *)request {
    NSData *data =[request responseData];
    //NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    // NSLog(@"%@",parser);
    NSLog(@"xml data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *strss = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [strss JSONValue];
    child.age = 0;
    
     if ([[dic objectForKey:@"success"] boolValue] == YES){
    
         
         FoggterAgainViewController *cv = [[FoggterAgainViewController alloc] init];
         cv.hidesBottomBarWhenPushed = YES;
         cv.phoneNum = _phoneNum.text;
         cv.code = _codeText.text;
         cv.sessionId = seddionId;
         [self.navigationController pushViewController:cv animated:YES];
         _phoneNum.text = @"";
         _codeText.text = @"";
         seddionId = @"";
         
     } else {
     
      [self.view makeToast:[dic objectForKey:@"msg"] duration:2 position:@"center"];
     
     }
     [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        
        [self.view makeToast:@"获取短信验证码成功" duration:2 position:@"center"];
        //注册观察者
        child = [[Child alloc] init];
        child.age = [[[dic objectForKey:@"object"] objectForKey:@"time"] integerValue];
        [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
         //[self startTime:(int)[[[dic objectForKey:@"object"] objectForKey:@"time"] integerValue]];
        
    }  else {
        
        if ([[dic objectForKey:@"loginOut"] isEqualToString:@""]) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
           // delegate.loginVC = [[LoginViewController alloc] init];
           // delegate.loginVC = (LoginViewController *)self;
           // [delegate LogOutViewVC:self loginOK:nil];
        } else {
            [self.view makeToast:@"密码找回失败" duration:2 position:@"center"];
        
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}


//监听方法

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"%@",change);
    
    if ([[change objectForKey:@"new"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
        
        sheetLab.text = @"重新获取验证码";
        
        _sheetBtn.enabled = YES;
        _sheetBtn.backgroundColor = [UIColor lightTextColor];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        
        _sheetBtn.enabled = NO;
         _sheetBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
        
    }
}




@end
