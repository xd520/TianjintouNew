//
//  DetailViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "EstimateViewController.h"
#import "ConfirmViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "RiskEvaluationViewController.h"
#import "MyAuthorityViewController.h"
#import "ClassEstmateViewController.h"
#import "YuYueViewController.h"


@interface DetailViewController ()
{
    UIScrollView *scrollView;
    UIView *changeView;
    UITextField *sureText;
    UILabel *wantMoneyLab;
    NSDictionary *dicFirst;
    float addHight;
    UILabel * _longtime1;
    NSString *timeStr;
    long long day;
    long long timeAll;
    
}
@end


@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestLogin:kBusinessTagGetJRDetailAgain];

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
    
    if(ScreenHeight > 568){
        
        _autoSizeScaleY = (ScreenHeight - 64 - 49 - 20)/435;
        
    }else{
        _autoSizeScaleY = 1.0;
    }

    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 44 - addHight)];
   // scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.tag = 100001;
    [self.view addSubview:scrollView];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestLogin:kBusinessTagGetJRDetail];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });

    
    
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


-(void)reloadDataWith:(NSMutableDictionary *)dataArr {
 //1
   
    UIView *firstVeiw = [[UIView alloc] init];
    firstVeiw.backgroundColor = [UIColor whiteColor];
    
    
//产品名称
    SHLUILabel *descPriceLabel = [[SHLUILabel alloc] init];
    descPriceLabel.text = [dataArr objectForKey:@"CPMC"];
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
    
    
    firstVeiw.frame = CGRectMake(0, 0, ScreenWidth, 285 + descHeight - 15);
    
    [firstVeiw addSubview:descPriceLabel];
    
    
    UILabel *numYQH = [[UILabel alloc] init];
    numYQH.text = [dataArr  objectForKey:@"SYL"];
    numYQH.font = [UIFont systemFontOfSize:30];
    numYQH.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    
    CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
   
    numYQH.frame = CGRectMake(10, 10 + descHeight + 15 + 2.5, titleSize.width, 30);
    
    [firstVeiw addSubview:numYQH];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, descHeight + 20 + 20 + 2.5, 15, 13)];
    lab.text = @"%";
    lab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    lab.font = [UIFont systemFontOfSize:13];
    [firstVeiw addSubview:lab];
    
    
    CGRect frame = CGRectMake(ScreenWidth - 80, descHeight + 15 + 5, 44, 44);
    MDRadialProgressTheme *newTheme12 = [[MDRadialProgressTheme alloc] init];
    //newTheme12.completedColor = [UIColor colorWithRed:90/255.0 green:212/255.0 blue:39/255.0 alpha:1.0];
    //newTheme12.incompletedColor = [UIColor colorWithRed:164/255.0 green:231/255.0 blue:134/255.0 alpha:1.0];
    newTheme12.centerColor = [UIColor clearColor];
    //newTheme.centerColor = [UIColor colorWithRed:224/255.0 green:248/255.0 blue:216/255.0 alpha:1.0];
    
    newTheme12.sliceDividerHidden = NO;
    newTheme12.labelColor = [UIColor blackColor];
    newTheme12.labelShadowColor = [UIColor whiteColor];
    
    
    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme12];
    radialView.progressTotal = 100;
    radialView.startingSlice = 75;
    radialView.theme.thickness = 10;
    radialView.theme.sliceDividerHidden = YES;
    
    if ([[dataArr objectForKey:@"JYZT"] isEqualToString:@"-4"]) {
        radialView.yuYueEnd = YES;
    } else {
        radialView.yuYueEnd = NO;
    }
    
    
    int kt;
    
    if ([_flagStr isEqualToString:@"false"]) {
        kt = 100;
        radialView.progressCounter = 100;
    } else {
    
    
    
    if ([[dataArr objectForKey:@"mjsjflag"] isEqualToString:@"1"]) {
        kt = 100;
         radialView.progressCounter = 100;
    } else {
        
        if ([dataArr objectForKey:@"flag"]&&[[dataArr objectForKey:@"jyr"] isEqualToString:@"0"]) {
             kt =  [[dataArr objectForKey:@"TZJD"] intValue];
            
            radialView.progressCounter = kt;
        } else {
            
           kt = [[dataArr objectForKey:@"TZJD"] intValue];
            
            radialView.progressCounter = kt;
        }
        
    }
}
    
    
    radialView.theme.sliceDividerHidden = YES;
    radialView.theme.incompletedColor = [ColorUtil colorWithHexString:@"eeeeee"];
    //radialView.theme.completedColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    if (kt == 0) {
        radialView.theme.completedColor = [ColorUtil colorWithHexString:@"eeeeee"];
    } else{
        radialView.theme.completedColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    }
    
    [firstVeiw addSubview:radialView];
    
    NSArray *arrTitle = @[@"投资期限(天)",@"剩余可投金额(元)",@"项目总额(元)"];
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
   // NSString *syStr = [self AddComma:[numberFormatter stringFromNumber:[dataArr objectForKey:@"SYTZJE"]]];
    
    
    NSArray *arrNum = @[[dataArr objectForKey:@"QX"],[self AddComma:[numberFormatter stringFromNumber:[dataArr objectForKey:@"SYTZJE"]]],[self AddComma:[numberFormatter stringFromNumber:[dataArr objectForKey:@"ZGB"]]]];
    
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] init];
         UILabel *labLast = [[UILabel alloc] init];
        if (i == 0) {
            lab.frame = CGRectMake(10, descHeight + 75,ScreenWidth/4 - 1 + 10, 13);
            labLast.frame = CGRectMake(10, descHeight + 95, ScreenWidth/4 + 10, 14);
            
        }else if (i == 1){
        lab.frame = CGRectMake(ScreenWidth/4 + 20, descHeight + 75, ScreenWidth*3/8 -1, 13);
        labLast.frame = CGRectMake(ScreenWidth/4 + 20, descHeight + 95, ScreenWidth*3/8, 14);
        
        } else if(i == 2) {
        lab.frame = CGRectMake(ScreenWidth*5/8 + 20, descHeight + 75, ScreenWidth*3/8 - 1 - 20, 13);
        labLast.frame = CGRectMake(ScreenWidth*5/8 + 20, descHeight + 95, ScreenWidth*3/8 - 20, 14);
        }
                        
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = [arrTitle objectAtIndex:i];
        //lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        [firstVeiw addSubview:lab];
        
        labLast.font = [UIFont systemFontOfSize:14];
        labLast.text = [arrNum objectAtIndex:i];
        //labLast.textAlignment = NSTextAlignmentCenter;
        labLast.textColor = [ColorUtil colorWithHexString:@"333333"];
         [firstVeiw addSubview:labLast];
        
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/4 - 1 + 10, descHeight + 75, 1, 35)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [firstVeiw addSubview:lineView1];
    
    
    UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*5/8 - 1 + 10, descHeight + 75, 1, 35)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [firstVeiw addSubview:lineView];
    
    
    UIView *viewLine= [[UIView alloc] initWithFrame:CGRectMake(0, descHeight + 95 + 14 + 15, ScreenWidth, 1)];
    viewLine.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [firstVeiw addSubview:viewLine];
    
 //剩余时间
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 135, 100, 14)];
    remindLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    remindLab.text = @"剩余时间";
    remindLab.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:remindLab];
    
    
    NSLog(@"dqsj = %@ ,   %lld",[dataArr objectForKey:@"DQSJ"],[[dataArr objectForKey:@"DQSJ"] longLongValue]);
    
    
    NSLog(@"dqsj = %lld  nowDate = %lld  last == %lld ",[[dataArr objectForKey:@"DQSJ"] longLongValue],[[dataArr objectForKey:@"nowDate"] longLongValue],[[dataArr objectForKey:@"DQSJ"] longLongValue] - [[dataArr objectForKey:@"nowDate"] longLongValue]);
    
    
     timeAll = ([[dataArr objectForKey:@"DQSJ"] longLongValue] - [[dataArr objectForKey:@"nowDate"] longLongValue]);
    
    _longtime1 = [[UILabel alloc] init];
    _longtime1.font = [UIFont boldSystemFontOfSize:14];
    [_longtime1 setTextColor:[ColorUtil colorWithHexString:@"fe8103"]];
    _longtime1.textAlignment = NSTextAlignmentLeft;
    
    _longtime1.frame = CGRectMake(10,descHeight + 155, ScreenWidth/2 , 14);
    
     if ([_flagStr isEqualToString:@"false"]) {
     _longtime1.text = @"募集结束";
     }else {
    if ([[dataArr objectForKey:@"mjsjflag"] isEqualToString:@"-1"]) {
        timeStr = [dataArr objectForKey:@"FID_DQRQ"];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod1:) userInfo:nil repeats:YES];
    } else {
    
    _longtime1.text = @"募集结束";
    }
}
    [firstVeiw addSubview:_longtime1];
    
    
    
    
 //起息日期
    UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 180, 100, 14)];
    starLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    starLab.text = @"起息日期";
    starLab.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:starLab];
    
    UILabel *starLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 200, 100, 14)];
    starLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    starLabTip.text = [dataArr objectForKey:@"FID_JXRQ"];
    starLabTip.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:starLabTip];
    
    
    
