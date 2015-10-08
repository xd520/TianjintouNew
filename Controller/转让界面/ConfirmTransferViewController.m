//
//  ConfirmTransferViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-25.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ConfirmTransferViewController.h"
#import "AppDelegate.h"
#import "PorductViewController.h"
#import "LPLabel.h"
#import "TransferProcoalViewController.h"
#import "ProductProcoalViewController.h"
#import "TransferSuccessViewController.h"

@interface ConfirmTransferViewController ()
{
    float addHight;
    int count;
    int countPast;
    
    int switchCount;
    UIScrollView *scrollView;
    UITextField *sureText;
    UITextField *sureText1;
    UILabel *moneLab;
    UIView *lastView;
    UIView *view1;
    NSMutableArray *dataList;
    
    UILabel *labMoney;
    UILabel *totalMoney;
    UILabel *lastMoney;
}
@end

@implementation ConfirmTransferViewController

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
    countPast = 0;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 44 - addHight)];
     
    [self.view addSubview:scrollView];
    
    
    [self requestRecordPastList:@"1" milit:@"20" tag:kBusinessTagGetJRuserCoinData];
     [self reloadDataWith:_dic];
    
}

- (void)requestRecordPastList:(NSString *)_start milit:(NSString *)_limit tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_start forKey:@"pageIndex"];
    [paraDic setObject:_limit forKey:@"pageSize"];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
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



