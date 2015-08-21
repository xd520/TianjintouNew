//
//  RechargeViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-17.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "RechargeViewController.h"
#import "AppDelegate.h"
#import "WithdarwProtroclViewController.h"
#import "AccountViewController.h"
#import "MoneyAccountViewController.h"
#import "Child.h"

@interface RechargeViewController ()
{
    UILabel *sheetLab;
    float addHight;
    int count;
    Child *child;
   
    UIScrollView *scrollView;
    UITextField *changerText;
    UITextField *passWord;
    UITextField *numberCode;
    UILabel *bigLab;
}
@end

@implementation RechargeViewController

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
 
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 64)];
    scrollView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];

    [self.view addSubview:scrollView];
    
    [self getScrollViewUI];
    
    
}

-(void)getScrollViewUI {
    UIImageView *tip = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, 20)];
    tip.image = [UIImage imageNamed:@"icon_nof"];
    [scrollView addSubview:tip];
    
    UILabel *tiplab = [[UILabel alloc] initWithFrame:CGRectMake(32, 10, ScreenWidth - 42, 15)];
    tiplab.text = @"请在周一到周五9：00-16：00时间段充值";
    tiplab.font = [UIFont systemFontOfSize:13];
    tiplab.backgroundColor = [UIColor clearColor];
    tiplab.textColor = [ColorUtil colorWithHexString:@"999999"];
    [scrollView addSubview:tiplab];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 35, ScreenWidth, 50)];
    view1.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
    
    UIImageView *tipBank = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 32, 32)];
    
    UILabel *tiplabBank = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, ScreenWidth - 65, 15)];
    tiplabBank.font = [UIFont systemFontOfSize:15];
    tiplabBank.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    UILabel *tiplabBankTail = [[UILabel alloc] initWithFrame:CGRectMake(55, 50 - 23, ScreenWidth - 65, 13)];
    tiplabBankTail.font = [UIFont systemFontOfSize:13];
    tiplabBankTail.textColor = [ColorUtil colorWithHexString:@"999999"];
    
    
    [self getBankUIData:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_YHDM"] withLab:tiplabBank withImgView:tipBank withTail:tiplabBankTail];
    
    [view1 addSubview:tiplabBank];
    
    [view1 addSubview:tiplabBankTail];
    [view1 addSubview:tipBank];
    [scrollView addSubview:view1];
    
    UIView *viewFirst = [[UIView alloc] initWithFrame:CGRectMake(0, 95, ScreenWidth, 175)];
    viewFirst.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
    
    //可用余额
    UILabel *moneyLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth - 70, 15)];
    moneyLabTip.font = [UIFont systemFontOfSize:15];
    moneyLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
    moneyLabTip.text = @"可用余额";
    [viewFirst addSubview:moneyLabTip];
    
    UILabel *valueLabelTip = [[UILabel alloc] init];
    valueLabelTip.font = [UIFont boldSystemFontOfSize:15];
    [valueLabelTip setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
    valueLabelTip.textAlignment = NSTextAlignmentLeft;
    
    
    NSString *kyzi = [NSString stringWithFormat:@"%.2f",[[[self.dic objectForKey:@"zjzhResultBean"] objectForKey:@"FID_KQZJ"] doubleValue]];
    
    
    NSRange range1 = [kyzi rangeOfString:@"."];//匹配得到的下标
    
    NSLog(@"rang:%@",NSStringFromRange(range1));
    
    //string = [string substringWithRange:range];//截取范围类的字符串
    
    
    
    NSString *string = [kyzi substringFromIndex:range1.location];
    
    NSString *str = [kyzi substringToIndex:range1.location];
    
    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    valueLabelTip.frame = CGRectMake(80, 15, titleSize.width, 15);
    // WithFrame:CGRectMake(170, 44, 60, 13)
    
    [viewFirst addSubview:valueLabelTip];
    
    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 15, 15, 15)];
    flagLabel.font = [UIFont boldSystemFontOfSize:15];
    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
    flagLabel.textAlignment = NSTextAlignmentLeft;
    flagLabel.text = @"元";
    [viewFirst addSubview:flagLabel];
    
    UIView *lineTip = [[UIView alloc] initWithFrame:CGRectMake(10, 44, ScreenWidth - 10, 1)];
    lineTip.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [viewFirst addSubview:lineTip];
    
    
    
    
    //手续费
    UILabel *tipfei = [[UILabel alloc] initWithFrame:CGRectMake(10, 60 , 70, 15)];
    tipfei.font = [UIFont systemFontOfSize:15];
    tipfei.textColor = [ColorUtil colorWithHexString:@"999999"];
    tipfei.text = @"手续费";
    [viewFirst addSubview:tipfei];
    
    
    UILabel *tipfeiVule = [[UILabel alloc] init];
    tipfeiVule.font = [UIFont systemFontOfSize:15];
    tipfeiVule.textColor = [ColorUtil colorWithHexString:@"333333"];
    tipfeiVule.text = @"0.00";
    
    
    
    titleSize = [tipfeiVule.text sizeWithFont:tipfeiVule.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    tipfeiVule.frame = CGRectMake(80, 60 , titleSize.width, 15);
    // WithFrame:CGRectMake(170, 44, 60, 13)
    [viewFirst addSubview:tipfeiVule];
    
    UILabel *flagLabelVule = [[UILabel alloc] initWithFrame:CGRectMake(tipfeiVule.frame.size.width + tipfeiVule.frame.origin.x, 60, 15, 15)];
    flagLabelVule.font = [UIFont boldSystemFontOfSize:15];
    [flagLabelVule setTextColor:[ColorUtil colorWithHexString:@"999999"]];
    flagLabelVule.textAlignment = NSTextAlignmentLeft;
    flagLabelVule.text = @"元";
    [viewFirst addSubview:flagLabelVule];
    
    UIView *lineTipVule = [[UIView alloc] initWithFrame:CGRectMake(10, 89, ScreenWidth - 10, 1)];
    lineTipVule.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [viewFirst addSubview:lineTipVule];
    
    
    //充值金额
    UILabel *tiplabchanger = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 70, 15)];
    tiplabchanger.font = [UIFont systemFontOfSize:15];
    tiplabchanger.textColor = [ColorUtil colorWithHexString:@"999999"];
    tiplabchanger.text = @"充值金额";
    [viewFirst addSubview:tiplabchanger];
    
    
    
    
    //充值金额
    changerText = [[UITextField alloc] initWithFrame:CGRectMake(80,100, ScreenWidth - 100, 35)];
    changerText.backgroundColor = [UIColor whiteColor];
    changerText.layer.cornerRadius = 1;
    changerText.layer.borderWidth = 1;
    changerText.layer.masksToBounds = YES;
    changerText.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    changerText.placeholder = @"充值金额";
    changerText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    changerText.clearButtonMode = UITextFieldViewModeWhileEditing;
     changerText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    changerText.font = [UIFont systemFontOfSize:15];
    changerText.textColor = [ColorUtil colorWithHexString:@"333333"];
    changerText.delegate = self;
    [viewFirst addSubview:changerText];
    
    bigLab= [[UILabel alloc] initWithFrame:CGRectMake(80, 145, ScreenWidth - 90, 13)];
    bigLab.font = [UIFont boldSystemFontOfSize:13];
    [bigLab setTextColor:[ColorUtil colorWithHexString:@"999999"]];
    bigLab.textAlignment = NSTextAlignmentLeft;
    //bigLab.text = [self digitUppercase:changerText.text];
    bigLab.text = @"零元整";
    [viewFirst addSubview:bigLab];
    
    [scrollView addSubview:viewFirst];
    
    
    
    //交易密码
    
    UIView *viewSecond = [[UIView alloc] initWithFrame:CGRectMake(0, 95 + 185, ScreenWidth, 45)];
    viewSecond.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
    
    UILabel *tiplabPW = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 70, 15)];
    tiplabPW.font = [UIFont systemFontOfSize:15];
    tiplabPW.textColor = [ColorUtil colorWithHexString:@"999999"];
    tiplabPW.text = @"交易密码";
    [viewSecond addSubview:tiplabPW];
    
    
    passWord = [[UITextField alloc] initWithFrame:CGRectMake(80,5, ScreenWidth - 100, 35)];
    passWord.backgroundColor = [UIColor whiteColor];
    
    passWord.placeholder = @"请输入交易密码";
    passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWord.textColor = [ColorUtil colorWithHexString:@"333333"];
    passWord.font = [UIFont systemFontOfSize:15];
     passWord.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passWord.secureTextEntry = YES;
    passWord.delegate = self;
    [viewSecond addSubview:passWord];
    [scrollView addSubview:viewSecond];
    
    
    // 动态码
    
    UIView *viewthird= [[UIView alloc] initWithFrame:CGRectMake(0, 95 + 185 + 55, ScreenWidth, 45)];
    viewthird.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
    
    
    UILabel *tiplabCode = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 70, 15)];
    tiplabCode.font = [UIFont systemFontOfSize:15];
    tiplabCode.textColor = [ColorUtil colorWithHexString:@"999999"];
    tiplabCode.text = @"动态码";
    [viewthird addSubview:tiplabCode];
    
    
    numberCode = [[UITextField alloc] initWithFrame:CGRectMake(80,5, ScreenWidth - 190, 35)];
    numberCode.backgroundColor = [UIColor whiteColor];
    
     numberCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    numberCode.placeholder = @"动态码输入";
    numberCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberCode.textColor = [ColorUtil colorWithHexString:@"333333"];
    numberCode.font = [UIFont systemFontOfSize:15];
    //numberCode.secureTextEntry = YES;
    numberCode.delegate = self;
    [viewthird addSubview:numberCode];
    
    
    
    sheetLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 7.5, 90, 30)];
    sheetLab.text = @"获取验证码";
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.font = [UIFont systemFontOfSize:15];
    sheetLab.textAlignment = NSTextAlignmentCenter;
    sheetLab.textColor = [UIColor whiteColor];
    sheetLab.layer.cornerRadius = 2;
    //sheetLab.layer.borderWidth = 2;
    sheetLab.layer.masksToBounds = YES;
    sheetLab.userInteractionEnabled = YES;
    sheetLab.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
   // sheetLab.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sheetMethods:)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [sheetLab addGestureRecognizer:singleTap1];
    
    
    [viewthird addSubview:sheetLab];
    [scrollView addSubview:viewthird];
    
    
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10,385 + 70, ScreenWidth - 20, 35);
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 2;
    
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(rechargeBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:sureBtn];
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 504)];
}


