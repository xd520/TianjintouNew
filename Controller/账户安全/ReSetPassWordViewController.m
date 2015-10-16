//
//  ReSetPassWordViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ReSetPassWordViewController.h"
#import "AppDelegate.h"
#import "Child.h"

@interface ReSetPassWordViewController ()
{
    float addHight;
    UILabel *sheetLab;
     Child *child;
}
@end

@implementation ReSetPassWordViewController

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
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
      statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 84 + addHight, ScreenWidth - 10, 1)];
    view1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 124 + addHight, ScreenWidth - 10, 1)];
    view2.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 164 + addHight, ScreenWidth, 1)];
    view3.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view3];
    
    
    //按钮设置
    self.sheetCodeBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
    self.sheetCodeBtn.layer.masksToBounds = YES;
    self.sheetCodeBtn.layer.cornerRadius = 2;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetCodeBtn.frame.size.width, self.sheetCodeBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    [_sheetCodeBtn addSubview:sheetLab];
    
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];

    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passWord.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passWordAgain.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
    if (tag==kBusinessTagGetJRsavePWD) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"重置交易密码失败"];
        } else {
            
             [self.navigationController.view makeToast:@"重置交易密码成功" duration:2 position:@"center"];
            [self.navigationController popViewControllerAnimated:YES];
           
        }
    } else  if (tag== kBusinessTagGetJRwdzhsendVcode) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            //self.titleLabel.text = [NSString stringWithFormat:@"已向%@发送短信,请填写验证码",[[jsonDic objectForKey:@"object"] objectForKey:@"showPhone"]];
            // str = [[jsonDic objectForKey:@"object"] objectForKey:@"sessionId"];
            
            
            //cookieStr = [[jsonDic objectForKey:@"object"] objectForKey:@"sessionId"];
            
            child.age = 0;
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length != 6) {
       [self.view makeToast:@"请输入6位数交易密码" duration:1.0 position:@"center"];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        
        NSCharacterSet *cs;
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            return NO;
            
        
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}




#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
- (IBAction)sureMethods:(id)sender {
    [self.view endEditing:YES];
    if ([_passWord.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入密码" duration:2 position:@"center"];
    } else   if ([_passWordAgain.text isEqualToString:@""]) {
        [self.view makeToast:@"请再一次输入密码" duration:2 position:@"center"];
    }else if (_passWord.text.length != 6||_passWordAgain.text.length != 6) {
        [self.view makeToast:@"请输入6位数交易密码" duration:1.0 position:@"center"];
    } else if ([_code.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机验证码" duration:1.0 position:@"center"];
    }else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.delegate = self;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setObject:[[Base64XD encodeBase64String:_passWord.text] strBase64] forKey:@"password"];
            [paraDic setObject:[[Base64XD encodeBase64String:_passWordAgain.text] strBase64] forKey:@"password2"];
             [paraDic setObject:_code.text forKey:@"yzm"];
            
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRsavePWD owner:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }

}


//监听方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        sheetLab.text = @"获取验证码";
        _sheetCodeBtn.enabled = YES;
        _sheetCodeBtn.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        _sheetCodeBtn.enabled = NO;
        _sheetCodeBtn.backgroundColor = [UIColor grayColor];
        
    }
    
    
}


-(void)dealloc {
    
    [child removeObserver:self forKeyPath:@"age"];
    
}


- (IBAction)sheetCodeMethods:(id)sender {
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRwdzhsendVcode owner:self];
}
@end
