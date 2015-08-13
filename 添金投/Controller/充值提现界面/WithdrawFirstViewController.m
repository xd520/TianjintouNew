//
//  WithdrawFirstViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-18.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "WithdrawFirstViewController.h"
#import "AppDelegate.h"
#import "WithdrawViewController.h"
#import "AddWithdrawViewController.h"

@interface WithdrawFirstViewController ()

@end

@implementation WithdrawFirstViewController

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
    
    
    [self getBankUIData:[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_YHDM"]];
    //
    UILabel *valueLabelTip = [[UILabel alloc] init];
    valueLabelTip.font = [UIFont boldSystemFontOfSize:13];
    [valueLabelTip setTextColor:[UIColor redColor]];
    valueLabelTip.textAlignment = NSTextAlignmentLeft;
    //valueLabelTip.text = [[self.dic objectForKey:@"zjzhResultBean"] objectForKey:@"FID_KYZJ"];
    
    NSRange range1 = [[[self.dic objectForKey:@"zjzhResultBean"] objectForKey:@"FID_KYZJ"] rangeOfString:@"."];//匹配得到的下标
    
    NSLog(@"rang:%@",NSStringFromRange(range1));
    
    //string = [string substringWithRange:range];//截取范围类的字符串
    
    
    
    NSString *string = [[[self.dic objectForKey:@"zjzhResultBean"] objectForKey:@"FID_KYZJ"] substringFromIndex:range1.location];
    
    NSString *str = [[[self.dic objectForKey:@"zjzhResultBean"] objectForKey:@"FID_KYZJ"] substringToIndex:range1.location];
    
    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
    
    
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
    valueLabelTip.frame = CGRectMake(110, 12.5, titleSize.width, 15);
    // WithFrame:CGRectMake(170, 44, 60, 13)
    
    [self.secondView addSubview:valueLabelTip];
    
    
    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 12.5, 60, 13)];
    flagLabel.font = [UIFont boldSystemFontOfSize:15];
    [flagLabel setTextColor:[ColorUtil colorWithHexString:@"999999"]];
    flagLabel.textAlignment = NSTextAlignmentLeft;
    flagLabel.text = @"元";
    [self.secondView addSubview:flagLabel];
    
    self.inPutMoney.tag = 1000;
     _inPutMoney.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.inPutMoney.text = @"";
    
    
    
    _rechargeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _rechargeBtn.layer.borderWidth = 1;
    
    _rechargeBtn.layer.masksToBounds = YES;
    
    _rechargeBtn.layer.cornerRadius = 15;
    
    [_rechargeBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
}

-(void)getBankUIData:(NSString *)str {
    NSString *string =[[[self.dic objectForKey:@"bankInfoResult"] objectForKey:@"FID_YHZH"]  stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@"ZGYH"]) {
        self.bankName.text = @"中国银行";
        
        self.tailNum.text =  [NSString stringWithFormat:@"尾号%@",[string substringFromIndex:(int)string.length - 4]];
        self.icon.image = [UIImage imageNamed:@"icon_zgyh"];
    } else if ([str isEqualToString:@"JSYH"]){
        self.bankName.text = @"建设银行";
        self.tailNum.text =  [NSString stringWithFormat:@"尾号%@",[string substringFromIndex:(int)string.length - 4]];
        self.icon.image = [UIImage imageNamed:@"icon_jsyh"];
    }
    
}

- (NSString *)AddComma:(NSString *)string{//添加逗号
    
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

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [self.view endEditing:YES];
      //[[self.view viewWithTag:1000] resignFirstResponder];
}



#pragma mark - UITextField Delegate Methods
- (void)resignKeyboard:(id)sender
{
    [_inPutMoney resignFirstResponder];
   // [_numberCode resignFirstResponder];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
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

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
    if (tag == kBusinessTagGetJRisNeedPsw){
        
        if ([[jsonDic objectForKey:@"success"] boolValue]== YES) {
            //数据异常处理
            AddWithdrawViewController *vc = [[AddWithdrawViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.dic = self.dic;
           // vc.inputMoney = [NSString stringWithFormat:@"%.2f",[_inPutMoney.text floatValue]];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } else {
            
            WithdrawViewController *vc = [[WithdrawViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.dic = self.dic;
           // vc.inputMoney = [NSString stringWithFormat:@"%.2f",[_inPutMoney.text floatValue]];
            [self.navigationController pushViewController:vc animated:YES];
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

- (IBAction)back:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)rechargeMehtods:(id)sender {
    
    
    if ([_inPutMoney.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入金额" duration:2.0 position:@"center"];
    }else if ([_inPutMoney.text floatValue] > [[[self.dic objectForKey:@"zjzhResultBean"] objectForKey:@"FID_KYZJ"] floatValue]) {
        [self.view makeToast:@"请输入小于账户可用余额" duration:2.0 position:@"center"];
    }else if([_inPutMoney.text hasPrefix:@"."]){
        [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
        _inPutMoney.text = @"";
    }else if([self rangeString:_inPutMoney.text] > 1){
        [self.view makeToast:@"请输入正确的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    } else if(_inPutMoney.text.length > 9&&[self rangeString:_inPutMoney.text] == 0){
        [self.view makeToast:@"请输入十亿以下的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    }else if([self rangeString:_inPutMoney.text] == 1&& [_inPutMoney.text substringToIndex:[_inPutMoney.text rangeOfString:@"."].location].length > 9){
        
        [self.view makeToast:@"请输入十亿以下的金额" duration:2.0 position:@"center"];
        //_inPutMoney.text = @"";
    }else {
        
        if ([[[self.dic objectForKey:@"cgywcsResult"] objectForKey:@"FID_YHMMXY"] isEqualToString:@"2"]) {
            AddWithdrawViewController *vc = [[AddWithdrawViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.dic = self.dic;
           // vc.inputMoney = [NSString stringWithFormat:@"%.2f",[_inPutMoney.text floatValue]];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } else {
            
            WithdrawViewController *vc = [[WithdrawViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.dic = self.dic;
           // vc.inputMoney = [NSString stringWithFormat:@"%.2f",[_inPutMoney.text floatValue]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
@end
