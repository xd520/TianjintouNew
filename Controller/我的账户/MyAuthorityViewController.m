//
//  MyAuthorityViewController.m
//  添金投
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyAuthorityViewController.h"
#import "AppDelegate.h"

@interface MyAuthorityViewController ()
{
    int count;
    NSString *strNum;
}
@end

@implementation MyAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    strNum = @"";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }

    
    _commitBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    _commitBtn.layer.cornerRadius = 4;
    _commitBtn.layer.masksToBounds = YES;
    
    _commit1.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    _commit1.layer.cornerRadius = 4;
    _commit1.layer.masksToBounds = YES;

    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRforappCxTzqx owner:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}

-(void)reloadDataWith:(NSMutableDictionary *)dic{
    if ([[dic objectForKey:@"FID_JYQX"] isEqualToString:@"2"]) {
        strNum = @"2";
        _myAuthority.text = @"乙类合格投资者";
        _authority.text = @"甲类合格投资者";
        _firstView.hidden = YES;
        
    } else if ([[dic objectForKey:@"FID_JYQX"] isEqualToString:@"3"]) {
         strNum = @"3";
        _myAuthority.text = @"甲类合格投资者";
        _firstView.hidden = YES;
        _secondView.hidden = YES;
        _authority.hidden = YES;
    
    } else {
         strNum = @"";
       _authority.text = @"乙类合格投资者";
        _myAuthority.text = @"普通投资者";
        _secondView.hidden = YES;
    
    }

}



#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
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
    
    
    if (tag== kBusinessTagGetJRforappCxTzqx) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self reloadDataWith:dataArray];
        }
    } else  if (tag== kBusinessTagGetJRforwdqxtzqx) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.navigationController.view makeToast:@"申请成功!"];
            [self.navigationController popViewControllerAnimated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)remberMethods:(id)sender {
    count++;
    if (count % 2 == 0) {
        [self.rember setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
        
    } else {
        
        [self.rember setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
        
    }
  
    
}
- (IBAction)commitMethods:(id)sender {
    
    if (count % 2 == 0) {
        [self.view makeToast:@"请仔细阅读并同意接受以上承诺" duration:1.0 position:@"center"];
    } else {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        if ([strNum isEqualToString:@""]) {
            [paraDic setObject:@"2" forKey:@"FID_JYQX"];
            [paraDic setObject:@"申请乙级合格投资者权限" forKey:@"FID_ZY"];
        } else if ([strNum isEqualToString:@"2"]){
            [paraDic setObject:@"3" forKey:@"FID_JYQX"];
            [paraDic setObject:@"申请甲类合格投资者权限" forKey:@"FID_ZY"];
        }
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRforwdqxtzqx owner:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    }
}
- (IBAction)remeber1Methods:(id)sender {
    
    count++;
    if (count % 2 == 0) {
        [self.rember setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
        
    } else {
        
        [self.rember setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
        
    }
 
}


- (IBAction)commit1Methods:(id)sender {
    if (count % 2 == 0) {
        [self.view makeToast:@"请仔细阅读并同意接受以上承诺" duration:1.0 position:@"center"];
    } else {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
           
                [paraDic setObject:@"3" forKey:@"FID_JYQX"];
                [paraDic setObject:@"申请甲类合格投资者权限" forKey:@"FID_ZY"];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRforwdqxtzqx owner:self];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
}
@end
