//
//  AccountInfoViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AppDelegate.h"
#import "BindCardViewController.h"
#import "UnBindCardViewController.h"
#import "NoBindCardViewController.h"

@interface AccountInfoViewController ()
{
    UIScrollView *scrollView;
    NSMutableDictionary *dic;
    float addHight;
}
@end

@implementation AccountInfoViewController

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
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
         [self requestLogin:kBusinessTagGetJRupdateUserInfoAgain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}


-(void)reloadDataWith:(NSMutableDictionary *)dictiongary{
    dic = dictiongary;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 150)];
    baseView.backgroundColor = [UIColor whiteColor];
//    baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    baseView.layer.borderWidth = 1;
//    
//    baseView.layer.masksToBounds = YES;
//    
//    baseView.layer.cornerRadius = 4;
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 30, 1)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [baseView addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, ScreenWidth - 30, 1)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [baseView addSubview:lineView];
    
    NSArray *titleArr = @[@"真实姓名",@"身份证号",@"手机号码"];
    NSRange range,range1;
    NSString *strZJBH;
    if ([dictiongary objectForKey:@"FID_ZJBH"] == [NSNull null]){
        strZJBH = @"";
    }else {
        
        range.length = [[dictiongary objectForKey:@"FID_ZJBH"] length] - 10;
        range.location = 6;
        strZJBH  = [[dictiongary objectForKey:@"FID_ZJBH"] stringByReplacingCharactersInRange:range withString:@"******"];
    }
    
    
    
    NSString *strPhoneNum = [dictiongary objectForKey:@"MOBILEPHONE"];
    range1.length = strPhoneNum.length - 7;
    range1.location = 3;
    
    
    NSString *sr;
    NSRange range2;
    if ([dictiongary objectForKey:@"KHXM"] == [NSNull null]) {
        sr = @"**";
    } else {
        
        NSString *string = [dictiongary objectForKey:@"KHXM"];
        
        
        range2.length = [string length] - 1;
        range2.location = 0;
        sr = [string stringByReplacingCharactersInRange:range2 withString:@"**"];
    }
    
    
    
    NSArray *realArr = @[sr,strZJBH,[strPhoneNum stringByReplacingCharactersInRange:range1 withString:@"****"]];
    for (int i = 0; i < 3; i++) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 50*i + 17, 100, 15)];
        lab.text = [titleArr objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:15];
        
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        lab.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:lab];
        
        
        UILabel *labReal = [[UILabel alloc] initWithFrame:CGRectMake(120 , 50*i + 17, ScreenWidth - 10 - 110 -10, 15)];
        labReal.text = [realArr objectAtIndex:i];
        labReal.font = [UIFont systemFontOfSize:15];
        
        lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        labReal.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:labReal];
        
    }
    
    [scrollView addSubview:baseView];
    //交易账户
    UILabel *buyTip = [[UILabel alloc] initWithFrame:CGRectMake(10 , 155 + 17.5, 60, 15)];
    buyTip.text = @"交易账户";
    buyTip.backgroundColor = [UIColor clearColor];
    buyTip.font = [UIFont systemFontOfSize:15];
    
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    buyTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    buyTip.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:buyTip];
    
    UILabel *litterLab = [[UILabel alloc] initWithFrame:CGRectMake(75 ,155 + 19 , ScreenWidth - 80, 12)];
    litterLab.text = @"下列信息可提供给银行绑定银行账户";
    litterLab.font = [UIFont systemFontOfSize:12];
    litterLab.backgroundColor = [UIColor clearColor];
    
    litterLab.textColor = [ColorUtil colorWithHexString:@"999999"];
    litterLab.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:litterLab];
    
    //
    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(0, 205, ScreenWidth, 100)];
    base.backgroundColor = [UIColor whiteColor];
