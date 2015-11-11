//
//  YuYueViewController.m
//  添金投
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "YuYueViewController.h"
#import "AppDelegate.h"
#import "YuSuccessViewController.h"
#import "YuMoneyViewController.h"

@interface YuYueViewController ()
{
    float addHight;
    UILabel *moneLab;
    UITextField *sureText;
    int count;
    
    UIDatePicker *datePicker;
    UIToolbar *tooBar;
    UILabel *dateLStarabel;
    UILabel * dateEndabel;
    NSDictionary *moneyDic;
   
    
}
@end

@implementation YuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
        
    }
    
   // [self requestLogin:kBusinessTagGetJRgetSxf];
    
    [self reloadDataWith:_dic];
    
    [self reloadView];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = YES;
     [self.view addSubview:datePicker];
    
    
    tooBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200 - 30, ScreenWidth, 40)];
    //tooBar.backgroundColor = [UIColor redColor];
    [tooBar setBackgroundImage:[UIImage imageNamed:@"title_bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
    [okBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(upDateView:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.tag = 1;
    [tooBar addSubview:okBtn];
    
    UILabel *starLb= [[UILabel alloc] initWithFrame:CGRectMake(110,0, 100, 40)];
    starLb.font = [UIFont boldSystemFontOfSize:14];
    starLb.textAlignment = NSTextAlignmentCenter;
    starLb.text = @"预计认购日期";
    [tooBar addSubview:starLb];
    
    
    tooBar.hidden = YES;
    [self.view addSubview:tooBar];
    
    
}

-(void)reloadView {
    
    float addh = 64 + 15 + 75 + 40 + 15;
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(10, addh, ScreenWidth - 20, 30)];
    startView.backgroundColor = [UIColor whiteColor];
    startView.layer.borderWidth = 1;
    startView.layer.borderColor = [[ColorUtil colorWithHexString:@"dedede"] CGColor];
    startView.layer.cornerRadius = 3;
    startView.layer.masksToBounds = YES;
    startView.tag = 1;
    
    //起始日期
    
    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake( 5, 8,100 , 13)];
    endLabTip.text = @"预计认购日期";
    endLabTip.font = [UIFont systemFontOfSize:13];
    endLabTip.backgroundColor = [UIColor clearColor];
    endLabTip.textColor = [ColorUtil colorWithHexString:@"999999"];
    [startView addSubview:endLabTip];

    
    
    
    dateLStarabel = [[UILabel alloc] initWithFrame:CGRectMake( 110, 0, ScreenWidth - 140 -30, 30)];
    dateLStarabel.backgroundColor = [UIColor whiteColor];
    dateLStarabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    dateLStarabel.lineBreakMode = NSLineBreakByTruncatingTail;
    dateLStarabel.font = [UIFont systemFontOfSize:13];
    // dateLStarabel.textAlignment = NSTextAlignmentCenter;
    
    
    dateLStarabel.text = [self dateToStringDate: [self dateFromString:[_dic objectForKey:@"YSJZRQ"]]];
    dateLStarabel.userInteractionEnabled = YES;
    [startView addSubview:dateLStarabel];
    
    UIImageView *tip = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 25, 5, 20, 20)];
    tip.image = [UIImage imageNamed:@"history"];
    
    [startView addSubview:tip];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    [startView addGestureRecognizer:singleTap];
    
    [self.view addSubview:startView];
    
    
    
    
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(10, addh + 40, ScreenWidth - 20, 30)];
    endView.backgroundColor = [UIColor whiteColor];
    endView.layer.borderWidth = 1;
    endView.layer.borderColor = [[ColorUtil colorWithHexString:@"dedede"] CGColor];
    endView.layer.cornerRadius = 3;
    endView.layer.masksToBounds = YES;
    endView.tag = 2;
 
    
    UILabel *endTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 8,110 , 13)];
    endTip.text = @"选择预约认购金额";
    endTip.font = [UIFont systemFontOfSize:13];
    endTip.backgroundColor = [UIColor clearColor];
    endTip.textColor = [ColorUtil colorWithHexString:@"999999"];
    [endView addSubview:endTip];
    
    
    
    
    dateEndabel = [[UILabel alloc] initWithFrame:CGRectMake(110,0, ScreenWidth - 20 - 110, 30)];
    dateEndabel.backgroundColor = [UIColor whiteColor];
    dateEndabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    dateEndabel.lineBreakMode = NSLineBreakByTruncatingTail;
    dateEndabel.font = [UIFont systemFontOfSize:13];
    //dateEndabel.userInteractionEnabled = YES;
    [endView addSubview:dateEndabel];
    
    UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 25, 5, 20, 20)];
    tipImg.image = [UIImage imageNamed:@"next_icon"];
    
    [endView addSubview:tipImg];
    
    
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    [endView addGestureRecognizer:singleTap1];
    
    [self.view addSubview:endView];
    
    
}


