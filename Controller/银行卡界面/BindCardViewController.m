//
//  BindCardViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-2.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "BindCardViewController.h"
#import "AppDelegate.h"
#import "ClassBankCardViewController.h"
#import "LPLabel.h"
#import "WithdarwProtroclViewController.h"
#import "AccountViewController.h"
#import "NoBindCardViewController.h"
#import "CardBindViewController.h"
#import "PassWordMangerViewController.h"
#import "LoginViewController.h"

@interface BindCardViewController ()
{
    NSString *bankStr;
     UILabel *sheetLab;
    int count;
    NSDictionary *cityDic;
    NSDictionary *proviceDic;
    NSDictionary *bankCardDic;
}
@end

@implementation BindCardViewController

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
    bankStr = @"";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
         statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    //加间隔线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"ececec"];
    [self.chikarenView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"ececec"];
    [self.yinhangView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
    lineView2.backgroundColor = [ColorUtil colorWithHexString:@"ececec"];
    [self.yinhangkahaoView addSubview:lineView2];
    
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(10, 39, ScreenWidth - 10, 1)];
    lineView3.backgroundColor = [ColorUtil colorWithHexString:@"ececec"];
    [self.shengfenView addSubview:lineView3];
    
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    lineView4.backgroundColor = [ColorUtil colorWithHexString:@"ececec"];
    [self.diquView addSubview:lineView4];
    
    self.proviousLab.text = @"";
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
   
    //self.passID.text = [self.dic objectForKey:@"FID_ZJBH"];
    
   // _commit.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
   // _commit.layer.borderWidth = 1;
    
    _commit.layer.masksToBounds = YES;
    
    _commit.layer.cornerRadius = 4;
    _commit.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    //[_commit setBackgroundImage:[ColorUtil colorWithHexString:@"fe0873"] forState:UIControlStateNormal];
    
    _bindCardLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBankCardMethods:)];
    
    //lastView.tag = 0;
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [_bindCardLab addGestureRecognizer:singleTap1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBankCardMethods:)];
    
    //lastView.tag = 0;
    //单点触摸
    singleTap2.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap2.numberOfTapsRequired = 1;
    [self.proviousLab addGestureRecognizer:singleTap2];
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBankCardMethods:)];
    
    //lastView.tag = 0;
    //单点触摸
    singleTap3.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap3.numberOfTapsRequired = 1;
    [self.addressLab addGestureRecognizer:singleTap3];
    
    
    
    
    LPLabel *lab = [[LPLabel alloc] initWithFrame:CGRectMake(153, 360, 90, 25)];
    
    lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    lab.font = [UIFont systemFontOfSize:15.0];
    
    lab.text = @"《充值协议》";
    lab.userInteractionEnabled = YES;
    
   // UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushVCProtocal)];
    
    //单点触摸
    //singleTap2.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    //singleTap2.numberOfTapsRequired = 1;
   // [lab addGestureRecognizer:singleTap2];
    
    
    
    [self requestLogin:kBusinessTagGetJRupdateUserInfoAgain];
    
    
    
    
}

- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}




- (void)reloadCityTableView:(NSDictionary *)_code{
    self.addressLab.text = [_code objectForKey:@"FID_XZQYMC"];
    cityDic = _code;
    
}

- (void)reloadProviousTableView:(NSDictionary *)_code{
    if (![self.proviousLab.text isEqualToString:[_code objectForKey:@"FID_XZQYMC"]]) {
       self.proviousLab.text = [_code objectForKey:@"FID_XZQYMC"];
       self.addressLab.text = @"";
    }
    proviceDic = _code;
}



