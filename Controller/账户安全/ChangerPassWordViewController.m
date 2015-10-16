//
//  ChangerPassWordViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ChangerPassWordViewController.h"
#import "AppDelegate.h"
#import "ReSetPassWordViewController.h"

@interface ChangerPassWordViewController ()
{
    float addHight;
}
@end

@implementation ChangerPassWordViewController

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
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 164 + addHight, ScreenWidth - 10, 1)];
    view3.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:view3];

    
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    _oldPW.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _passwordAgain.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _oldPW.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

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
    if (tag==kBusinessTagGetJRmodifyTranPwdSubmit) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:@"修改交易密码失败"];
        } else {
          
                //设置界面的按钮显示 根据自己需求设置
                        
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController.view makeToast:@"修改交易密码成功" duration:2 position:@"center"];
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
- (IBAction)sureMehtods:(id)sender {
   [self.view endEditing:YES];
    if ([_oldPW.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入旧密码" duration:2 position:@"center"];
    } else if ([_password.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入密码" duration:2 position:@"center"];
    } else   if ([_passwordAgain.text isEqualToString:@""]) {
        [self.view makeToast:@"请再一次输入密码" duration:2 position:@"center"];
    }else if (_oldPW.text.length != 6||_password.text.length != 6||_passwordAgain.text.length != 6) {
        [self.view makeToast:@"请输入6位数交易密码" duration:1.0 position:@"center"];
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
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRmodifyTranPwdSubmit owner:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
 
    }
}

- (IBAction)pushVC:(id)sender {
    ReSetPassWordViewController *vc = [[ReSetPassWordViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