- (void)callPhone:(UIGestureRecognizer *)sender
{
    UIView *view = [sender view];
    if (view.tag == 1) {
        tooBar.hidden = NO;
        datePicker.hidden = NO;
        datePicker.date = [self dateFromString:dateLStarabel.text];
    } else {
        YuMoneyViewController *vc = [[YuMoneyViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)reloadMoneyView:(NSDictionary *)_code{
    dateEndabel.text = [_code objectForKey:@"NOTE"];
    moneyDic = _code;
}



-(void) upDateView:(UIButton *)btn{
    
    [self countDay];
    
}


- (void)alterMessage:(NSString *)messageString{
    
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [al show];
}


- (void)countDay {
    
    NSDate *nowDate = datePicker.date;
    NSDate *beginDate = [self dateFromString:[_dic objectForKey:@"YSJZRQ"]];
    NSDate *endDate = [self dateFromString:[_dic objectForKey:@"MJJSRQ"]];
    NSDate *earlyDate = [beginDate earlierDate:endDate];
   NSDate *laterDate =[endDate laterDate:nowDate];
    
    
    if ([earlyDate isEqualToDate:endDate] && ![earlyDate isEqualToDate:beginDate]) {
        if (![nowDate isEqualToDate:beginDate]) {
            [self alterMessage:@"日期不得早于预约截止日期"];
            return;
        } else {
            tooBar.hidden = YES;
            datePicker.hidden = YES;
            dateLStarabel.text = [self dateToStringDate:datePicker.date];
        
        }
    
        
    } else if (![nowDate isEqualToDate:laterDate]&&[endDate isEqualToDate:laterDate]) {
        
        if (![nowDate isEqualToDate:endDate]) {
            [self alterMessage:@"时间不得晚于结束日期"];
            return;
        } else {
            tooBar.hidden = YES;
            datePicker.hidden = YES;
            dateLStarabel.text = [self dateToStringDate:datePicker.date];
            
        }
        
    } else {
        tooBar.hidden = YES;
        datePicker.hidden = YES;
        dateLStarabel.text = [self dateToStringDate:datePicker.date];
    
    }
    
 }


#pragma mark - date change Metholds

- (NSString *)dateToStringDate:(NSDate *)Date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //HH:mm:ss zzz
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    // destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[formatter dateFromString:dateString];
    
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date1 timeIntervalSinceReferenceDate] + 8*3600)];
    return newDate;
}