-(void)pushVCProtocal{
    
    WithdarwProtroclViewController *vc = [[WithdarwProtroclViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)reloadTableView:(NSDictionary *)_code{
   bankStr = [_code objectForKey:@"FID_YHDM"];
     _bindCardLab.text = [_code objectForKey:@"FID_YHMC"];
    bankCardDic = _code;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + textField.frame.size.height - 40 - (self.view.frame.size.height - 256.0);//键盘高度216

    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);

    [UIView commitAnimations];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
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
    if (tag == kBusinessTagGetJRisNeedPsw){
        
        if ([[jsonDic objectForKey:@"success"] boolValue]== YES) {
            //数据异常处理
            CardBindViewController *cv = [[CardBindViewController alloc] init];
            cv.account = _bankAccount.text;
            cv.code = bankStr;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
            
        } else {
         
            NoBindCardViewController *cv = [[NoBindCardViewController alloc] init];
            cv.account = _bankAccount.text;
            cv.code = bankStr;
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }
    }  else if (tag== kBusinessTagGetJRbindBankCardSubmit) {
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
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
            
        }else {
            //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
           // [delegate.dictionary setObject:[NSNumber numberWithBool:1] forKey:@"isBingingCard"];
            
            if ([dataArray count] == 0) {
               [self.navigationController.view makeToast:@"绑卡申请提交成功！" duration:2 position:@"center"];
            } else {
            
            [self.navigationController.view makeToast:[[dataArray objectAtIndex:0]objectForKey:@"FID_JGSM"] duration:2 position:@"center"];
            }
            
            /*
            NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            //删除最后一个，也就是自己
            UIViewController *vc = [array objectAtIndex:array.count-2];
            if ([vc.nibName isEqualToString:@"PassWordMangerViewController"]) {
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([vc.nibName isEqualToString:@"AccountInfoViewController"]){
                
                [self.navigationController popViewControllerAnimated:YES];
            } else{
              */
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
    } if (tag== kBusinessTagGetJRupdateUserInfoAgain) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.userName.text = [dataArray objectForKey:@"KHXM"];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectBankCardMethods:(UITouch *)sender{
    
    UILabel *view = (UILabel *)[sender view];
    if (view.tag == 0) {
        
    ClassBankCardViewController *vc = [[ClassBankCardViewController alloc] init];
    vc.delegate = self;
    vc.bindVC = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    }else if ( view.tag == 1) {
        ProviousViewController *vc = [[ProviousViewController alloc] init];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    } else if ( view.tag == 2) {
        
        if ([self.proviousLab.text isEqualToString:@""]) {
            [self.view makeToast:@"请先选择省份" duration:1 position:@"center"];
        } else {
        
        
        CityViewController *vc = [[CityViewController alloc] init];
        vc.strCode = [proviceDic objectForKey:@"FID_XZQYDM"];
        vc.strTitle = [proviceDic objectForKey:@"FID_XZQYMC"];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        }
    }
        
}




- (IBAction)commitBtn:(id)sender {
    if ([bankStr isEqualToString:@""]) {
        [self.view makeToast:@"请选择银行" duration:2 position:@"center"];
    } else if ([_bankAccount.text isEqualToString:@""]){
        
         NSLog(@"%ld",_bankAccount.text.length);
    [self.view makeToast:@"请输入正确的银行帐号" duration:2 position:@"center"];
    } else if (_bankAccount.text.length < 16 ||_bankAccount.text.length > 19){
        
        [self.view makeToast:@"请输入正确的银行帐号" duration:2 position:@"center"];
        
    }else if (count % 2 != 0) {
        [self.view makeToast:@"请同意个人协议" duration:1.0 position:@"center"];
        
    }else {
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        /*
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        [paraDic setObject:bankStr forKey:@"yhdm"];
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRisNeedPsw owner:self];kBusinessTagGetJRbindBankCardSubmit
        */
        
        NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
        [paraDic setObject:@"0" forKey:@"khfs"];
        [paraDic setObject:bankStr forKey:@"yhdm"];
        [paraDic setObject:[bankCardDic objectForKey:@"FID_JGDM"] forKey:@"jgdm"];
        [paraDic setObject:_bankAccount.text forKey:@"yhzh"];
        [paraDic setObject:[proviceDic objectForKey:@"FID_XZQYDM"] forKey:@"province"];
        [paraDic setObject:[cityDic objectForKey:@"FID_XZQYDM"] forKey:@"city"];
        
        [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRbindBankCardSubmit owner:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
        
    }
}

- (IBAction)back:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
}

@end