-(void)getBankUIData:(NSString *)str withLab:(UILabel *)lab withImgView:(UIImageView *)img withTail:(UILabel *)tail{
    NSString *string =[[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_YHZH"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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
    
}




#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // sureText = textField;
    scrollView.contentSize = CGSizeMake(ScreenWidth,500 +216);//原始滑动距离增加键盘高度
    CGPoint pt = [textField convertPoint:CGPointMake(0, 0) toView:scrollView];//把当前的textField的坐标映射到scrollview上
    if(scrollView.contentOffset.y-pt.y+64<=0)//判断最上面不要去滚动
        [scrollView setContentOffset:CGPointMake(0, pt.y-64) animated:YES];//华东
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    
    [theTextField resignFirstResponder];
    
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    scrollView.contentSize = CGSizeMake(ScreenWidth,500);
    //动画结束
    [UIView commitAnimations];
    
    
    
    return YES;
}



- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == changerText) {
        if([self rangeString:changerText.text] > 1){
            [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
            
        } else {
            if ( [changerText.text floatValue] > 0) {
                changerText.text = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
                bigLab.text = [self changetochinese:changerText.text];
            } else {
            [self.view makeToast:@"请输入大于0的金额" duration:2.0 position:@"center"];
            
            }
            
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\n"] invertedSet];
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





-(void)pushVCProtocal{

    WithdarwProtroclViewController *vc = [[WithdarwProtroclViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];


}


#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_jymm withZhje:(NSString *)_zzje withyzm:(NSString *)_yzm tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    
    [paraDic setObject:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_ZJZH"] forKey:@"zjzh"];
    [paraDic setObject:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_BZ"] forKey:@"bz"];
    [paraDic setObject:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_YHDM"] forKey:@"yhdm"];
    [paraDic setObject:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_YHZH"] forKey:@"yhzh"];
    [paraDic setObject:_zzje forKey:@"zzje"];
    [paraDic setObject:_yzm forKey:@"yzm"];
    [paraDic setObject:_jymm forKey:@"jymm"];
    
    if ([[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_JGDM"] == nil) {
        NSLog(@"1233");
    } else {
    [paraDic setObject:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_JGDM"] forKey:@"jgdm"];
    
    }
    
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}


#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if (tag== kBusinessTagGetJRReCharger) {
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
    } else if (tag == kBusinessTagGetJRbindCardcheckResult){
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            [self.view makeToast:[dataArray objectForKey:@"msg"] duration:2 position:@"center"];
        }else {
            __block int timeout = 2; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout <= 0) { //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        /*
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        if ([delegate.strVC isEqualToString:@"1"]) {
                          
                            MoneyAccountViewController *VC = [[MoneyAccountViewController alloc]init];

                            [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],VC]];
                            
                            
                            
                        } else {
                            AccountViewController *VC = [[AccountViewController alloc]init];
                            VC.view.tag = 3;
                            [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],VC]];
                        
                        }
                      */
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    });
                    
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([jsonDic objectForKey:@"object"] == nil || [[jsonDic objectForKey:@"object"] count] == 0) {
                             [self.view makeToast:@"充值结果正在处理，请到转账充值中查询" duration:2 position:@"center"];
                        } else {
                        
                        
                       [self.view makeToast:[[[jsonDic objectForKey:@"object"] objectAtIndex:0] objectForKey:@"FID_JGSM"] duration:2 position:@"center"];
                        }
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
            
        }
    }  else if (tag == kBusinessTagGetJRApplySaveMoneySubmit) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        child.age = 0;
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
            //            subing = NO;
        } else {
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            
            [paraDic setObject:[dataArray objectForKey:@"FID_SQH"] forKey:@"sqh"];
            
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRbindCardcheckResult owner:self];
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

//添加逗号
- (NSString *)AddComma:(NSString *)string{
    
    NSString *str=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    int numl=(int)[str length];
    NSLog(@"%d",numl);
    
    if (numl>3&&numl<7) {
        return [NSString stringWithFormat:@"%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else if (numl>6){
        return [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else{
        return str;
    }
    
}


-(NSString *)changetochinese:(NSString *)numstr
{
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (numberals < 1) {
       // prefix=@"零元";
        prefix=@"";
        if (numberals == 0) {
            suffix=@"零角零分";
        }
        else if (numberals < 0.1)
        {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        }
        else
        {
            NSString *head=[valstr substringWithRange:NSMakeRange(2,1)];
            NSString *foot=[valstr substringFromIndex:3];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar objectAtIndex:[foot intValue]]];
        }
    }
    else
    {
        prefix=@"";
        suffix=@"";
        int flag=valstr.length-2;
        NSString *head=[valstr substringToIndex:flag-1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            int indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            }
            else
            {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            suffix =[suffix stringByAppendingString:@"整"];
        }
        else if ([foot hasPrefix:@"0"])
        {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        }
        else
        {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar objectAtIndex:[footch intValue]]];
        }
    }
    return [prefix stringByAppendingString:suffix];
}