//    base.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    base.layer.borderWidth = 1;
//    
//    base.layer.masksToBounds = YES;
//    
//    base.layer.cornerRadius = 4;
    
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth - 30, 1)];
    lineV.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    [base addSubview:lineV];
    
    NSArray *arr = @[@"客户号",@"交易资金帐号"];
    NSString *khhStr,*zjzhStr;
    if (dictiongary.count > 0) {
        
        if ([dictiongary  objectForKey:@"FID_KHH"] == [NSNull null]) {
            khhStr = @"";
        } else {
            khhStr = [dictiongary  objectForKey:@"FID_KHH"];
        }
        
        if ([dictiongary  objectForKey:@"FID_ZJZH"] == [NSNull null]) {
            zjzhStr = @"";
        } else {
            zjzhStr = [dictiongary  objectForKey:@"FID_ZJZH"];
        }
        
    } else {
        
        khhStr = @"";
        zjzhStr = @"";
    }
    
    NSArray *vauleArr = @[khhStr,zjzhStr];
    for (int i = 0; i < 2; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 50*i + 17, 100, 15)];
        lab.text = [arr objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:15];
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        lab.textColor = [ColorUtil colorWithHexString:@"999999"];
        lab.textAlignment = NSTextAlignmentLeft;
        [base addSubview:lab];
        
        
        UILabel *labReal = [[UILabel alloc] initWithFrame:CGRectMake(120 , 50*i + 17, ScreenWidth - 10 - 110 -10, 15)];
        labReal.text = [vauleArr objectAtIndex:i];
        labReal.font = [UIFont systemFontOfSize:15];
        
        lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        labReal.textAlignment = NSTextAlignmentRight;
        [base addSubview:labReal];
        
        
        
    }
    [scrollView addSubview:base];
    
    
    //银行账户
    UILabel *accountTip = [[UILabel alloc] initWithFrame:CGRectMake(10 , 305 + 17.5, 60, 15)];
    accountTip.text = @"银行账户";
    accountTip.font = [UIFont systemFontOfSize:15];
    accountTip.backgroundColor = [UIColor clearColor];
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    accountTip.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    accountTip.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:accountTip];
    
    
// 尚未绑定银行账户
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[delegate.dictionary objectForKey:@"isBingingCard"] boolValue] == NO) {
    
    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 355, ScreenWidth , 50)];
    lastView.backgroundColor = [UIColor whiteColor];
//    lastView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    
//    lastView.layer.borderWidth = 1;
//    
//    lastView.layer.masksToBounds = YES;
//    
//    lastView.layer.cornerRadius = 4;

    
    UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    tipImg.image = [UIImage imageNamed:@"icon_nof2"];
    [lastView addSubview:tipImg];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(40 ,17.5, 150, 15)];
    accountLabel.text = @"尚未绑定银行帐号";
    accountLabel.font = [UIFont systemFontOfSize:15];
    
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    accountLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    accountLabel.textAlignment = NSTextAlignmentLeft;
    [lastView addSubview:accountLabel];
    lastView.userInteractionEnabled = YES;
    
     tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 30, 15, 20, 20)];
    tipImg.image = [UIImage imageNamed:@"next"];
    //[lastView addSubview:tipImg];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    lastView.tag = 0;
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    //[lastView addGestureRecognizer:singleTap1];
    [scrollView addSubview:lastView];
    [scrollView setContentSize:CGSizeMake(ScreenWidth, 410)];
    
    } else {
        
        UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 354, ScreenWidth, 50)];
        nameView.backgroundColor = [UIColor whiteColor];
//        nameView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        
//        nameView.layer.borderWidth = 1;
//        
//        nameView.layer.masksToBounds = YES;
//        
//        nameView.layer.cornerRadius = 4;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 ,17.5, 100, 15)];
        nameLabel.text = @"开户银行";
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameView addSubview:nameLabel];
        
        UILabel *vauleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 ,17.5, ScreenWidth - 20 - 110, 15)];
        if ([[_dicData objectForKey:@"FID_YHDM"] isEqualToString:@"JSYH"]) {
             vauleLabel.text = @"建设银行";
        } else if ([[_dicData  objectForKey:@"FID_YHDM"] isEqualToString:@"XYYH"]) {
        
         vauleLabel.text = @"兴业银行";
        
        } else {
        
         vauleLabel.text = @"其他银行";
        }
        
       
        vauleLabel.font = [UIFont systemFontOfSize:15];
        vauleLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
        vauleLabel.textAlignment = NSTextAlignmentRight;
        [nameView addSubview:vauleLabel];
         [scrollView addSubview:nameView];
        
        
    
        UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 405, ScreenWidth, 50)];
        lastView.backgroundColor = [UIColor whiteColor];
