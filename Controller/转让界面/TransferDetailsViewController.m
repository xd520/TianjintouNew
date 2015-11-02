//
//  TransferDetailsViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-16.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "TransferDetailsViewController.h"
#import "AppDelegate.h"
#import "ConfirmTransferViewController.h"
#import "EstimateViewController.h"
#import "RiskEvaluationViewController.h"
#import "MyAuthorityViewController.h"
#import "ClassEstmateViewController.h"

@interface TransferDetailsViewController ()
{
    UIScrollView *scrollView;
    NSMutableDictionary *firstDic;
    float addHight;
    UILabel * _longtime1;
    NSString *timeStr;
    NSDictionary *dicFirst;
    int day;
    int timeAll;
}
@end

@implementation TransferDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestLogin:_gqdm withWTH:_wth tag:kBusinessTagGetJRSelling];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    
}

-(void)reloadViewUIData:(NSMutableDictionary *)dataArr {
    //产品名称
    
    UIView *firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor whiteColor];
    
    
    //产品名称
    SHLUILabel *descPriceLabel = [[SHLUILabel alloc] init];
    descPriceLabel.text = [dataArr objectForKey:@"FID_CPMC"];
    //使用自定义字体
    descPriceLabel.font = [UIFont systemFontOfSize:15];    //设置字体颜色
    //descPriceLabel.textColor = [ColorUtil colorWithHexString:@"1b1b1b"];
    descPriceLabel.textColor = [UIColor blackColor];
    descPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descPriceLabel.linesSpacing = 2.0f;
    //0:6 1:7 2:8 3:9 4:10
    //linesSpacing_
    descPriceLabel.numberOfLines = 0;
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    int descHeight = [descPriceLabel getAttributedStringHeightWidthValue:ScreenWidth - 20];
    NSLog(@"SHLLabel height:%d", descHeight);
    descPriceLabel.frame = CGRectMake(10.f, 15, ScreenWidth - 20, descHeight);
    NSLog(@"%d",descHeight - 32);
    
    
    firstView.frame = CGRectMake(0, 0, ScreenWidth, 240 - 15 + descHeight);
    
    
    /*
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
     
    
    
     CGSize titleSize = [descPriceLabel.text sizeWithFont:descPriceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    
    if (descHeight > 15) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50 + titleSize.width - ScreenWidth + 20, 30 + 10, 15, 15)];
        imgView.image = [UIImage imageNamed:@"icon_transfer"];
        [firstView addSubview:imgView];
        
    } else {
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + titleSize.width, 15, 15, 15)];
    imgView.image = [UIImage imageNamed:@"icon_transfer"];
     [firstView addSubview:imgView];
    }
    */
     
     
     
    [firstView addSubview:descPriceLabel];
    
    
    UILabel *numYQH = [[UILabel alloc] init];
    numYQH.text = [dataArr  objectForKey:@"FID_SYL"];
    numYQH.font = [UIFont systemFontOfSize:30];
    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
   CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    numYQH.frame = CGRectMake(10,10 + descHeight + 17.5, titleSize.width, 30);
    
    [firstView addSubview:numYQH];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, descHeight + 25 + 19.5, 15, 13)];
    lab.text = @"%";
    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    lab.font = [UIFont systemFontOfSize:13];
    [firstView addSubview:lab];
    
    NSArray *arrTitle,*arrNum;
    
    if ([[dataArr objectForKey:@"FID_CJ"] hasPrefix:@"-"]) {
        arrTitle = @[@"剩余期限(天)",@"加价(元)",@"项目本金(元)"];
        arrNum = @[[dataArr objectForKey:@"FID_SYTS"],[NSString stringWithFormat:@"%.2f", 0 - [[dataArr objectForKey:@"FID_CJ"] floatValue]],[dataArr objectForKey:@"FID_CBJ"]];
        
       // valueLabel.text = @"加价";
    } else {
        arrTitle = @[@"剩余期限(天)",@"让利(元)",@"项目本金(元)"];
        arrNum = @[[dataArr objectForKey:@"FID_SYTS"],[dataArr objectForKey:@"FID_CJ"],[dataArr objectForKey:@"FID_CBJ"]];
       // valueLabel.text = @"让利";
    }

    
    //NSArray *arrTitle = @[@"剩余期限(天)",@"让利(元)",@"项目本金(元)"];
    
    
    //NSArray *arrNum = @[[dataArr objectForKey:@"FID_SYTS"],[dataArr objectForKey:@"FID_CJ"],[dataArr objectForKey:@"FID_CBJ"]];
    
    
    
    
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] init];
        UILabel *labLast = [[UILabel alloc] init];
        if (i == 0) {
            lab.frame = CGRectMake(10, descHeight + 75, ScreenWidth*5/16 - 20, 13);
            labLast.frame = CGRectMake(10, descHeight + 95, ScreenWidth*5/16 - 20, 14);
            
        }else if (i == 1){
            lab.frame = CGRectMake(ScreenWidth*5/16 + 10, descHeight + 75, ScreenWidth*5/16 - 20, 13);
            labLast.frame = CGRectMake(ScreenWidth*5/16 + 10, descHeight + 95, ScreenWidth*5/16 - 20, 14);
            
        } else if(i == 2) {
            lab.frame = CGRectMake(ScreenWidth*10/16 + 10, descHeight + 75,  ScreenWidth*6/16 - 20, 13);
            labLast.frame = CGRectMake(ScreenWidth*10/16 + 10, descHeight + 95,  ScreenWidth*6/16 - 20, 14);
        }
        
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = [arrTitle objectAtIndex:i];
        //lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        [firstView addSubview:lab];
        
        labLast.font = [UIFont systemFontOfSize:14];
        labLast.text = [arrNum objectAtIndex:i];
       // labLast.textAlignment = NSTextAlignmentCenter;
        labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
        [firstView addSubview:labLast];
        
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*5/16 - 1, descHeight + 75, 1, 35)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [firstView addSubview:lineView1];
    
    
    UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*10/16 - 1, descHeight + 75, 1, 35)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [firstView addSubview:lineView];
    
    
    UIView *viewLine= [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 95 + 14 + 15, ScreenWidth, 1)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [firstView addSubview:viewLine];
    
    //转让有效期
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(20, descHeight + 135, 100, 14)];
    remindLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    remindLab.text = @"转让有效期";
    remindLab.font = [UIFont systemFontOfSize:14];
    [firstView addSubview:remindLab];
    
     timeAll = [[dataArr objectForKey:@"FID_ZRYXQ"] intValue];
    
    _longtime1 = [[UILabel alloc] init];
    _longtime1.font = [UIFont boldSystemFontOfSize:14];
    [_longtime1 setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
    _longtime1.textAlignment = NSTextAlignmentLeft;
    
    _longtime1.frame = CGRectMake(20,descHeight + 155, ScreenWidth/2 + 10 , 14);
    
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod1:) userInfo:nil repeats:YES];
    
    [firstView addSubview:_longtime1];
    
    
    
    
    //收益方式
    UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(20, descHeight + 180, 100, 14)];
    starLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    starLab.text = @"收益方式";
    starLab.font = [UIFont systemFontOfSize:14];
    [firstView addSubview:starLab];
    
    UILabel *starLabTip = [[UILabel alloc] initWithFrame:CGRectMake(20, descHeight + 200, 250, 14)];
    starLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    starLabTip.text = [dataArr objectForKey:@"FID_FXMS"];
    starLabTip.font = [UIFont systemFontOfSize:14];
    [firstView addSubview:starLabTip];
    
    
    //到期日期
    UILabel *transferLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 120, descHeight + 135, 100, 14)];
    transferLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    transferLab.text = @"到期日期";
    transferLab.textAlignment = NSTextAlignmentRight;
    transferLab.font = [UIFont systemFontOfSize:14];
    [firstView addSubview:transferLab];
    

    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 120, descHeight + 155, 100, 14)];
    endLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
   // endLabTip.text = [dataArr objectForKey:@"FID_DQRQ"];
    
    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[dataArr objectForKey:@"FID_DQRQ"]];
    
    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
    
    [strDate insertString:@"-" atIndex:4];
    
    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
    
    endLabTip.text = [NSString stringWithFormat:@"%@",strDate];
    
    
    
    
    endLabTip.textAlignment = NSTextAlignmentRight;
    endLabTip.font = [UIFont systemFontOfSize:14];
    [firstView addSubview:endLabTip];
    
    [scrollView addSubview:firstView];
    
    
    //投资金额文本框设计
    
  
    
    UILabel *labStarLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 15 + descHeight + 225, ScreenWidth - 40, 15)];
    labStarLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    labStarLab.font = [UIFont systemFontOfSize:13];
    labStarLab.backgroundColor = [UIColor clearColor];
    labStarLab.text = [NSString stringWithFormat:@"转让价格%.2f元",[[dataArr objectForKey:@"FID_WTJE"] floatValue]];
    [scrollView addSubview:labStarLab];
    
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.tag = 10003;
    sureBtn.frame = CGRectMake(20, 40 + descHeight + 225, ScreenWidth - 40, 35);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    if ([[dataArr objectForKey:@"FID_ZRYXQ"] doubleValue] <= 0) {
        sureBtn.backgroundColor = [UIColor grayColor];
        sureBtn.enabled = NO;
        
    } else {
    
    if (_flag) {
       sureBtn.backgroundColor = [UIColor grayColor];
        sureBtn.enabled = NO;
    } else {
    sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    sureBtn.enabled = YES;
    }
    }
    
    [sureBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(timeTouziMethods:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sureBtn];
    
    
    UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 85 +  descHeight + 225, ScreenWidth - 40, 15)];
    detailLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.text = @"转让价格 = 项目本金 + 已产生效益 ± 价值浮动";
    [scrollView addSubview:detailLab];
    
   
    
    // 详情按钮
    UIButton *detailBtn = [[UIButton alloc] init];
    detailBtn.frame = CGRectMake(0,115 +  descHeight + 225, ScreenWidth, 40);
    detailBtn.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *detaillab = [[UILabel alloc] init];
    detaillab.frame = CGRectMake(10, 10, 79, 20);
    detaillab.text = @"项目介绍";
    detaillab.textAlignment = NSTextAlignmentCenter;
    detaillab.font = [UIFont systemFontOfSize:15];
    detaillab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [detailBtn addSubview:detaillab];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 10, 20, 20)];
    img.image = [UIImage imageNamed:@"next_icon"];
    [detailBtn addSubview:img];
    
    
    [detailBtn addTarget:self action:@selector(pushVCMethod:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:detailBtn];
    //±
    
    //估算预计
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.frame = CGRectMake(0, 165, ScreenWidth, 40);
    faceBtn.backgroundColor = [UIColor whiteColor];
    UILabel *facelab = [[UILabel alloc] init];
    facelab.frame = CGRectMake(10, 10, 79, 15);
    facelab.text = @"项目介绍";
    facelab.textAlignment = NSTextAlignmentCenter;
    facelab.font = [UIFont systemFontOfSize:15];
    facelab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [faceBtn addSubview:facelab];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 12.5, 20, 20)];
    img1.image = [UIImage imageNamed:@"next_icon"];
    [faceBtn addSubview:img1];
    
    
    //[faceBtn addTarget:self action:@selector(pushVCMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    //[baseView addSubview:faceBtn];
    
    
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 500)];
    
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


