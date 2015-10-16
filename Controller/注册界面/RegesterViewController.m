//
//  RegesterViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "RegesterViewController.h"
#import "CheckViewController.h"
#import "PhoneViewController.h"
#import "Child.h"
#import "UserProcrolViewController.h"
#import "Base64XD.h"

@interface RegesterViewController ()
{
    float addHight;
    int count;
    UILabel *sheetLab;
    int phoneCount;
    NSString *cookieStr;
}
@end

@implementation RegesterViewController

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
    count = 0;
    phoneCount = 0;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, ScreenWidth - 20, 0.5)];
    lineView.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.nameView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10,39.5, ScreenWidth - 20, 0.5)];
    lineView1.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.passWordView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 39.5, ScreenWidth - 20, 0.5)];
    lineView2.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, 79.5, ScreenWidth - 20, 0.5)];
    lineView3.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView3];
    
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(10, 119.5, ScreenWidth - 20, 0.5)];
    lineView4.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView4];
    
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(10, 159.5, ScreenWidth - 20, 0.5)];
    lineView5.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView5];
    
    UIView *lineView6 = [[UIView alloc] initWithFrame:CGRectMake(10, 199.5, ScreenWidth - 20, 0.5)];
    lineView6.backgroundColor = [ColorUtil  colorWithHexString:@"dedede"];
    [self.allView addSubview:lineView6];
    
    
    //按钮设置
    self.sheetBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
    //self.sheetBtn.enabled = NO;
    //self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 2;
    
    
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 4;
    
    
    //self.checkNumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    [_sheetBtn addSubview:sheetLab];
    
    
    /*
    self.userName.backgroundColor = [UIColor whiteColor];
    
    self.userName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.userName.layer.borderWidth = 1;
    
    self.userName.layer.masksToBounds = YES;
    
    self.userName.layer.cornerRadius = 10;
    */
    _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
     self.userName.text = @"";
    _password.text = @"";
    _passwordAgain.text = @"";
    _code.text = @"";
    _phoneNum.text = @"";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


//匹配是否为email地址。
- (BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userName) {
   
        
    NSString *emailRegex = @"^[a-zA-Z]\\w{5,17}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (!sfzNo) {
        
        if (textField.text.length < 6 || textField.text.length > 18) {
           [self.view makeToast:@"请输入正确的用户名" duration:1.0 position:@"center"];
        } else {
        
        [self.view makeToast:@"请输入正确的用户名" duration:1.0 position:@"center"];
        
        }
        
        
        
        //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
        //[self.view makeToast:@"请输入正确的用户名" duration:1.0 position:@"center"];
        textField.text = @"";
    } else {
    [self requestLogin:_userName.text tag:kBusinessTagGetJRValidateUsername];
    
    }
        
        _passWordView.frame = CGRectMake(_passWordView.frame.origin.x,addHight + 44 + 40, _passWordView.frame.size.width, _passWordView.frame.size.height);
        _allView.frame = CGRectMake(_allView.frame.origin.x,addHight + 44 + 80, _allView.frame.size.width, _allView.frame.size.height);
        
        
        
    } else if (textField == _password||textField == _passwordAgain) {
        
        
        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        NSString *emailRegex = @"^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if (!sfzNo) {
            //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
            [self.view makeToast:@"请输入正确的密码格式" duration:1.0 position:@"center"];
            textField.text = @"";
        }
    
    } else if(textField == _email && ![textField.text isEqualToString:@""]){
        if (![self validateEmail:_email.text]) {
          [self.view makeToast:@"请输入有效的邮箱" duration:1.0 position:@"center"];
        }
    
    }
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    _passWordView.frame = CGRectMake(_passWordView.frame.origin.x,addHight + 44 + 40, _passWordView.frame.size.width, _passWordView.frame.size.height);
    _allView.frame = CGRectMake(_allView.frame.origin.x,addHight + 44 + 80, _allView.frame.size.width, _allView.frame.size.height);
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _userName) {
        
        _passWordView.frame = CGRectMake(_passWordView.frame.origin.x,addHight + 44 + 80, _passWordView.frame.size.width, _passWordView.frame.size.height);
        
        _allView.frame = CGRectMake(_allView.frame.origin.x,addHight + 44 + 120, _allView.frame.size.width, _allView.frame.size.height);
        
        
    } else if (textField == _password) {
        
        _passWordView.frame = CGRectMake(_passWordView.frame.origin.x,addHight + 44 + 40, _passWordView.frame.size.width, _passWordView.frame.size.height);
        _allView.frame = CGRectMake(_allView.frame.origin.x,addHight + 44 + 120, _allView.frame.size.width, _allView.frame.size.height);
        
        
    }else {
        
        _passWordView.frame = CGRectMake(_passWordView.frame.origin.x,addHight + 44 + 40, _passWordView.frame.size.width, _passWordView.frame.size.height);
        _allView.frame = CGRectMake(_allView.frame.origin.x,addHight + 44 + 80, _allView.frame.size.width, _allView.frame.size.height);
        
        
    }

    
    CGRect frame = textField.frame;
    int offset;
    if (textField == _email||textField == _invitationCode||textField ==_code) {
        offset =_allView.frame.origin.y + frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
        
    } else {
     offset = frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
    
    }
    
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
}




