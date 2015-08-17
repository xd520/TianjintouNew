//
//  FoggterAgainViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-3.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "FoggterAgainViewController.h"
#import "AppDelegate.h"

@interface FoggterAgainViewController ()

@end

@implementation FoggterAgainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 15;
    
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordAgain.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *emailRegex = @"^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (!sfzNo) {
        //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
        [self.view makeToast:@"请输入正确的密码格式" duration:1.0 position:@"center"];
        textField.text = @"";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureMethods:(id)sender {
   
    if ([_password.text isEqualToString:@""]) {
        [self.view makeToast:@"请先输入正确的密码" duration:2 position:@"center"];
    } else if ([_passwordAgain.text isEqualToString:@""]) {
        [self.view makeToast:@"请先输入正确的密码" duration:2 position:@"center"];
    }else if (![_password.text isEqualToString:_passwordAgain.text]) {
        [self.view makeToast:@"请先输入正确的密码" duration:2 position:@"center"];
    } else {
        //添加指示器及遮罩
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            ASIFormDataRequest *requestReport  = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVERURL, @"/app/forgetpwd/step4"]]];
            NSLog(@"%@",requestReport);
            
            NSString *cookieString = [NSString stringWithFormat:@"JSESSIONID=%@",_sessionId];
            
            [requestReport addRequestHeader:@"Cookie" value:cookieString];
            //[requestReport setRequestMethod:@"POST"];
            //[requestReport setRequestMehtod :@"POST"];
            
             [requestReport setPostValue:_password.text forKey:@"newPwd1"];
             [requestReport setPostValue:_passwordAgain.text forKey:@"newPwd2"];
            requestReport.delegate = self;
            [requestReport setTimeOutSeconds:5];
            [requestReport setDidFailSelector:@selector(urlRequestField:)];
            [requestReport setDidFinishSelector:@selector(urlRequestSueccss1:)];
            
            
            [requestReport startAsynchronous];//异步传输
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    
    if ([[dic objectForKey:@"success"] boolValue] == YES){
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
       // delegate.loginVC = [[LoginViewController alloc] init];
        //delegate.loginVC = (LoginViewController *)self;
        //[delegate LogOutViewVC:self loginOK:nil];
        
    } else {
        
        [self.view makeToast:[dic objectForKey:@"msg"] duration:2 position:@"center"];
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}





@end