- (void)timerFireMethod1:(NSTimer*)theTimer {
   
    
    if (timeAll > 0 ) {
        
    timeAll = timeAll - 1000;
    
    //day
    int dayCount = timeAll%(3600*24*1000);
    day = (timeAll - dayCount)/(3600*24*1000);
    
    //hour
    int hourCount = dayCount%3600000;
    int hour = (dayCount - hourCount)/3600000;
    //min
    int minCount = hourCount%60000;
    int min = (hourCount - minCount)/60000;
    
    int miaoCount = minCount%1000;
    int miao = (minCount - miaoCount)/1000;
    
    _longtime1.text = [NSString stringWithFormat:@"%d天%d小时%d分钟%d秒",day, hour, min,miao];

    }else {
    
    _longtime1.text = @"转让有效期到期";
    
    }
        
        
}



#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(NSString *)gqdm withWTH:(NSString *)wth tag:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:gqdm forKey:@"gqdm"];
    [paraDic setObject:wth forKey:@"wth"];
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
    
    if (tag== kBusinessTagGetJRSelling) {
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            if (dataArray.count > 0) {
                [self reloadViewUIData:[dataArray objectAtIndex:0]];
            }
            
        }
    } else if (tag==  kBusinessTagGetJRSellingAgain) {
        NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([[[dataArray objectAtIndex:0] objectForKey:@"isBingingCard"] boolValue]) {
                
                if ([[[dataArray objectAtIndex:0] objectForKey:@"FID_KYZJ"] floatValue] > [[[dataArray objectAtIndex:0] objectForKey:@"FID_WTJE"] floatValue]) {
                    
                    if (![[[dataArray objectAtIndex:0] objectForKey:@"isFxcp"] boolValue]) {
                        RiskEvaluationViewController *vc = [[RiskEvaluationViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    } else if (![[[dataArray objectAtIndex:0] objectForKey:@"isTzqx"] boolValue]){
                        MyAuthorityViewController *vc = [[MyAuthorityViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    } else {
                    
                    
                    ConfirmTransferViewController *vc = [[ConfirmTransferViewController alloc] init];
                    vc.dic = [dataArray objectAtIndex:0];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    }
                }else {
                    [self.view makeToast:@"您的可用少于转让价格，请先充值" duration:1 position:@"center"];
                }
            } else {
                
                [self.view makeToast:@"请先绑定银行卡" duration:1 position:@"center"];
                
                }
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




/*
-(void)reloadViewUIData:(NSDictionary *)_dic {
    if (_dic.count > 0) {
        
        self.productName.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"FID_CPMC"]];
        self.priceGive.text = [NSString stringWithFormat:@"%.2f元",[[_dic objectForKey:@"FID_WTJE"] floatValue]];
    self.priceGive.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        self.myLife.text = [NSString stringWithFormat:@"%.2f元",[[_dic objectForKey:@"FID_CBJ"] floatValue]];
    self.shouYi.text = [NSString stringWithFormat:@"%.2f元",[[_dic objectForKey:@"FID_YCSSY"] floatValue]];
        self.yearLL.text = [NSString stringWithFormat:@"%.2f%@",[[_dic objectForKey:@"FID_SYL"] floatValue],@"%"];
        self.addPrice.text = [NSString stringWithFormat:@"%.2f元",[[_dic objectForKey:@"FID_CJ"] floatValue]];
        self.nextDate.text = [NSString stringWithFormat:@"下次结息日期:%@",[_dic objectForKey:@"FID_JXRQ"]];
        
        _timeTouzi.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _timeTouzi.layer.borderWidth = 1;
        
        _timeTouzi.layer.masksToBounds = YES;
        
        _timeTouzi.layer.cornerRadius = 4;
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        
        if ([[delegate.logingUser objectForKey:@"khh"] isEqualToString:[_dic objectForKey:@"FID_KHH"]]) {
            _timeTouzi.backgroundColor = [UIColor grayColor];
            _timeTouzi.enabled = NO;
        } else {
        [_timeTouzi setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
            _timeTouzi.enabled = YES;
        }
        
        
    
    float re = [[_dic objectForKey:@"FID_YCSSY"] floatValue] - [[_dic objectForKey:@"FID_CJ"] floatValue] - [[_dic objectForKey:@"FID_CBJ"] floatValue];
    
    _calacalocLab.text = [NSString stringWithFormat:@"%.2f=%.2f元+%.2f元-%.2f元",re,[[_dic objectForKey:@"FID_CBJ"] floatValue],[[_dic objectForKey:@"FID_YCSSY"] floatValue],[[_dic objectForKey:@"FID_CJ"] floatValue]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 180 + addHight, ScreenWidth, 1)];
    view.backgroundColor = [ColorUtil colorWithHexString:@"e5e5e5"];
    [self.view addSubview:view];
    
     UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 295 + addHight, ScreenWidth, 1)];
      view1.backgroundColor = [ColorUtil colorWithHexString:@"e5e5e5"];
    [self.view addSubview:view1];
    
    }
}

*/


-(void)pushVCMethod:(id)sender {
    
    ClassEstmateViewController *vc = [[ClassEstmateViewController alloc] init];
    vc.gqdm = [firstDic objectForKey:@"FID_GQDM"];
   // vc.gqlb = [firstDic objectForKey:@"FID_GQLB"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
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




- (IBAction)timeTouziMethods:(id)sender{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (delegate.logingUser.count > 0) {
        
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
             [self requestLogin:_gqdm withWTH:_wth tag:kBusinessTagGetJRSellingAgain];
        } else {
            
           // delegate.strlogin = @"2";
            
            LoginViewController *VC = [[LoginViewController alloc] init];
            
            VC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    } else {
        
       // delegate.strlogin = @"2";
        
        LoginViewController *VC = [[LoginViewController alloc] init];
        
        VC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}

- (IBAction)back:(id)sender {
    //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //delegate.isON = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
