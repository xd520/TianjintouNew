//
//  MyTransferViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-26.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyTransferViewController.h"
#import "TransferViewController.h"
#import "MoneyAccountViewController.h"
#import "LPLabel.h"
#import "MyTransferPrococalViewController.h"
#import "MyTransferSuccessViewController.h"


@interface MyTransferViewController ()
{
    float addHight;
    int count;
    UILabel *moneLab;
    UITextField *sureText;
}
@end

@implementation MyTransferViewController

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
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
    
        addHight = 0;
    }
    
    [self requestLogin:kBusinessTagGetJRgetSxf];
    
    [self reloadDataWith:_dic];
    
    
    
}


-(void)reloadDataWith:(NSDictionary *)dataArr {
    
    //产品名称
    UILabel *descPriceLabel = [[UILabel alloc] init];
    descPriceLabel.text = [dataArr objectForKey:@"xmmc"];
    //使用自定义字体
    descPriceLabel.font = [UIFont boldSystemFontOfSize:15];    //设置字体颜色
    //descPriceLabel.textColor = [ColorUtil colorWithHexString:@"1b1b1b"];
    descPriceLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    CGSize titleSize = [descPriceLabel.text sizeWithFont:descPriceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    
    descPriceLabel.frame = CGRectMake(10, addHight + 44 + 10, titleSize.width, 15);
    int descHeight = 15 + addHight + 44 + 10;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"icon_transfer"];
    // [scrollView addSubview:imgView];
    
    [self.view addSubview:descPriceLabel];
    
    
    UILabel *tiplast = [[UILabel alloc] initWithFrame:CGRectMake(10,10 + descHeight + 15,60, 14)];
    tiplast.text = @"转让价格";
    tiplast.font = [UIFont systemFontOfSize:15];
    tiplast.textColor = [ColorUtil colorWithHexString:@"999999"];
    tiplast.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:tiplast];
    
    
    
    UILabel *numYQH = [[UILabel alloc] init];
    numYQH.text = _transferStr;
    numYQH.font = [UIFont systemFontOfSize:15];
    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    numYQH.Frame = CGRectMake(75,10 + descHeight + 15, titleSize.width, 15);
    numYQH.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:numYQH];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(75 + titleSize.width, descHeight + 25, 15, 15)];
    lab.text = @"元";
    lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    lab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lab];
    
    
    
    
    NSArray *arrTitle = @[@"转让本金(元)",@"剩余可转让本金(元)",@"手续费(元)"];
    
    
    NSArray *arrNum = @[_str,[NSString stringWithFormat:@"%.2f",[[_dic objectForKey:@"kmcsl"] floatValue] - [_str floatValue]]];
    
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] init];
        UILabel *labLast = [[UILabel alloc] init];
        if (i == 0) {
            lab.frame = CGRectMake(0, descHeight + 55, 79, 13);
            labLast.frame = CGRectMake(0, descHeight + 75, 80, 14);
            labLast.font = [UIFont systemFontOfSize:14];
            labLast.text = [arrNum objectAtIndex:i];
            labLast.textAlignment = NSTextAlignmentCenter;
            labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
            [self.view addSubview:labLast];
        }else if (i == 1){
            lab.frame = CGRectMake(80, descHeight + 55, 119, 13);
            labLast.frame = CGRectMake(80, descHeight + 75, 140, 14);
            labLast.font = [UIFont systemFontOfSize:14];
            labLast.text = [arrNum objectAtIndex:i];
            labLast.textAlignment = NSTextAlignmentCenter;
            labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
            [self.view addSubview:labLast];
        } else if(i == 2) {
            lab.frame = CGRectMake(220, descHeight + 55, 100, 13);
            moneLab = [[UILabel alloc] init];
            moneLab.frame = CGRectMake(220, descHeight + 75, 100, 14);
            moneLab.font = [UIFont systemFontOfSize:14];
            moneLab.text = @"0.00";
            moneLab.textAlignment = NSTextAlignmentCenter;
            moneLab.textColor = [ColorUtil colorWithHexString:@"333333"];
            [self.view addSubview:moneLab];
        }
        
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = [arrTitle objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        [self.view addSubview:lab];
        
        
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(79, descHeight + 55, 1, 35)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:lineView1];
    
    
    UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(199 + 20, descHeight + 55, 1, 35)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:lineView];
    
    
    UIView *viewLine= [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 105, ScreenWidth, 10)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:viewLine];
    
    
    //交易密码
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(20,descHeight + 125, ScreenWidth - 120, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
    sureText.layer.cornerRadius = 4;
    sureText.layer.borderWidth = 1;
    sureText.layer.masksToBounds = YES;
    sureText.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    sureText.placeholder = @"交易密码";
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
     sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sureText.font = [UIFont systemFontOfSize:15];
    sureText.delegate = self;
    
    
    sureText.secureTextEntry = YES;
    
    [self.view addSubview:sureText];
    
    
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ScreenWidth - 90,descHeight + 125, 80, 35);
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    [sureBtn setTitle:@"支付" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(transferMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    //协议
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, descHeight + 170, 15, 15)];
    
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMehods:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(40 , descHeight + 170, 75, 15)];
    hasLab.text = @"我已经阅读";
    hasLab.font = [UIFont systemFontOfSize:15];
    hasLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [self.view addSubview:hasLab];
    
    UIButton *procoalBtn = [[UIButton alloc] init];
    procoalBtn.frame = CGRectMake(115, descHeight + 170, 115, 15);
    [procoalBtn setTitle:@"《转让协议》" forState:UIControlStateNormal];
    [procoalBtn setTitleColor:[ColorUtil colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:procoalBtn];
    
    
}