-(void)reloadDataWith:(NSDictionary *)dataArr {
    
    //产品名称
    UILabel *descPriceLabel = [[UILabel alloc] init];
    descPriceLabel.text = [dataArr objectForKey:@"CPMC"];
    //使用自定义字体
    descPriceLabel.font = [UIFont systemFontOfSize:15];    //设置字体颜色
    //descPriceLabel.textColor = [ColorUtil colorWithHexString:@"1b1b1b"];
    descPriceLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    CGSize titleSize = [descPriceLabel.text sizeWithFont:descPriceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    
    descPriceLabel.frame = CGRectMake(10,44 + addHight + 15, titleSize.width, 15);
    int descHeight = 44 + addHight + 15;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"icon_transfer"];
    // [scrollView addSubview:imgView];
    
    [self.view addSubview:descPriceLabel];
    
    
    UILabel *numYQH = [[UILabel alloc] init];
    numYQH.text = [dataArr  objectForKey:@"SYL"];
    numYQH.font = [UIFont systemFontOfSize:30];
    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    numYQH.frame = CGRectMake(10,10 + descHeight + 15 + 2.5, titleSize.width, 30);
    
    [self.view addSubview:numYQH];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10  + titleSize.width, descHeight + 25 + 17 + 2.5, 15, 13)];
    lab.text = @"%";
    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    lab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lab];
    
    
    
    
    NSArray *arrTitle = @[@"剩余期限",@"收益方式",@"手续费"];
    
    
    NSArray *arrNum = @[[NSString stringWithFormat:@"%@天",[dataArr objectForKey:@"QX"]],[dataArr objectForKey:@"FXMS"]];
    
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] init];
        UILabel *labLast = [[UILabel alloc] init];
        if (i == 0) {
            lab.frame = CGRectMake(10, descHeight + 75, ScreenWidth/4 - 20, 13);
            labLast.frame = CGRectMake(10, descHeight + 95, ScreenWidth/4 - 20, 14);
            labLast.font = [UIFont systemFontOfSize:14];
            labLast.text = [arrNum objectAtIndex:i];
            // labLast.textAlignment = NSTextAlignmentCenter;
            labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
            [self.view addSubview:labLast];
        }else if (i == 1){
            lab.frame = CGRectMake(ScreenWidth/4 + 10, descHeight + 75, ScreenWidth/2 - 20, 13);
            labLast.frame = CGRectMake(ScreenWidth/4 + 10, descHeight + 95, ScreenWidth/2 - 20, 14);
            labLast.font = [UIFont systemFontOfSize:14];
            labLast.text = [arrNum objectAtIndex:i];
            //labLast.textAlignment = NSTextAlignmentCenter;
            labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
            [self.view addSubview:labLast];
        } else if(i == 2) {
            lab.frame = CGRectMake(ScreenWidth*3/4 + 10, descHeight + 75, ScreenWidth/4 - 20, 13);
            moneLab = [[UILabel alloc] init];
            moneLab.frame = CGRectMake(ScreenWidth*3/4 + 10, descHeight + 95, ScreenWidth/4 - 20, 14);
            moneLab.font = [UIFont systemFontOfSize:14];
            moneLab.text = @"￥0.00";
            // moneLab.textAlignment = NSTextAlignmentCenter;
            moneLab.textColor = [ColorUtil colorWithHexString:@"333333"];
            [self.view addSubview:moneLab];
        }
        
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = [arrTitle objectAtIndex:i];
        //lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        [self.view addSubview:lab];
        
        
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/4, descHeight + 75, 1, 35)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:lineView1];
    
    
    UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*3/4, descHeight + 75, 1, 35)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:lineView];
    
    
    UIView *viewLine= [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 95 + 14 + 15, ScreenWidth, 1)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [self.view addSubview:viewLine];
    
    
    
    //交易密码
    
    float addfloat = 80;
    
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(10,addfloat +descHeight + 75 + 40 + 15, ScreenWidth - 110, 35)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    textView.layer.cornerRadius = 4;
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(5,0, ScreenWidth - 120, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
    
    // sureText.layer.masksToBounds = YES;
    
    sureText.placeholder = @"交易密码";
    sureText.secureTextEntry = YES;
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
    sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sureText.font = [UIFont systemFontOfSize:15];
    sureText.delegate = self;
    [textView addSubview:sureText];
    [self.view addSubview:textView];
    
    
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ScreenWidth - 90,addfloat +descHeight + 75 + 40 + 15, 80, 35);
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    [sureBtn setTitle:@"预约" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureMehtods:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    //协议
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10,addfloat + descHeight + 75 + 100, 15, 15)];
    btn.tag = 1;
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMethods:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(30 ,addfloat + descHeight + 75 +  100, 75, 15)];
    hasLab.text = @"我已经阅读";
    hasLab.font = [UIFont systemFontOfSize:15];
    hasLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [self.view addSubview:hasLab];
    
    
    UIButton *procoalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procoalBtn.frame = CGRectMake(105,addfloat + descHeight + 75 + 100, 115, 15);
    [procoalBtn setTitle:@"《认购协议》" forState:UIControlStateNormal];
    [procoalBtn setTitleColor:[ColorUtil colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:procoalBtn];
    

    
}

- (IBAction)sureMehtods:(id)sender {
    [self.view endEditing:YES];
    if ([sureText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    }else if (count % 2 == 0) {
        [self.view makeToast:@"请阅读并同意认购协议" duration:1.0 position:@"center"];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.delegate = self;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLogin:sureText.text tag:kBusinessTagGetJRappYyrgsq];
            
            // [self requestLogin:self.passWord.text withWTSl:[NSString stringWithFormat:@"%li",[self.str integerValue]/[[self.dic objectForKey:@"FXJ"] integerValue]] tag:kBusinessTagGetJRDoTrade];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
    
}




- (IBAction)remberMethods:(UIButton *)sender {
    
   
        count++;
        
        if (count % 2 == 0) {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
            
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
            
        }
    
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}


#pragma mark - Request Methods
//请求支付无夏金币
- (void)requestLogin:(NSString *)_jymm tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[[Base64XD encodeBase64String:_jymm] strBase64] forKey:@"jymm"];
    [paraDic setObject:[self.dic objectForKey:@"GQDM"] forKey:@"gqdm"];
    [paraDic setObject:[moneyDic objectForKey:@"VALUE"] forKey:@"yyje"];//委托金额除 以委托价格
    [paraDic setObject:dateLStarabel.text forKey:@"yjrgrq"];
    
    
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
        
        if (tag== kBusinessTagGetJRappYyrgsq) {
            //NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.view makeToast:[jsonDic objectForKey:@"msg"]];
                //            subing = NO;
            } else {
                YuSuccessViewController *vc = [[YuSuccessViewController alloc] initWithNibName:@"YuSuccessViewController" bundle:nil];
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
@end