-(void)reloadDataWith:(NSDictionary *)dataArr {
    
    //产品名称
    UILabel *descPriceLabel = [[UILabel alloc] init];
    descPriceLabel.text = [dataArr objectForKey:@"FID_CPMC"];
    //使用自定义字体
    descPriceLabel.font = [UIFont systemFontOfSize:15];    //设置字体颜色
    //descPriceLabel.textColor = [ColorUtil colorWithHexString:@"1b1b1b"];
    descPriceLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    CGSize titleSize = [descPriceLabel.text sizeWithFont:descPriceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    
    descPriceLabel.frame = CGRectMake(10, 15, titleSize.width, 15);
    int descHeight = 15;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 15, 15, 15)];
    imgView.image = [UIImage imageNamed:@"icon_transfer"];
     [scrollView addSubview:imgView];
    
    [scrollView addSubview:descPriceLabel];
    
    
    UILabel *numYQH = [[UILabel alloc] init];
    numYQH.text = [dataArr objectForKey:@"FID_SYL"];
    numYQH.font = [UIFont systemFontOfSize:30];
    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    numYQH.frame = CGRectMake(10,10 + descHeight + 17.5, titleSize.width, 30);
    [scrollView addSubview:numYQH];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, descHeight + 25 + 19.5, 15, 13)];
    lab.text = @"%";
    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    lab.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:lab];
    
    
    
    
    NSArray *arrTitle = @[@"剩余期限",@"收益方式",@"到期日期"];
    
    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[dataArr objectForKey:@"FID_DQRQ"]];
    
    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
    
    [strDate insertString:@"-" atIndex:4];
    
    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
    
    
    NSArray *arrNum = @[[NSString stringWithFormat:@"%@天",[dataArr objectForKey:@"FID_SYTS"]],[dataArr objectForKey:@"FID_FXMS"],strDate];
    
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] init];
        UILabel *labLast = [[UILabel alloc] init];
        if (i == 0) {
            lab.frame = CGRectMake(10, descHeight + 75, ScreenWidth*5/16 - 20, 13);
            labLast.frame = CGRectMake(10, descHeight + 95, ScreenWidth*5/16 - 20, 14);
            
        }else if (i == 1){
            lab.frame = CGRectMake(ScreenWidth*5/16 + 10, descHeight + 75, ScreenWidth*6/16 - 20, 13);
            labLast.frame = CGRectMake(ScreenWidth*5/16 + 10, descHeight + 95, ScreenWidth*6/16 - 20, 14);
            
        } else if(i == 2) {
            lab.frame = CGRectMake(ScreenWidth*11/16 + 10, descHeight + 75, ScreenWidth*5/16 - 20, 13);
            
            labLast.frame  = CGRectMake(ScreenWidth*11/16 + 10, descHeight + 95, ScreenWidth*5/16 - 20, 14);
           
        }
        
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = [arrTitle objectAtIndex:i];
       // lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        [scrollView addSubview:lab];
        labLast.font = [UIFont systemFontOfSize:14];
        labLast.text = [arrNum objectAtIndex:i];
       // labLast.textAlignment = NSTextAlignmentCenter;
        labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
        [scrollView addSubview:labLast];
        
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*5/16, descHeight + 75, 1, 35)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [scrollView addSubview:lineView1];
    
    
    UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*11/16, descHeight + 75, 1, 35)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [scrollView addSubview:lineView];
    
    
    UIView *viewLine= [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 95 + 14 + 15, ScreenWidth, 1)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [scrollView addSubview:viewLine];
    
    //剩余时间
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 140, 150, 16)];
    remindLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    remindLab.text = @"使用添金币抵扣";
    remindLab.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:remindLab];
    
    UIButton *moneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 70, 130 + descHeight, 60, 35)];
    [moneyBtn setBackgroundImage:[UIImage imageNamed:@"swish_1"] forState:UIControlStateNormal];
    [moneyBtn addTarget:self action:@selector(isGetMoney:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:moneyBtn];
    
    lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, ScreenWidth, 25*dataList.count +60 + 60 + 60)];
    lastView.hidden = YES;
    lastView.userInteractionEnabled = YES;
    [scrollView addSubview:lastView];
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 190 + 25*dataList.count +60 + 60 + 60)];
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 190, ScreenWidth, 200)];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    backView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [view1 addSubview:backView];
    
    
    UILabel *totalM = [[UILabel alloc] init];
    totalM.text = [NSString stringWithFormat:@"支付总额%@元",[_dic objectForKey:@"FID_WTJE"]];
    totalM.font = [UIFont systemFontOfSize:15];
    titleSize = [totalM.text sizeWithFont:totalM.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    totalM.frame = CGRectMake(10, 10 + 15,titleSize.width, 15);
    totalM.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    [view1 addSubview:totalM];
    
    UILabel *lastM = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 10 + 15, ScreenWidth - 40 - titleSize.width, 15)];
    lastM.text = @"(添金币已抵用0元)";
    lastM.font = [UIFont systemFontOfSize:15];
    lastM.textColor = [ColorUtil colorWithHexString:@"999999"];
    [view1 addSubview:lastM];
    
    //交易密码
    
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(10,40 + 15, ScreenWidth - 110, 35)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    textView.layer.cornerRadius = 4;
    textView.layer.borderWidth = 1;
    
    
    
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(5,0, ScreenWidth - 120, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
     sureText.secureTextEntry = YES;
    sureText.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    sureText.placeholder = @"交易密码";
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
     sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sureText.font = [UIFont systemFontOfSize:15];
    sureText.delegate = self;
    [textView addSubview:sureText];
    [view1 addSubview:textView];
    
    
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(ScreenWidth - 90,40 + 15, 80, 35);
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    [sureBtn setTitle:@"支付" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureMehtods:) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:sureBtn];
    //协议
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 15, 15)];
    btn.tag = 1;
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMehods:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(30 , 100, 75, 15)];
    hasLab.text = @"我已经阅读";
    hasLab.font = [UIFont systemFontOfSize:15];
    hasLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [view1 addSubview:hasLab];
    
    
    UIButton *procoalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procoalBtn.frame = CGRectMake(105, 100, 115, 15);
    [procoalBtn setTitle:@"《转让协议》" forState:UIControlStateNormal];
    [procoalBtn setTitleColor:[ColorUtil colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:procoalBtn];
    
    [scrollView addSubview:view1];
    
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 600)];
}

