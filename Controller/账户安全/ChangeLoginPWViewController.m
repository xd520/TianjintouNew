//
//  ChangeLoginPWViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-7.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ChangeLoginPWViewController.h"
#import "AppDelegate.h"

@interface ChangeLoginPWViewController ()
{
    float addHight;
}
@end

@implementation ChangeLoginPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
         statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
   // _sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
   // [_sureBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 84 + addHight, ScreenWidth - 10, 1)];
    view1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 124 + addHight, ScreenWidth - 10, 1)];
    view2.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 164 + addHight, ScreenWidth - 10, 1)];
    view3.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view3];
    
    
    
    
    _oldPW.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
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



#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
    if (tag==kBusinessTagGetJRmodifyLoginPwdSubmit) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"修改登录密码失败"];
        } else {
            
            __block int timeout = 1; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout <= 0) { //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                       [self.navigationController popViewControllerAnimated:YES];
                      
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.view makeToast:@"修改登录密码成功!"];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)sureMehtods:(id)sender{
    [self.view endEditing:YES];
    if ([_oldPW.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入旧密码" duration:2 position:@"center"];
    } else if ([_password.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入密码" duration:2 position:@"center"];
    } else if ([_passwordAgain.text isEqualToString:@""]) {
        [self.view makeToast:@"请再一次输入密码" duration:2 position:@"center"];
    }else if (_password.text.length < 6&&_password.text.length > 16) {
        [self.view makeToast:@"请输入正确的密码" duration:2 position:@"center"];
        _password.text = @"";
    }else if (![_password.text isEqualToString:_passwordAgain.text]) {
        [self.view makeToast:@"请输入相同的新密码" duration:2 position:@"center"];
        _passwordAgain.text = @"";
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.delegate = self;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            
            [paraDic setObject:[[Base64XD encodeBase64String:_oldPW.text] strBase64] forKey:@"oldPwd"];
            [paraDic setObject:[[Base64XD encodeBase64String:_password.text] strBase64] forKey:@"newPwd1"];
            [paraDic setObject:[[Base64XD encodeBase64String:_passwordAgain.text] strBase64] forKey:@"newPwd2"];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRmodifyLoginPwdSubmit owner:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }

}

- (IBAction)askForMethods:(id)sender {
    [self.view makeToast:@"该功能还未实现，请到PC端操作"];
}



@end