//此方法只能适用于十亿以下 money 只能是整数
-(NSString *)digitUppercase:(NSString *)money
{
    NSString *str;
    //获取最后一位整数是否为零
    if ([[money substringFromIndex:money.length-1] isEqualToString:@"0"]) {
        str = @"圆整";
    } else {
    str = @"整";
    }
    
    
    NSMutableString *moneyStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
     NSArray *MyScale=@[@"分", @"角", @"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *MyBase=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    NSMutableString *M=[[NSMutableString alloc] init];
    [moneyStr deleteCharactersInRange:NSMakeRange([moneyStr rangeOfString:@"."].location, 1)];
    NSLog(@"%@",moneyStr);
    
    for(int i=(int)moneyStr.length;i>0;i--)
    {
        NSInteger MyData=[[moneyStr substringWithRange:NSMakeRange(moneyStr.length-i, 1)] integerValue];
        [M appendString:MyBase[MyData]];
        if([[moneyStr substringFromIndex:moneyStr.length-i+1] integerValue] == 0&& i != 1 && i != 2 && moneyStr.length > 2)
        {
            [M appendString:MyScale[i-1]];
            [M appendString:str];
           
            break;
            
        }
        [M appendString:MyScale[i-1]];
    }
    return M;
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
        
        sheetLab.userInteractionEnabled = YES;
        sheetLab.backgroundColor = [ColorUtil colorWithHexString:@"087dcd"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        
        sheetLab.text = [NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]];
        
        sheetLab.userInteractionEnabled = NO;
         sheetLab.backgroundColor = [UIColor grayColor];
        
    }
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
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRReCharger owner:self];
    //
}



