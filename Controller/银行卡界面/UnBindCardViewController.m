//
//  UnBindCardViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-27.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "UnBindCardViewController.h"
#import "AppDelegate.h"
#import "LPLabel.h"
#import "WithdarwProtroclViewController.h"
#import "Child.h"

@interface UnBindCardViewController ()
{
    UILabel *sheetLab;
     Child *child;

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
    
    
    self.sheetBtn.layer.borderWidth = 1;
    
    self.sheetBtn.layer.masksToBounds = YES;
    
    self.sheetBtn.layer.cornerRadius = 4;
    
    _codeNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sheetBtn.frame.size.width, self.sheetBtn.frame.size.height)];
    sheetLab.text = @"获取验证码";
    sheetLab.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textColor = [UIColor whiteColor];
    [_sheetBtn addSubview:sheetLab];
    
    self.bankName.textColor = [ColorUtil colorWithHexString:@"333333"];
    self.bankAccount.textColor = [ColorUtil colorWithHexString:@"666666"];
    
    [self getBankUIData:self.bankcodeStr withLab:self.bankName withImgView:self.bank withTail:self.bankAccount];
    
}


-(void)getBankUIData:(NSString *)str withLab:(UILabel *)lab withImgView:(UIImageView *)img withTail:(UILabel *)tail{
    NSString *string =[self.bankAccountStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSRange range;
    NSString *strZJBH;
    
    range.length = [string length] - 9;
    range.location = 5;
    strZJBH  = [string stringByReplacingCharactersInRange:range withString:@"******"];
    
    
    if ([str isEqualToString:@"ZGYH"]) {
        lab.text = @"中国银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_zgyh"];
    } else if ([str isEqualToString:@"JSYH"]){
        lab.text = @"建设银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_jsyh"];
    }else if ([str isEqualToString:@"JGJS"]){
        lab.text = @"建设银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_jsyh"];
    } else if ([str isEqualToString:@"NYYH"]) {
        lab.text = @"农业银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"com_nyyh"];
        
    } else if ([str isEqualToString:@"JGNY"]) {
        lab.text = @"农业银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"com_nyyh"];
        
    }else if ([str isEqualToString:@"GSYH"]) {
        lab.text = @"工商银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_gsyh"];
        
    } else if ([str isEqualToString:@"JGGS"]) {
        lab.text = @"工商银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_gsyh"];
        
    }else if ([str isEqualToString:@"ZSYH"]) {
        lab.text = @"招商银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_yh"];
        
    }else if ([str isEqualToString:@"JGZS"]) {
        lab.text = @"招商银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_yh"];
        
    }else if ([str isEqualToString:@"GDYH"]) {
        lab.text = @"光大银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_gdyh"];
        
    }else if ([str isEqualToString:@"JGGD"]) {
        lab.text = @"光大银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_gdyh"];
        
    }else if ([str isEqualToString:@"GFYH"]) {
        lab.text = @"广发银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_gfyh"];
        
    }else if ([str isEqualToString:@"XYYH"]) {
        lab.text = @"兴业银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_xyyh"];
        
    } else if ([str isEqualToString:@"ZXYH"]) {
        lab.text = @"中信银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_zxyh"];
        
    } else if ([str isEqualToString:@"JTYH"]) {
        lab.text = @"交通银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_jtyh"];
        
    } else if ([str isEqualToString:@"PAYH"]) {
        lab.text = @"平安银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_payh"];
        
    } else if ([str isEqualToString:@"PFYH"]) {
        lab.text = @"浦发银行";
        tail.text = strZJBH;
        img.image = [UIImage imageNamed:@"icon_pfyh"];
        
    }
    
    
}


/*
 if ([str isEqualToString:@"ZGYH"]) {
 lab.text = @"中国银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_zgyh"];
 } else if ([str isEqualToString:@"JSYH"]){
 lab.text = @"建设银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_jsyh"];
 } else if ([str isEqualToString:@"NYYH"]) {
 lab.text = @"农业银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_nyyh"];
 
 } else if ([str isEqualToString:@"GSYH"]) {
 lab.text = @"工商银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_gsyh"];
 
 }else if ([str isEqualToString:@"ZSYH"]) {
 lab.text = @"招商银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_yh"];
 
 }else if ([str isEqualToString:@"GDYH"]) {
 lab.text = @"光大银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_gdyh"];
 
 }else if ([str isEqualToString:@"GFYH"]) {
 lab.text = @"广发银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_gfyh"];
 
 }else if ([str isEqualToString:@"XYYH"]) {
 lab.text = @"兴业银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_xyyh"];
 
 } else if ([str isEqualToString:@"ZXYH"]) {
 lab.text = @"中信银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_zxyh"];
 
 } else if ([str isEqualToString:@"JTYH"]) {
 lab.text = @"交通银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_jtyh"];
 
 } else if ([str isEqualToString:@"PAYH"]) {
 lab.text = @"平安银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_payh"];
 
 } else if ([str isEqualToString:@"PFYH"]) {
 lab.text = @"浦发银行";
 tail.text = strZJBH;
 img.image = [UIImage imageNamed:@"icon_pfyh"];
 
 }

 */


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
    //[paraDic setObject:[[Base64XD encodeBase64String:_yhmm] strBase64] forKey:@"bankCardNo"];
    [paraDic setObject:_yhmm forKey:@"bankCardNo"];
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
    
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]&&[[jsonDic objectForKey:@"success"] boolValue] == NO) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }else {

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
            
        }
    } else if (tag== kBusinessTagGetJRunBindBankCardSubmit) {
        //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
         child.age = 0;
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.dictionary setObject:[NSNumber numberWithBool:0] forKey:@"isBingingCard"];

            //[self.navigationController.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            [self.navigationController.view makeToast:@"解绑成功！" duration:2 position:@"center"];
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
    _sheetBtn.enabled = YES;
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
    
    NSLog(@"%@",change);
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        
        sheetLab.text = @"获取验证码";
        _sheetBtn.enabled = YES;
       // sheetLab.userInteractionEnabled = YES;
        sheetLab.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        
         _sheetBtn.enabled = NO;
        sheetLab.backgroundColor = [UIColor grayColor];
        
    }
}

-(void)dealloc {
    
    [child removeObserver:self forKeyPath:@"age"];
    
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
    
    _sheetBtn.enabled = NO;
    
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