//到期日期
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 225, 100, 14)];
    endLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    endLab.text = @"到期日期";
    endLab.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:endLab];
    
    
    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, descHeight + 245, 100, 14)];
    endLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    endLabTip.text = [dataArr objectForKey:@"FID_DQRQ"];
    endLabTip.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:endLabTip];
    
    
    
 //收益方式
    UILabel *shouyiLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, descHeight + 135, 100, 14)];
    shouyiLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    shouyiLab.text = @"收益方式";
    shouyiLab.textAlignment = NSTextAlignmentRight;
    shouyiLab.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:shouyiLab];
    
    UILabel *shouyiLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 150, descHeight + 155, 140, 14)];
    shouyiLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    shouyiLabTip.text = [dataArr objectForKey:@"FXMS"];
    shouyiLabTip.textAlignment = NSTextAlignmentRight;
    shouyiLabTip.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:shouyiLabTip];
    
    
 //转让时间
    UILabel *transferLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, descHeight + 180, 100, 14)];
    transferLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    transferLab.text = @"转让时间";
    transferLab.textAlignment = NSTextAlignmentRight;
    transferLab.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:transferLab];
    
    UILabel *transferLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 150, descHeight + 200, 140, 14)];
    transferLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
//    if ([[dataArr objectForKey:@"mjsjflag"] isEqualToString:@"-1"]) {
//        transferLabTip.text = [NSString stringWithFormat:@"持有%@天后可以转让",[dataArr objectForKey:@"ZRRQ"]];
//    } else {
//    
//     transferLabTip.text = @"转让结束";
//    }
   
     transferLabTip.text = [NSString stringWithFormat:@"持有%@天后可以转让",[dataArr objectForKey:@"ZRRQ"]];
    
    transferLabTip.textAlignment = NSTextAlignmentRight;
    transferLabTip.font = [UIFont systemFontOfSize:14];
    [firstVeiw addSubview:transferLabTip];
    
    if ([[dataArr objectForKey:@"JYZT"] isEqualToString:@"-4"]) {
    
     UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, descHeight + 225, 100, 14)];
     endLab.textColor = [ColorUtil colorWithHexString:@"999999"];
     endLab.text = @"预约截止日期";
    endLab.textAlignment = NSTextAlignmentRight;
     endLab.font = [UIFont systemFontOfSize:14];
     [firstVeiw addSubview:endLab];
     
     
     UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, descHeight + 245, 100, 14)];
     endLabTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    endLabTip.textAlignment = NSTextAlignmentRight;
     endLabTip.text = [dataArr objectForKey:@"YSJZRQ"];
     endLabTip.font = [UIFont systemFontOfSize:14];
     [firstVeiw addSubview:endLabTip];
    
 }
    
    [scrollView addSubview:firstVeiw];
    
 //投资金额文本框设计
    
    UIControl *textVeiw = [[UIControl alloc] initWithFrame:CGRectMake(10, 10 + descHeight + 270, ScreenWidth - 120, 35)];
    textVeiw.backgroundColor = [UIColor whiteColor];
    [textVeiw addTarget:self action:@selector(view_TouchDown:) forControlEvents:UIControlEventTouchDown];
   
  
    
    
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth - 130, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
    if ([dataArr objectForKey:@"JYXX"] == [NSNull null]) {
        sureText.placeholder = @"0.00元起";
    } else {
        sureText.placeholder = [NSString stringWithFormat:@"%@元起",[dataArr objectForKey:@"QDJE"]];
    }
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
   // sureText.keyboardType = UIKeyboardTypeNumberPad;
    sureText.font = [UIFont systemFontOfSize:15];
    sureText.delegate = self;
    
     [textVeiw addSubview:sureText];
    
    [scrollView addSubview:textVeiw];
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.tag = 10003;
    sureBtn.frame = CGRectMake(ScreenWidth - 100, 10 + descHeight + 270, 90, 35);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    [sureBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(changeUI:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_flagStr isEqualToString:@"false"]) {
        sureBtn.enabled = NO;
        sureBtn.backgroundColor = [UIColor grayColor];
    }else {
    if ([[dataArr objectForKey:@"mjsjflag"] isEqualToString:@"1"]) {
        [sureBtn setTitle:@"已抢光" forState:UIControlStateNormal];
        sureBtn.enabled = NO;
        sureBtn.backgroundColor = [UIColor grayColor];
    } else {
        if ([[dataArr objectForKey:@"JYZT"] isEqualToString:@"-4"]) {
            [sureBtn setTitle:@"立即预约" forState:UIControlStateNormal];
            sureBtn.enabled = YES;
            sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
        } else {
        
        [sureBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        if ([dataArr objectForKey:@"flag"]&&[[dataArr objectForKey:@"jyr"] isEqualToString:@"0"]) {
            sureBtn.enabled = YES;
            sureBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
        } else {
            
            sureBtn.enabled = NO;
            sureBtn.backgroundColor = [UIColor grayColor];
            }
        }
    }
}
    [scrollView addSubview:sureBtn];
//起投金额
    UILabel *labStarLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 55 + descHeight + 270, 13*4, 13)];
    labStarLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    labStarLab.font = [UIFont systemFontOfSize:13];
    labStarLab.backgroundColor = [UIColor clearColor];
    labStarLab.text = @"起投金额";
    [scrollView addSubview:labStarLab];
    
    
    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
    
    
    UILabel *labVuleLab = [[UILabel alloc] init];
    labVuleLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    labVuleLab.font = [UIFont systemFontOfSize:13];
    labVuleLab.backgroundColor = [UIColor clearColor];
    labVuleLab.text = [NSString stringWithFormat:@"%@",[dataArr objectForKey:@"QDJE"]];
    
     titleSize = [labVuleLab.text sizeWithFont:labVuleLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
    labVuleLab.frame = CGRectMake(62, 55 + descHeight + 270,titleSize.width, 13);
    [scrollView addSubview:labVuleLab];
    
    
    UILabel *yuanLab = [[UILabel alloc] initWithFrame:CGRectMake(titleSize.width + 62, 55 + descHeight + 270, 13, 13)];
    yuanLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    yuanLab.font = [UIFont systemFontOfSize:13];
    yuanLab.backgroundColor = [UIColor clearColor];
    yuanLab.text = @"元";
    [scrollView addSubview:yuanLab];
    
 //[NSString stringWithFormat:@"起投金额:%@元 递增金额%@元",[dataArr objectForKey:@"QDJE"],[dataArr objectForKey:@"DZJE"]];
    UILabel *labAddLab = [[UILabel alloc] initWithFrame:CGRectMake(titleSize.width + 95 , 55 + descHeight + 270, 13*4, 13)];
    labAddLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    labAddLab.font = [UIFont systemFontOfSize:13];
    labAddLab.backgroundColor = [UIColor clearColor];
    labAddLab.text = @"递增金额";
    [scrollView addSubview:labAddLab];
    
    
    
    UILabel *labAddVuleLab = [[UILabel alloc] init];
    labAddVuleLab.textColor = [ColorUtil colorWithHexString:@"fe8103"];
    labAddVuleLab.font = [UIFont systemFontOfSize:13];
    labAddVuleLab.backgroundColor = [UIColor clearColor];
    labAddVuleLab.text = [NSString stringWithFormat:@"%@",[dataArr objectForKey:@"DZJE"]];
    
     titleSize = [labAddVuleLab.text sizeWithFont:labAddVuleLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 13)];
    labAddVuleLab.frame = CGRectMake(labAddLab.frame.origin.x + labAddLab.frame.size.width, 55 + descHeight + 270, titleSize.width, 13);
    [scrollView addSubview:labAddVuleLab];
    
    
    UILabel *yuanAddLab = [[UILabel alloc] initWithFrame:CGRectMake(labAddVuleLab.frame.origin.x + labAddVuleLab.frame.size.width, 55 + descHeight + 270, 13, 13)];
    yuanAddLab.textColor = [ColorUtil colorWithHexString:@"333333"];
    yuanAddLab.font = [UIFont systemFontOfSize:13];
    yuanAddLab.backgroundColor = [UIColor clearColor];
    yuanAddLab.text = @"元";
    [scrollView addSubview:yuanAddLab];
    
     
  // 详情按钮
    UIButton *detailBtn = [[UIButton alloc] init];
    detailBtn.frame = CGRectMake(0,80 + descHeight + 270, ScreenWidth, 40);
    detailBtn.backgroundColor = [UIColor whiteColor];
   
   
       UILabel *detaillab = [[UILabel alloc] init];
        detaillab.frame = CGRectMake(10, 12.5, 79, 15);
        detaillab.text = @"项目介绍";
        //detaillab.textAlignment = NSTextAlignmentCenter;
        detaillab.font = [UIFont systemFontOfSize:15];
        detaillab.textColor = [ColorUtil colorWithHexString:@"333333"];
        [detailBtn addSubview:detaillab];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 10, 20, 20)];
        img.image = [UIImage imageNamed:@"next_icon"];
        [detailBtn addSubview:img];
    
    
    [detailBtn addTarget:self action:@selector(pushVCMethod:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:detailBtn];
    
    
//估算预计
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.frame = CGRectMake(0, 130, ScreenWidth, 40);
    faceBtn.backgroundColor = [UIColor whiteColor];
    UILabel *facelab = [[UILabel alloc] init];
    facelab.frame = CGRectMake(10, 12.5, 79, 15);
    facelab.text = @"项目介绍";
   // facelab.textAlignment = NSTextAlignmentCenter;
    facelab.font = [UIFont systemFontOfSize:15];
    facelab.textColor = [ColorUtil colorWithHexString:@"333333"];
    [faceBtn addSubview:facelab];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 10, 20, 20)];
    img1.image = [UIImage imageNamed:@"next_icon"];
    [faceBtn addSubview:img1];
    
    
    //[faceBtn addTarget:self action:@selector(pushVCMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    //[baseView addSubview:faceBtn];
 
    
   //[scrollView addSubview:baseView];
    
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 504)];
    
}