- (IBAction)rechargeBtnMethods:(id)sender {
    if ([changerText.text isEqualToString:@""]||[changerText.text floatValue] == 0) {
        [self.view makeToast:@"请输入正确金额" duration:2.0 position:@"center"];
    }else if([changerText.text hasPrefix:@"."]){
        [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    }else if([self rangeString:changerText.text] > 1){
        [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    } else if(changerText.text.length > 9&&[self rangeString:changerText.text] == 0){
        [self.view makeToast:@"请输入十亿以下的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    }else if([self rangeString:changerText.text] == 1&& [changerText.text substringToIndex:[changerText.text rangeOfString:@"."].location].length > 9){
        
        [self.view makeToast:@"请输入十亿以下的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    } else if ([passWord.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    } else if ([numberCode.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入手机验证码密码" duration:1.0 position:@"center"];
        
    }else {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self requestLogin:passWord.text withZhje:changerText.text withyzm:numberCode.text tag:kBusinessTagGetJRApplySaveMoneySubmit];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    }
}

- (NSInteger)rangeString:(NSString *)string {
    int Num = 0;
    NSString *lastStr = @".";
    for (int i = 0; i < string.length; i++) {
        NSString *newStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([lastStr isEqualToString:newStr]) {
            Num ++;
            //lastStr = newStr;
            NSLog(@"%@",newStr);
        }
    }
    return Num;
}




@end