-(void)isGetMoney:(UIButton *)btn {
    
    switchCount++;
    
    if (switchCount % 2 == 0) {
        
        [btn setBackgroundImage:[UIImage imageNamed:@"swish_1"] forState:UIControlStateNormal];
        lastView.hidden = YES;
        view1.hidden = NO;
        
    } else {
        
        [btn setBackgroundImage:[UIImage imageNamed:@"swish"] forState:UIControlStateNormal];
        lastView.hidden = NO;
        view1.hidden = YES;
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

#pragma mark - Request Methods
//请求支付无夏金币
- (void)requestLogin:(NSString *)_jymm tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[[Base64XD encodeBase64String:_jymm] strBase64] forKey:@"jymm"];
    [paraDic setObject:[self.dic objectForKey:@"FID_GQDM"] forKey:@"gqdm"];
    [paraDic setObject:[_dic objectForKey:@"FID_WTJE"] forKey:@"wtje"];//委托金额除 以委托价格
    [paraDic setObject:[self.dic objectForKey:@"FID_WTSL"] forKey:@"wtsl"];
    [paraDic setObject:[self.dic objectForKey:@"FID_PLWTPCH"] forKey:@"ydh"];
    
    
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

//请求支付无夏金币
- (void)requestLoginMore:(NSString *)_jymm withWTSl:(NSString *)_wtsl  tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:[[Base64XD encodeBase64String:_jymm] strBase64] forKey:@"jymm"];
    [paraDic setObject:_wtsl forKey:@"keyid"];
    [paraDic setObject:[self.dic objectForKey:@"FID_GQDM"] forKey:@"gqdm"];
    [paraDic setObject:[_dic objectForKey:@"FID_WTJE"] forKey:@"wtje"];//委托金额除 以委托价格
    [paraDic setObject:[self.dic objectForKey:@"FID_WTSL"] forKey:@"wtsl"];
    [paraDic setObject:[self.dic objectForKey:@"FID_PLWTPCH"] forKey:@"ydh"];
    
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}





