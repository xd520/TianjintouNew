//
//  ForgetPWDViewController.m
//  添金投
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "AppDelegate.h"
#import "FoggterViewController.h"

@interface ForgetPWDViewController ()

@end

@implementation ForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    _nextBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _nextBtn.layer.borderWidth = 1;
    
    _nextBtn.layer.masksToBounds = YES;
    
    _nextBtn.layer.cornerRadius = 15;
    
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
     
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _phoneNum) {
        
            NSString *emailRegex = @"^1[3|4|5|8][0-9]\\d{8}$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            if (!sfzNo) {
                //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
                [self.view makeToast:@"请输入正确的手机号码" duration:1.0 position:@"center"];
                textField.text = @"";
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
    NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
    if (tag== kBusinessTagGetJRappvalidateMobilePhone) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController.view makeToast:@"该手机号码验证成功!"];
            FoggterViewController *vc = [[FoggterViewController alloc] init];
            vc.sessionId = [dataArray objectForKey:@"sessionId"];
            
            vc.phoneNumStr = _phoneNum.text;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextMethods:(id)sender {
    [self.view endEditing:YES];
    if ([_phoneNum.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入有效的手机号码" duration:1.0 position:@"center"];
    } else if ([_userName.text isEqualToString:@""]){
    
    [self.view makeToast:@"请输入曾经注册过的用户名" duration:1.0 position:@"center"];
    } else {
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
           
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setObject:_phoneNum.text forKey:@"mobilePhone"];
             [paraDic setObject:_userName.text forKey:@"username"];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRappvalidateMobilePhone owner:self];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    
    }
}
@end
