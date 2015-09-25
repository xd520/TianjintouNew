//
//  UnBindCardViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-27.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "UnBindCardViewController.h"
#import "AppDelegate.h"
#import "AccountViewController.h"
#import "LPLabel.h"
#import "WithdarwProtroclViewController.h"

@interface UnBindCardViewController ()
{
    UILabel *sheetLab;

}
@end

@implementation UnBindCardViewController

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
    
    _bindBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _bindBtn.layer.borderWidth = 1;
    
    _bindBtn.layer.masksToBounds = YES;
    
    _bindBtn.layer.cornerRadius = 15;
    
    [_bindBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    LPLabel *lab = [[LPLabel alloc] initWithFrame:CGRectMake(153, 360, 90, 25)];
    
    lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    lab.font = [UIFont systemFontOfSize:15.0];
    
    lab.text = @"《充值协议》";
    lab.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushVCProtocal)];
    
    //单点触摸
    singleTap2.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap2.numberOfTapsRequired = 1;
    [lab addGestureRecognizer:singleTap2];
    
    self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[self.sheetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    // _sheetBtn.titleLabel.text = @"获取验证码";
    
    self.sheetBtn.backgroundColor = [UIColor whiteColor];
    self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 4;
    
    _codeNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    [_sheetBtn addSubview:sheetLab];
    
    
}

-(void)pushVCProtocal{
    
    WithdarwProtroclViewController *vc = [[WithdarwProtroclViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_jymm withYhmm:(NSString *)_yhmm withyzm:(NSString *)_yzm tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[[Base64XD encodeBase64String:_yhmm] strBase64] forKey:@"bankCardNo"];
    [paraDic setObject:_yzm forKey:@"yzm"];
    [paraDic setObject:[[Base64XD encodeBase64String:_jymm] strBase64] forKey:@"jymm"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if (tag== kBusinessTagGetJRsendVcodeBindCard) {
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view makeToast:@"登录成功!"];
            
            [self startTime:(int)[[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue]];
        }
    } else if (tag== kBusinessTagGetJRunBindBankCardSubmit) {
        //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            AccountViewController *VC = [[AccountViewController alloc]init];
            //VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],VC]];
            
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
                sheetLab.text = @"获取验证码";
                _sheetBtn.enabled = YES;
            });
        } else {
            //            int minutes = timeout / 60;
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"%@",strTime);
                sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",strTime];
                _sheetBtn.enabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
- (IBAction)sheetMethods:(id)sender {
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:@"unbindCard" forKey:@"action"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRsendVcodeBindCard owner:self];
}
- (IBAction)remberMethods:(id)sender {
    
    
    
}
- (IBAction)biandMethods:(id)sender {
    
    if ([_codeNum.text isEqualToString:@""]){
        
        [self.view makeToast:@"请输入手机验证码" duration:2 position:@"center"];
    } else if ([_jiaoyiPW.text isEqualToString:@""]){
        
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLogin:_jiaoyiPW.text withYhmm:_cardBankStr withyzm:_codeNum.text tag:kBusinessTagGetJRunBindBankCardSubmit];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
}
@end