-(void)initButten {
    for (int i = 0; i < [dataList count]; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25*i, 15, 15)];
        btn.tag = i;
        if ([[[dataList objectAtIndex:i] objectForKey:@"selected"] isEqualToString:@"1"]) {
            [btn setImage:[UIImage imageNamed:@"select_1"] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
        }
        //[btn setBackgroundImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectMethods:) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:btn];
        
        UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(27, 25*i, ScreenWidth - 37, 15)];
        moneyLab.font = [UIFont systemFontOfSize:15];
        moneyLab.textColor = [ColorUtil colorWithHexString:@"333333"];
       // moneyLab.text = [NSString stringWithFormat:@"%@添金币",[[dataList objectAtIndex:i] objectForKey:@"KYJE"]];
        
         moneyLab.text = [NSString stringWithFormat:@"%@添金币  %@日到期",[[dataList objectAtIndex:i] objectForKey:@"KYJE"],[[dataList objectAtIndex:i] objectForKey:@"JSRQ"]];
        
        [lastView addSubview:moneyLab];
        
        UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(115, 25*i, 180, 15)];
        dateLab.font = [UIFont systemFontOfSize:15];
        dateLab.textColor = [ColorUtil colorWithHexString:@"333333"];
        dateLab.text = [NSString stringWithFormat:@"%@添金币",[[dataList objectAtIndex:i] objectForKey:@"JSRQ"]];
        //[lastView addSubview:dateLab];
        
    }
    
    labMoney = [[UILabel alloc] initWithFrame:CGRectMake(10, 25*dataList.count, ScreenWidth - 20, 15)];
    labMoney.font = [UIFont systemFontOfSize:14];
    labMoney.textColor = [ColorUtil colorWithHexString:@"999999"];
    labMoney.text = @"已选择使用0添金币";
    [lastView addSubview:labMoney];
    
    // [self refreshPrice];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 25*dataList.count + 30, ScreenWidth, 10)];
    
    backView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [lastView addSubview:backView];
    
    
    totalMoney = [[UILabel alloc] init];
    totalMoney.text = [NSString stringWithFormat:@"支付总额%@元",[_dic objectForKey:@"FID_WTJE"]];
    totalMoney.font = [UIFont systemFontOfSize:15];
    CGSize titleSize = [totalMoney.text sizeWithFont:totalMoney.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    totalMoney.frame = CGRectMake(10, 25*dataList.count + 30 + 15,titleSize.width, 15);
    totalMoney.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    [lastView addSubview:totalMoney];
    
    lastMoney = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 25*dataList.count + 30 + 15, ScreenWidth - 40 - titleSize.width, 15)];
    lastMoney.text = @"(添金币已抵用0元)";
    lastMoney.font = [UIFont systemFontOfSize:15];
    lastMoney.textColor = [ColorUtil colorWithHexString:@"999999"];
    [lastView addSubview:lastMoney];
    
    //交易密码
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(10, 25*dataList.count +60 + 15, ScreenWidth - 110, 35)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    textView.layer.cornerRadius = 4;
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    
    sureText1 = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth - 120, 35)];
    sureText1.backgroundColor = [UIColor whiteColor];
    sureText1.placeholder = @"交易密码";
    sureText1.secureTextEntry = YES;
     sureText.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
    sureText1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText1.clearButtonMode = UITextFieldViewModeWhileEditing;
    // sureText.keyboardType = UIKeyboardTypeNumberPad;
    sureText1.font = [UIFont systemFontOfSize:15];
    
    sureText1.delegate = self;
    [textView addSubview:sureText1];
    [lastView addSubview:textView];
    
    
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //sureBtn.tag = 10003;
    sureBtn.frame = CGRectMake(ScreenWidth - 90, 25*dataList.count +60 + 15, 80, 35);
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    [sureBtn setTitle:@"支付" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureMehtods1:) forControlEvents:UIControlEventTouchUpInside];
    
    [lastView addSubview:sureBtn];
    //协议
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25*dataList.count +60 + 60, 15, 15)];
    btn.tag = 2;
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMehods:) forControlEvents:UIControlEventTouchUpInside];
    [lastView addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(30 , 25*dataList.count +60 + 60, 75, 15)];
    hasLab.text = @"我已经阅读";
    hasLab.font = [UIFont systemFontOfSize:15];
    hasLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [lastView addSubview:hasLab];
    
    
     UIButton *procoalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procoalBtn.frame = CGRectMake(105, 25*dataList.count +60 + 60, 115, 15);
    [procoalBtn setTitle:@"《转让协议》" forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [procoalBtn setTitleColor:[ColorUtil colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [lastView addSubview:procoalBtn];
    
    lastView.frame = CGRectMake(0, 190, ScreenWidth, 400);
    lastView.userInteractionEnabled = YES;
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 600)];
    
}


