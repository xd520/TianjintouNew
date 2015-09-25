//
//  CardBindViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-22.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "CardBindViewController.h"
#import "AppDelegate.h"
#import "AccountViewController.h"
#import "Child.h"
#import "PassWordMangerViewController.h"
#import "LoginViewController.h"

@interface CardBindViewController ()
{
     UILabel *sheetLab;
    Child *child;
    
}
@end

@implementation CardBindViewController

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
    
    self.sheetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[self.sheetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    // _sheetBtn.titleLabel.text = @"获取验证码";
    
    self.sheetBtn.backgroundColor = [UIColor whiteColor];
    self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 4;
    
    
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    [_sheetBtn addSubview:sheetLab];
    
    
    _commit.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _commit.layer.borderWidth = 1;
    
    _commit.layer.masksToBounds = YES;
    
    _commit.layer.cornerRadius = 15;
    
    [_commit setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
}

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_jymm withYhmm:(NSString *)_yhmm withyzm:(NSString *)_yzm withyhzh:(NSString *)_yhzh tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    
    [paraDic setObject:_code forKey:@"yhdm"];
    [paraDic setObject:_yhzh forKey:@"yhzh"];
    [paraDic setObject:[[Base64XD encodeBase64String:_yhmm] strBase64] forKey:@"yhmm"];
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
            
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
            
            
          //  [self startTime:(int)[[[jsonDic objectForKey:@"object"] objectForKey:@"time"] integerValue]];
        }
    } else if (tag== kBusinessTagGetJRbindBankCardSubmit) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
      
      
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            //            subing = NO;
        } else {
            
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            
            [paraDic setObject:[dataArray objectForKey:@"FID_SQH"] forKey:@"sqh"];
            
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRbindCardcheckResult owner:self];
            
        }
    } else if (tag == kBusinessTagGetJRbindCardcheckResult){
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            [self.view makeToast:[dataArray objectForKey:@"mag"] duration:2 position:@"center"];
        }else {
           
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        
                        [delegate.dictionary setObject:[NSNumber numberWithBool:1] forKey:@"isBingingCard"];
            
            
            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            //删除最后一个，也就是自己
            UIViewController *vc = [array objectAtIndex:array.count-3];
            if ([vc.nibName isEqualToString:@"PassWordMangerViewController"]) {
                PassWordMangerViewController *vc = [[PassWordMangerViewController alloc]init];
                [self.navigationController popToViewController:vc animated:YES];
            } else if ([vc.nibName isEqualToString:@"AccountInfoViewController"]){
               [self.navigationController popToRootViewControllerAnimated:YES];
                
            } else{
            
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController popToViewController:vc animated:YES];
            
            }
            
            [self.navigationController.view makeToast:[dataArray objectForKey:@"msg"] duration:2 position:@"center"];
            
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

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

// 倒计时
- (void)startTime:(int)num {
    __block int timeout;
    dispatch_source_t _timer;
     timeout = num; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                sheetLab.text = @"重新发送验证码";
                _sheetBtn.enabled = YES;
            });
        } else {
            //            int minutes = timeout / 60;
            int seconds;
            if (timeout % 120 == 0) {
                seconds = 120;
            } else {
                seconds = timeout % 120;
            }
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

- (IBAction)sheetMethods:(id)sender {
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:@"bindCard" forKey:@"action"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRsendVcodeBindCard owner:self];
}

- (IBAction)commitBtn:(id)sender {
    
     if ([_passWordCard.text isEqualToString:@""]){
        
        [self.view makeToast:@"请输入银行卡密码" duration:2 position:@"center"];
    } else if ([_codeNum.text isEqualToString:@""]){
        
        [self.view makeToast:@"请输入手机验证码" duration:2 position:@"center"];
    } else if ([_jiaoyiPW.text isEqualToString:@""]){
        
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self requestLogin:_jiaoyiPW.text withYhmm:_passWordCard.text withyzm:_codeNum.text withyhzh:self.account tag:kBusinessTagGetJRbindBankCardSubmit];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