//        lastView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        
//        lastView.layer.borderWidth = 1;
//        
//        lastView.layer.masksToBounds = YES;
//        
//        lastView.layer.cornerRadius = 4;
        
        
        UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 ,17.5, 110, 15)];
        accountLabel.text = @"银行卡号";
        accountLabel.font = [UIFont systemFontOfSize:15];
        
        accountLabel.textColor = [ColorUtil colorWithHexString:@"999999"];
        
        accountLabel.textAlignment = NSTextAlignmentLeft;
        [lastView addSubview:accountLabel];
        lastView.userInteractionEnabled = YES;
        
        UILabel *cardBandLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 ,17.5, ScreenWidth - 20 - 110, 15)];
        
        NSString *string =[[_dicData objectForKey:@"FID_YHZH"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSRange range;
        NSString *strZJBH;
        
        range.length = [string length] - 9;
        range.location = 5;
        strZJBH  = [string stringByReplacingCharactersInRange:range withString:@"******"];
        
        
        cardBandLabel.text = strZJBH;
        cardBandLabel.font = [UIFont systemFontOfSize:15];
        
        cardBandLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        
        cardBandLabel.textAlignment = NSTextAlignmentRight;
        [lastView addSubview:cardBandLabel];
        
        
       
       /*
        //是否允许线上解绑
        if ([[_dicData objectForKey:@"FID_ZQYW"] isEqualToString:@"16"]) {
            
            UILabel *cardBandLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 ,17.5, ScreenWidth - 20 - 110 - 20, 15)];
            cardBandLabel.text = [_dicData objectForKey:@"FID_YHZH"];
            cardBandLabel.font = [UIFont systemFontOfSize:15];
            
            cardBandLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
            
            cardBandLabel.textAlignment = NSTextAlignmentRight;
            [lastView addSubview:cardBandLabel];
            
            
            
            UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 30, 15, 20, 20)];
            tipImg.image = [UIImage imageNamed:@"next"];
            [lastView addSubview:tipImg];
            
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            lastView.tag = 1;
            //单点触摸
            singleTap1.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap1.numberOfTapsRequired = 1;
            [lastView addGestureRecognizer:singleTap1];
        } else {
        
            UILabel *cardBandLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 ,17.5, ScreenWidth - 20 - 110, 15)];
            cardBandLabel.text = [_dicData objectForKey:@"FID_YHZH"];
            cardBandLabel.font = [UIFont systemFontOfSize:15];
            
            cardBandLabel.textColor = [ColorUtil colorWithHexString:@"333333"];
            
            cardBandLabel.textAlignment = NSTextAlignmentRight;
            [lastView addSubview:cardBandLabel];
        
        
        }
        */
     
        [scrollView addSubview:lastView];
        [scrollView setContentSize:CGSizeMake(ScreenWidth, 460)];
        
    
    }
    //[scrollView setContentSize:CGSizeMake(ScreenWidth, 410)];

}

- (IBAction)callPhone:(UITouch *)sender
{
     UIView *view = [sender view];
    if (view.tag == 0) {
        
    if ([dic objectForKey:@"name"] == [NSNull null]){
        [self.view makeToast:@"请先完善我的资料" duration:2 position:@"center"];
    } else {
      
        BindCardViewController *vc = [[BindCardViewController alloc] init];
        vc.dic = dic;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
   
        }
    } else if (view.tag == 1) {
    
    UnBindCardViewController *vc = [[UnBindCardViewController alloc] init];
       // vc.dic = dic;
        vc.cardBankStr = [_dicData objectForKey:@"yhzhEncode"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Request Methods
//请求登陆
- (void)requestLogin:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求登陆");
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
}

#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
    NSMutableDictionary *jsonDic = [result JSONValue];
    
	if (tag== kBusinessTagGetJRupdateUserInfoAgain) {
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
@end