#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_userN tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_userN forKey:@"username"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


- (void)requestPhoneNum:(NSString *)_phone tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
   // [ASIHTTPRequest setSessionCookies:nil];
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_phone forKey:@"mobilePhone"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}



#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
	if (tag== kBusinessTagGetJRValidateUsername) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2.0 position:@"center"];
             _userName.text = @"";
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            
           [self.view makeToast:@"用户名验证成功,可以使用注册。" duration:1.0 position:@"center"];
            
            
        }
    } else if (tag== kBusinessTagGetJRValidateMobilePhone) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:1.0 position:@"center"];
            _phoneNum.text = @"";
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.view makeToast:@"手机号码验证成功,可以使用注册。" duration:1.0 position:@"center"];
            
            //self.sheetBtn.backgroundColor = [UIColor lightTextColor];
           // self.sheetBtn.enabled = YES;
            
            
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setObject:_phoneNum.text forKey:@"mobilePhone"];
            
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRSendVcode owner:self];
            
            
        }
    } else if (tag== kBusinessTagGetJRSendVcode) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            //self.titleLabel.text = [NSString stringWithFormat:@"已向%@发送短信,请填写验证码",[[jsonDic objectForKey:@"object"] objectForKey:@"showPhone"]];
           // str = [[jsonDic objectForKey:@"object"] objectForKey:@"sessionId"];
            
            
            cookieStr = [[jsonDic objectForKey:@"object"] objectForKey:@"sessionId"];
            
            child.age = 0;
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];

        }
    } else if (tag== kBusinessTagGetJRregisterdoPersonal) {
        child.age = 0;
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.strlogin = @"1";
            
            
            
            PhoneViewController *vc = [[PhoneViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
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
        sheetLab.text = @"获取验证码";
        _sheetBtn.enabled = YES;
        _sheetBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        _sheetBtn.enabled = NO;
        _sheetBtn.backgroundColor = [UIColor grayColor];
        
    }
    
    
}


-(void)dealloc {
    
    [child removeObserver:self forKeyPath:@"age"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushProcoalVC:(id)sender {
    UserProcrolViewController *cv = [[UserProcrolViewController alloc] init];
    cv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cv animated:YES];
}

- (IBAction)remberMethods:(id)sender {
    count++;
    if (count % 2 == 0) {
        [self.rember setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
        
    } else {
        
        [self.rember setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)sheetMethods:(id)sender {
    //获取验证码
    if ([_phoneNum.text isEqualToString:@""]) {
        [self.view makeToast:@"请先输入手机号码" duration:1 position:@"center"];
    } else {
        
       
            NSString *emailRegex = @"^1[3|4|5|8][0-9]\\d{8}$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            bool sfzNo = [emailTest evaluateWithObject:[_phoneNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            if (!sfzNo) {
                //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
                [self.view makeToast:@"请输入正确的手机号码" duration:1.0 position:@"center"];
                _phoneNum.text = @"";
            } else {
                [self requestPhoneNum:_phoneNum.text tag:kBusinessTagGetJRValidateMobilePhone];
                
                
            }
       
     }
 }

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


- (IBAction)next:(id)sender {
    
    [self.view endEditing:YES];
    if ([self.userName.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入用户名" duration:2.0 position:@"center"];
    }else if (self.userName.text.length < 6 || self.userName.text.length > 18) {
        [self.view makeToast:@"请输入用户名" duration:2.0 position:@"center"];
    }  else if ([self.password.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入密码" duration:1.0 position:@"center"];
    } else if (![self.passwordAgain.text isEqualToString:self.password.text]){
        [self.view makeToast:@"两者密码不一致" duration:1.0 position:@"center"];
       
    } else if (count % 2 == 0) {
        [self.view makeToast:@"请阅读并同意《添金投服务协议》" duration:1.0 position:@"center"];
    } else if ([self.phoneNum.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入有效手机号码" duration:2.0 position:@"center"];
    }else if ([self.code.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机验证码" duration:2.0 position:@"center"];
    }else if (_email == nil || [_email.text isEqualToString:@""]){
    [self.view makeToast:@"邮箱不能为空" duration:2.0 position:@"center"];
    } else {
        
            if (![self validateEmail:_email.text]) {
                [self.view makeToast:@"请输入有效邮箱" duration:2.0 position:@"center"];
            } else {
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        
        Base64XD * passwordBase64 = [Base64XD encodeBase64String:self.password.text];
        
        [paraDic setObject:_userName.text forKey:@"username"];
        [paraDic setObject:passwordBase64.strBase64 forKey:@"password"];
        [paraDic setObject:_phoneNum.text forKey:@"mobilePhone"];
        [paraDic setObject:_code.text forKey:@"phoneCaptcha"];
        [paraDic setObject:_email.text forKey:@"email"];
        
        if (_invitationCode == nil || [_invitationCode.text isEqualToString:@""]) {
            [paraDic setObject:@"" forKey:@"referee"];
        } else {
            [paraDic setObject:_email.text forKey:@"referee"];
        }
        
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRregisterdoPersonal owner:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    }
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
 
 */
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
 
 
 
 
 


@end