- (void)refreshPrice
{
    int price = 0;
    if ([dataList count] > 0) {
        for (NSMutableDictionary *dic in dataList) {
            if ([[dic objectForKey:@"selected"] isEqualToString:@"1"]) {
                price += [[dic objectForKey:@"KYJE"] integerValue];
            }
        }
    }
    [labMoney setText:[NSString stringWithFormat:@"已选择使用%d添金币", price]];
    
    if (price > [[_dic objectForKey:@"FID_WTJE"] integerValue]) {
        [totalMoney setText:@"支付总额0.00元"];
    } else {
       [totalMoney setText:[NSString stringWithFormat:@"支付总额%d元",(int)[[_dic objectForKey:@"FID_WTJE"] integerValue] - price]];
    }
    
    CGSize titleSize = [totalMoney.text sizeWithFont:totalMoney.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    totalMoney.frame = CGRectMake(10, 25*dataList.count + 30 + 15,titleSize.width, 15);
    
    lastMoney.frame = CGRectMake(10 + titleSize.width, 25*dataList.count + 30 + 15, ScreenWidth - 40 - titleSize.width, 15);
    
    [lastMoney setText:[NSString stringWithFormat:@"(添金币已抵用%d元)", price]];
}


- (void)recivedNoOrderList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理未发货订单");
    //dataArray = dataList;
    
    if ([dataList count] > 0) {
        [dataList removeAllObjects];
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    
    [self initButten];
    
}

-(void)selectMethods:(UIButton *)btn {
    
    NSMutableDictionary *tempDic = [dataList objectAtIndex:btn.tag];
    if ([[tempDic objectForKey:@"selected"] isEqualToString:@"1"]) {
        [tempDic setObject:@"0" forKey:@"selected"];
        [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    } else {
        [tempDic setObject:@"1" forKey:@"selected"];
        [btn setImage:[UIImage imageNamed:@"select_1"] forState:UIControlStateNormal];
    }
    [self refreshPrice];
    
}






-(void)pushVCProtocal{
    
    TransferProcoalViewController *vc = [[TransferProcoalViewController alloc] init];
    vc.str = [self.dic objectForKey:@"FID_GQDM"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}




#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
   
}



/*
#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)_jymm  tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:_jymm forKey:@"jymm"];
    [paraDic setObject:[self.dic objectForKey:@"FID_GQDM"] forKey:@"gqdm"];
    //[paraDic setObject:@"59" forKey:@"wtlb"];
    //[paraDic setObject:@"" forKey:@"wtjg"];
    [paraDic setObject:[self.dic objectForKey:@"FID_WTSL"] forKey:@"wtsl"];
    [paraDic setObject:[self.dic objectForKey:@"FID_PLWTPCH"] forKey:@"ydh"];
    
    //[paraDic setObject:@"" forKey:@"ddyxrq"];
    [paraDic setObject:[self.dic objectForKey:@"FID_WTJE"] forKey:@"wtje"];
    //[paraDic setObject:@"4" forKey:@"ddjyxz"];
    
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

 */
#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
    if (tag== kBusinessTagGetJRcpzrdoTrade) {
       // NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"] duration:2 position:@"center"];
           
            //            subing = NO;
        } else {
            TransferSuccessViewController *vc = [[TransferSuccessViewController alloc] initWithNibName:@"TransferSuccessViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else if (tag==kBusinessTagGetJRuserCoinData) {
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            
            [self recivedNoOrderList:[jsonDic objectForKey:@"object"]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)remberMehods:(UIButton *)sender {
    if (sender.tag == 1) {
        count++;
        if (count % 2 == 0) {
            [sender setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
        }
    } else {
        countPast++;
        if (countPast % 2 == 0) {
            [sender setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
        }
    
    }
    
}


- (IBAction)sureMehtods:(id)sender {
    [self.view endEditing:YES];
    if ([sureText.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    }else if (count % 2 == 0) {
        [self.view makeToast:@"请同意投资协议" duration:1.0 position:@"center"];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.delegate = self;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLogin:sureText.text tag:kBusinessTagGetJRcpzrdoTrade];
            
            // [self requestLogin:self.passWord.text withWTSl:[NSString stringWithFormat:@"%li",[self.str integerValue]/[[self.dic objectForKey:@"FXJ"] integerValue]] tag:kBusinessTagGetJRDoTrade];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
    
}

- (IBAction)sureMehtods1:(id)sender {
    [self.view endEditing:YES];
    if ([sureText1.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入交易密码" duration:2 position:@"center"];
    }else if (countPast % 2 == 0) {
        [self.view makeToast:@"请同意投资协议" duration:1.0 position:@"center"];
        
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        hud.delegate = self;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [self requestLoginMore:sureText1.text withWTSl:[self getId:dataList] tag:kBusinessTagGetJRcpzrdoTrade];
            
            //[self requestLogin:self.passWord.text withWTSl:[NSString stringWithFormat:@"%li",[self.str integerValue]/[[self.dic objectForKey:@"FXJ"] integerValue]] tag:kBusinessTagGetJRDoTrade];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
    }
    
}

-(NSString *)getId:(NSMutableArray *)data {
    NSString *string = nil;
    NSString *lastString = @"";
    
    for (NSMutableDictionary *dic in data) {
        if ([[dic objectForKey:@"selected"] isEqualToString:@"1"]) {
            string = [NSString stringWithFormat:@"%@,%@", lastString, [dic objectForKey:@"KEYID"]];
            ;
            lastString = [NSString stringWithFormat:@"%@",string];
            
        }
    }
    return lastString;
}




@end