-(void)pushVCProtocal{
    
    MyTransferPrococalViewController *vc = [[MyTransferPrococalViewController alloc] init];
    vc.str = [self.dic objectForKey:@"gqdm"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:@"02" forKey:@"wtlb"];
    [paraDic setObject:self.transferStr forKey:@"wtsl"];
    [paraDic setObject:[_dic objectForKey:@"fxj"] forKey:@"wtjg"];
    [paraDic setObject:[_dic objectForKey:@"gqdm"] forKey:@"gqdm"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}



#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_jymm  tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[[Base64XD encodeBase64String:_jymm] strBase64] forKey:@"jymm"];
    [paraDic setObject:[self.dic objectForKey:@"gqdm"] forKey:@"gqdm"];
    [paraDic setObject:_str forKey:@"wtsl"];
    //转让本金
    
    [paraDic setObject:[self.dic objectForKey:@"backtime"] forKey:@"ddyxrq"];
    [paraDic setObject:_transferStr forKey:@"wtje"];
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
    
    if (tag== kBusinessTagGetJRwyzrdoTrade) {
        // NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MyTransferSuccessViewController *vc = [[MyTransferSuccessViewController alloc] initWithNibName:@"MyTransferSuccessViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if(tag == kBusinessTagGetJRgetSxf) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
            
            moneLab.text = [NSString stringWithFormat:@"%.2f",[[dataArray objectForKey:@"FID_QSFY"] floatValue]];
            
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

#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = _textView.frame;
    int offset = frame.origin.y + _textView.frame.size.height - 40  - (self.view.frame.size.height - 256.0);//键盘高度216
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    // stutas = YES;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES animated:YES];
    [UIView commitAnimations];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //    }else{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    }
    /*
     NSString *sssst;
     if ([dicFirst objectForKey:@"QDJE"] == [NSNull null]) {
     sssst = @"0";
     } else {
     sssst = [dicFirst objectForKey:@"QDJE"];
     }
     if ([sureText.text floatValue] < [sssst floatValue]) {
     [self.view makeToast:@"请输入高于起购的金额数目" duration:2 position:@"center"];
     }
     */
}





#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    //[changeView endEditing:YES];
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

- (IBAction)remberMehods:(id)sender{
    count++;
    if (count % 2 == 0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
        
    } else {
        
        [sender setBackgroundImage:[UIImage imageNamed:@"select_1"] forState:UIControlStateNormal];
    }

}


- (IBAction)transferMethods:(id)sender {
    [self.view endEditing:YES];
    
    if ([sureText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    } else if (count % 2 == 0) {
        [self.view makeToast:@"请同意转让协议" duration:1.0 position:@"center"];
        
    }else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.delegate = self;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self requestLogin:sureText.text tag:kBusinessTagGetJRwyzrdoTrade];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
    
}



@end