- (void)timerFireMethod1:(NSTimer*)theTimer{
    /*
    //id obj = [theTimer userInfo];
    NSDateFormatter *f1 = [[NSDateFormatter alloc] init];
    [f1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateString = [f1 dateFromString:[NSString stringWithFormat:@"%@ 23:59:59",timeStr]];
    
    
    // NSDate *theDay = [f1 dateFromString:(NSString*)obj];
    
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *today = [NSDate date];//得到当前时间
    
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:dateString options:0];
    
   // NSString *countdown = [NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分%ld秒",[d year], [d month],[d day], [d hour], [d minute], [d second]];
   // NSString *countdown = [NSString stringWithFormat:@"%d天%ld小时%ld分钟%ld秒",day,[d hour],[d minute],[d second]];
    _longtime1.text = [NSString stringWithFormat:@"%d天%ld小时%ld分钟%ld秒",day,  [d hour], [d minute], [d second]];
    //return ;
    */
    timeAll = timeAll - 1000;
   
    //day
    long long dayCount = timeAll%(3600*24*1000);
    day = (timeAll - dayCount)/(3600*24*1000);
    
    //hour
    long long hourCount = dayCount%3600000;
    long long hour = (dayCount - hourCount)/3600000;
    //min
    long long minCount = hourCount%60000;
    long long min = (hourCount - minCount)/60000;
    
    long long miaoCount = minCount%1000;
    long long miao = (minCount - miaoCount)/1000;
    
    if (day > 0) {
       _longtime1.text = [NSString stringWithFormat:@"%lld天%lld小时%lld分钟%lld秒",day, hour, min,miao];
    } else {
    
        if (hour > 0) {
          _longtime1.text = [NSString stringWithFormat:@"%lld小时%lld分钟%lld秒", hour, min,miao];
        } else {
            if (min > 0) {
              _longtime1.text = [NSString stringWithFormat:@"%lld分钟%lld秒", min,miao];
            } else {
                if (miao == 0) {
                   _longtime1.text = @"募集结束";
                } else {
                _longtime1.text = [NSString stringWithFormat:@"%lld秒",miao];
                }
            }
        }
    }
    
 }



#pragma mark-文本框代理方法


- (void)textFieldDidBeginEditing:(UITextField *)textField {
     sureText = textField;
    scrollView.contentSize = CGSizeMake(ScreenWidth,500 +216);//原始滑动距离增加键盘高度
    CGPoint pt = [textField convertPoint:CGPointMake(0, 0) toView:scrollView];//把当前的textField的坐标映射到scrollview上
    if(scrollView.contentOffset.y-pt.y+64<=0)//判断最上面不要去滚动
        [scrollView setContentOffset:CGPointMake(0, pt.y-64) animated:YES];//华东
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    {
        [theTextField resignFirstResponder];
        
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.3];
        scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
        scrollView.contentSize = CGSizeMake(ScreenWidth,504);
        //动画结束
        [UIView commitAnimations];
        
        
    }
    return YES;
}



#pragma mark - 消除键盘


- (IBAction)view_TouchDown:(id)sender {
    [self.view endEditing:YES];
    
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    scrollView.contentSize = CGSizeMake(ScreenWidth,504);
    //动画结束
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    [[self.view viewWithTag:100001] endEditing:YES];
    
    //[sureText resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    scrollView.contentSize = CGSizeMake(ScreenWidth,504);
    //动画结束
    [UIView commitAnimations];
    
    //[scrollView endEditing:YES];
}




-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
     wantMoneyLab.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]*0.01*[[dicFirst objectForKey:@"SYL"] floatValue]];
    
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //    }else{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    }
    
    NSString *sssst;
    if ([dicFirst objectForKey:@"QDJE"] == [NSNull null]) {
        sssst = @"0";
    } else {
        sssst = [dicFirst objectForKey:@"QDJE"];
    }
    if ([sureText.text floatValue] < [sssst floatValue]) {
        [self.view makeToast:@"请输入高于起购的金额数目" duration:2 position:@"center"];
    }
}






-(void)pushVCMethod:(id)sender {
    
    ClassEstmateViewController *vc = [[ClassEstmateViewController alloc] init];
    vc.gqdm = [dicFirst objectForKey:@"GQDM"];
   // vc.gqlb = [dicFirst objectForKey:@"GQLB"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == sureText)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
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
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}




-(void)changeUI:(UIButton *)btn{
   
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.logingUser.count > 0) {
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
            if (![[dicFirst objectForKey:@"isFxcp"] boolValue]) {
                RiskEvaluationViewController *vc = [[RiskEvaluationViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            } else if (![[dicFirst objectForKey:@"isTzqx"] boolValue]){
                MyAuthorityViewController *vc = [[MyAuthorityViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            
            } else {
            
            
            if ([sureText.text isEqualToString:@""]||[sureText.text floatValue] == 0) {
                [self.view makeToast:@"请输入认购金额" duration:1.0 position:@"center"];
            }else if ([[dicFirst objectForKey:@"KHH"] isEqualToString:@""]) {
                [self.view makeToast:@"温馨提示您尚未身份认证，请先进行身份认证." duration:2 position:@"center"];
            }else if(![[dicFirst objectForKey:@"isBingingCard"] boolValue]){
                [self.view makeToast:@"请先绑定银行卡" duration:2 position:@"center"];
            } else if ([sureText.text intValue] % [[dicFirst objectForKey:@"DZJE"] intValue]!= 0) {
                [self.view makeToast:[NSString stringWithFormat:@"投资金额应为%d的整数倍",[[dicFirst objectForKey:@"DZJE"] intValue]] duration:1.0 position:@"center"];
            }else if ([sureText.text floatValue] > [[dicFirst objectForKey:@"SYTZJE"] floatValue]) {
                [self.view makeToast:@"投资金额不能超过剩余可投金额" duration:1.0 position:@"center"];
            }else if ([sureText.text floatValue] < [[dicFirst objectForKey:@"QDJE"] floatValue]) {
                [self.view makeToast:@"投资金额必须大于起投金额" duration:1.0 position:@"center"];
            }else if ([sureText.text floatValue] > [[dicFirst objectForKey:@"KYZJ"] floatValue]) {
                [self.view makeToast:@"账户可用资金小于投资金额，请充值" duration:1.0 position:@"center"];
            } else {
                
                if ([[dicFirst objectForKey:@"JYZT"] isEqualToString:@"-4"]) {
                    YuYueViewController *vc = [[YuYueViewController alloc] init];
                    vc.dic = dicFirst;
                    vc.str = sureText.text;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                
                ConfirmViewController *vc = [[ConfirmViewController alloc] init];
                vc.dic = dicFirst;
                vc.str = sureText.text;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
                    }
                }
            
            }
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


#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setObject:self.strGqdm forKey:@"gqdm"];
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

    
	if (tag== kBusinessTagGetJRDetail) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            [self reloadDataWith:dataArray];
        }
    } else if (tag== kBusinessTagGetJRDetailAgain) {
        NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
        if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"获取数据异常处理"];
            //            subing = NO;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            // [self.view makeToast:@"登录成功!"];
            dicFirst = dataArray;
        }
    } else if (tag == kBusinessTagGetJRmyFavoritesDataadd){
        // NSMutableArray *dataArray = [jsonDic objectForKey:@"object"];
        
        if ([[jsonDic objectForKey:@"success"] boolValue] == 0) {
            //数据异常处理
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:[jsonDic objectForKey:@"msg"]];
           
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)hideMethods:(id)sender {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.logingUser.count > 0) {
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
    
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:[dicFirst  objectForKey:@"GQQC"] message:@"是否要进行收藏操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [outAlert show];
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setObject:[dicFirst objectForKey:@"CPMC"] forKey:@"cpmc"];
            [paraDic setObject:[dicFirst  objectForKey:@"GQDM"] forKey:@"cpdm"];
            [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRmyFavoritesDataadd owner:self];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        
    }
}


@end
