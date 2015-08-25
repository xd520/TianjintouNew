//
//  TransferViewCtrl.m
//  添金投
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "TransferViewCtrl.h"
#import "AccountInfoViewController.h"
#import "MoneyAccountViewController.h"
#import "MyGainViewController.h"
#import "MyBuyViewController.h"
#import "BussizeDetailViewController.h"
#import "MoneyInfoViewController.h"
#import "TradingAccountViewController.h"
#import "RechargeFirstViewController.h"
#import "WithdrawFirstViewController.h"
#import "BindCardViewController.h"
#import "DelegateTodayViewController.h"
#import "PassWordMangerViewController.h"
#import "HideViewController.h"
#import "MyMoneyViewController.h"
#import "AddWithdrawViewController.h"
#import "WithdrawViewController.h"
#import "RechargeViewController.h"
#import "AddRechargeViewController.h"
#import "LoginPassWordViewController.h"

@interface TransferViewCtrl ()
{
    UIScrollView *scrollView;
    
    UILabel *total;
    UILabel * incomeLab;
    UILabel *accumulatedLab;
    UILabel *nameTitle;
    
    int hasMore;
    float addHight;
    
     float sizeScaleX;
    UIImageView *headerImgView;
    
    
    int count;
}
@end

@implementation TransferViewCtrl


CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    float autoSizeScaleX;
    
    if(ScreenWidth > 320){
        
        autoSizeScaleX = ScreenWidth/320;
        
        
    }else{
        autoSizeScaleX = 1.0;
    }
    
    
    
    CGRect rect;
    rect.origin.x = x * autoSizeScaleX; rect.origin.y = y * autoSizeScaleX;
    rect.size.width = width * autoSizeScaleX;
    rect.size.height = height * autoSizeScaleX;
    return rect;
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (count == 1) {
        [self getUIFirst];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    hasMore = 0 ;
    count = 1;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    
    if(ScreenWidth > 320){
        sizeScaleX = ScreenWidth/320;
    }else{
        sizeScaleX = 1.0;
    }

    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  addHight, ScreenWidth, ScreenHeight - 49 - 20)];
    scrollView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
    
    UIImageView *baseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 175*sizeScaleX)];
    baseImage.image = [UIImage imageNamed:@"ninhao_bg"];
    baseImage.userInteractionEnabled = YES;
   
  
    nameTitle = [[UILabel alloc] initWithFrame:CGRectMake1(50, 13, 320 - 100, 17)];
    nameTitle.text = @"我的账户";
    nameTitle.backgroundColor = [UIColor clearColor];
    nameTitle.textAlignment = NSTextAlignmentCenter;
    nameTitle.textColor = [UIColor whiteColor];
    nameTitle.font = [UIFont systemFontOfSize:16*sizeScaleX];
    [baseImage addSubview:nameTitle];
    
    
    UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userBtn.frame = CGRectMake1(320 - 70, 11, 60, 22);
    // [userBtn setBackgroundImage:[UIImage imageNamed:@"my_info"] forState:UIControlStateNormal];
    [userBtn setTitle:@"账户信息" forState:UIControlStateNormal];
    [userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    userBtn.titleLabel.font = [UIFont systemFontOfSize:13*sizeScaleX];
    
    [userBtn addTarget:self action:@selector(pushToUserInfoVC) forControlEvents:UIControlEventTouchUpInside];
    baseImage.userInteractionEnabled = YES;
    [baseImage addSubview:userBtn];
    
    
    // scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    
    //scrollView.autoresizesSubviews = YES;
    //scrollView.bounces = YES;
    //[scrollView sizeToFit];
    // [scrollView sizeThatFits:CGSizeMake(44 + addHight,ScreenHeight - 49 - 64)];
    /*
     UIViewAutoresizingNone                 = 0,
     UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
     UIViewAutoresizingFlexibleWidth        = 1 << 1,
     UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
     UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
     UIViewAutoresizingFlexibleHeight       = 1 << 4,
     UIViewAutoresizingFlexibleBottomMargin
     */
    //
    
    
   // UIImageView *baseImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
   // baseImage1.image = [UIImage imageNamed:@"title_bg"];
    
    
    UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake1(0, 34, 320,60/19*32)];
    tipImg.image = [UIImage imageNamed:@"ninhao"];
    [baseImage addSubview:tipImg];
    
    
    
    
   headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake1(120, 8,80, 80)];
    headerImgView.backgroundColor = [UIColor redColor];
  
    headerImgView.layer.cornerRadius = headerImgView.frame.size.width / 2;
    headerImgView.clipsToBounds = YES;
    headerImgView.layer.borderWidth = 3.0f;
    headerImgView.layer.borderColor = [ColorUtil colorWithHexString:@"eeeeee"].CGColor;
    
    [tipImg addSubview:headerImgView];
    
    
    
    
    
    
    
    //今日收益
    accumulatedLab = [[UILabel alloc] initWithFrame:CGRectMake1(20, 58, (320 - 20)/2, 14)];
    // accumulatedLab.textAlignment = NSTextAlignmentCenter;
    accumulatedLab.font = [UIFont systemFontOfSize:14*sizeScaleX];
    accumulatedLab.textColor = [UIColor whiteColor];
    accumulatedLab.backgroundColor = [UIColor clearColor];
    accumulatedLab.text = @"0.0";
    [tipImg addSubview:accumulatedLab];
    
    
    
    
    
    UILabel *incomeTip = [[UILabel alloc] initWithFrame:CGRectMake1(20, 37, (320 - 40)/2, 14)];
    incomeTip.font = [UIFont systemFontOfSize:13*sizeScaleX];
    //incomeTip.textAlignment = NSTextAlignmentCenter;
    incomeTip.textColor = [UIColor whiteColor];
    incomeTip.backgroundColor = [UIColor clearColor];
    incomeTip.text = @"累计已收益(元)";
    [tipImg addSubview:incomeTip];
    
    //累计收益
    incomeLab = [[UILabel alloc] initWithFrame:CGRectMake1(320/2 + 65, 58, (320 - 65)/2, 14)];
    //incomeLab.textAlignment = NSTextAlignmentCenter;
    incomeLab.font = [UIFont systemFontOfSize:14];
    incomeLab.textColor = [UIColor whiteColor];
    incomeLab.backgroundColor = [UIColor clearColor];
    incomeLab.text = @"0.0";
    [tipImg addSubview:incomeLab];
    
    UILabel *foodTip = [[UILabel alloc] initWithFrame:CGRectMake1(320/2 + 65, 37, (320 - 65)/2, 14)];
    foodTip.font = [UIFont systemFontOfSize:13*sizeScaleX];
    // foodTip.textAlignment = NSTextAlignmentCenter;
    foodTip.textColor = [UIColor whiteColor];
    foodTip.backgroundColor = [UIColor clearColor];
    foodTip.text = @"预期待收益(元)";
    [tipImg addSubview:foodTip];
    
   
    
    
    UILabel *totalTip = [[UILabel alloc] initWithFrame:CGRectMake1(80, 145 - 14 + 5, (320 - 160), 14)];
    totalTip.font = [UIFont systemFontOfSize:14*sizeScaleX];
    totalTip.textAlignment = NSTextAlignmentCenter;
    totalTip.backgroundColor = [UIColor clearColor];
    totalTip.textColor = [UIColor whiteColor];
    totalTip.text = @"我的总资产(元)";
    [baseImage addSubview:totalTip];
    
    //总资产
    total = [[UILabel alloc] initWithFrame:CGRectMake1(80, 145 - 14 + 5 + 15, 320 - 160, 15)];
    total.textAlignment = NSTextAlignmentCenter;
    total.font = [UIFont boldSystemFontOfSize:15*sizeScaleX];
    total.backgroundColor = [UIColor clearColor];
    total.textColor = [UIColor whiteColor];
    total.text = @"0.0";
    [baseImage addSubview:total];
    
    
     
    //提现
    UIButton *tixianBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    tixianBtn.frame = CGRectMake1(320 - 70, 145 - 14 + 5, 60, 30);
   
    
    UILabel *tipTXLabel = [[UILabel alloc] initWithFrame:CGRectMake1(15, 15/2, 30, 15)];
    tipTXLabel.font = [UIFont systemFontOfSize:15*sizeScaleX];
    //tipLabel.textAlignment = NSTextAlignmentRight;
    // tipTXLabel.textColor = [UIColor whiteColor];
    tipTXLabel.backgroundColor = [UIColor clearColor];
    tipTXLabel.text =  @"提现";
    tipTXLabel.textColor = [UIColor whiteColor];
    tipTXLabel.textAlignment = NSTextAlignmentRight;
    [tixianBtn addSubview:tipTXLabel];
    tixianBtn.backgroundColor = [ColorUtil colorWithHexString:@"f18101"];
    tixianBtn.layer.cornerRadius = 15*sizeScaleX;
    tixianBtn.layer.masksToBounds = YES;
    tixianBtn.tag = 1001;
    [tixianBtn addTarget:self action:@selector(getMoneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    [baseImage addSubview:tixianBtn];
    
    
    
    //充值
    UIButton *chongzhiBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhiBtn.frame = CGRectMake1(10, 145 - 14 + 5, 60, 30);
    
    UILabel *tipCZLabel = [[UILabel alloc] initWithFrame:CGRectMake1(15, 15/2, 30, 15)];
    tipCZLabel.font = [UIFont systemFontOfSize:15*sizeScaleX];
    tipCZLabel.textColor = [UIColor whiteColor];
    tipCZLabel.textAlignment = NSTextAlignmentRight;
    tipCZLabel.text =  @"充值";
    tipCZLabel.backgroundColor = [UIColor clearColor];
    [chongzhiBtn addSubview:tipCZLabel];
    chongzhiBtn.backgroundColor = [ColorUtil colorWithHexString:@"f18101"];
    
    chongzhiBtn.layer.cornerRadius = 15*sizeScaleX;
    chongzhiBtn.layer.masksToBounds = YES;
    
    chongzhiBtn.tag = 1002;
    [chongzhiBtn addTarget:self action:@selector(getMoneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    [baseImage addSubview:chongzhiBtn];
    
    [scrollView addSubview:baseImage];
    
    
    /*
     table = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth,430)];
     [table setDelegate:self];
     [table setDataSource:self];
     table.separatorStyle = UITableViewCellSeparatorStyleNone;
     [table setBackgroundColor:[ColorUtil colorWithHexString:@"eeeeee"]];
     table.tableFooterView = [[UIView alloc] init];
     [table setScrollEnabled:NO];
     [_scrollView addSubview:table];
     */
    
    
    
   // NSArray *arr = @[@"我的资产",@"当日申请",@"我的投资",@"我的已获收益",@"充值/提现记录",@"资金变动记录",@"账户安全",@"我的收藏",@"我的厦金币",@"邀请好友"];
    
    
    NSArray *arr = @[@"我的资产",@"当日申请",@"投资记录",@"我的收益",@"转账充值",@"资金变动",@"我的添金币",@"账户安全"];
    
    
    
    for (int i = 0; i < arr.count; i++) {
        
        if (i < 3) {
            
            UIView *oneView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 175*sizeScaleX + 5 + i*40, ScreenWidth, 40)];
            oneView1.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
            oneView1.userInteractionEnabled = YES;
            
            UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,13, 200, 14)];
            starLabel1.font = [UIFont systemFontOfSize:14];
            starLabel1.text = [arr objectAtIndex:i];
            starLabel1.textColor = [ColorUtil colorWithHexString:@"333333"];
            [oneView1 addSubview:starLabel1];
            //手机号码
            
            UIImageView *pushView1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 25, 10, 20, 20)];
            pushView1.image = [UIImage imageNamed:@"next_icon"];
            
            
            
            [oneView1 addSubview:pushView1];
            
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            oneView1.tag = i;
            //单点触摸
            singleTap1.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap1.numberOfTapsRequired = 1;
            [oneView1 addGestureRecognizer:singleTap1];
            
            [scrollView addSubview:oneView1];
            
            
        } else if (i < 6&&i>=3) {
            UIView *oneView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 307 - 175 + 175*sizeScaleX + (i - 3)*40, ScreenWidth, 40)];
            oneView1.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
            oneView1.userInteractionEnabled = YES;
            
            UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,13, 100, 14)];
            starLabel1.font = [UIFont systemFontOfSize:14];
            starLabel1.text = [arr objectAtIndex:i];
            starLabel1.textColor = [ColorUtil colorWithHexString:@"333333"];
            [oneView1 addSubview:starLabel1];
            
            UIImageView *pushView1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 25, 10, 20, 20)];
            pushView1.image = [UIImage imageNamed:@"next_icon"];
            
            
            
            
            [oneView1 addSubview:pushView1];
            
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            oneView1.tag = i;
            //单点触摸
            singleTap1.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap1.numberOfTapsRequired = 1;
            [oneView1 addGestureRecognizer:singleTap1];
            
            [scrollView addSubview:oneView1];
            
        } else {
            UIView *oneView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 435 - 175 + 175*sizeScaleX + (i - 6)*40, ScreenWidth, 40)];
            
            oneView1.backgroundColor = [ColorUtil colorWithHexString:@"fdfdfd"];
            oneView1.userInteractionEnabled = YES;
            
            UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,13, 100, 14)];
            starLabel1.font = [UIFont systemFontOfSize:14];
            starLabel1.text = [arr objectAtIndex:i];
            starLabel1.textColor = [ColorUtil colorWithHexString:@"333333"];
            [oneView1 addSubview:starLabel1];
            
            UIImageView *pushView1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 25, 10, 20, 20)];
            pushView1.image = [UIImage imageNamed:@"next_icon"];
            
            
            
            [oneView1 addSubview:pushView1];
            UITapGestureRecognizer *singleTap1;
            if (i == 9) {
                singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
                
            } else {
                singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            }
            oneView1.tag = i;
            //单点触摸
            singleTap1.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap1.numberOfTapsRequired = 1;
            [oneView1 addGestureRecognizer:singleTap1];
            
            [scrollView addSubview:oneView1];
            
        }
    }
    
    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0,5 + 175*sizeScaleX , ScreenWidth, 0.5)];
    lineView0.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    
    [scrollView addSubview:lineView0];
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,5 + 175*sizeScaleX  + 39.5, ScreenWidth - 10, 0.5)];
    lineView.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    
    [scrollView addSubview:lineView];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10,219 - 179 + 5 + 175*sizeScaleX  + 39.5, ScreenWidth - 10, 0.5)];
    lineView1.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    // lineView1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [scrollView addSubview:lineView1];
    
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0,5 + 175*sizeScaleX + 119.5, ScreenWidth, 0.5)];
    lineView2.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    
    [scrollView addSubview:lineView2];
    
    
    UIView *lineView21 = [[UIView alloc] initWithFrame:CGRectMake(0,307 - 179 + 5 + 175*sizeScaleX, ScreenWidth, 0.5)];
    lineView21.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    
    [scrollView addSubview:lineView21];
    
    
    UIView *lineView22 = [[UIView alloc] initWithFrame:CGRectMake(0,426.5 - - 179 + 5 + 175*sizeScaleX, ScreenWidth, 0.5)];
    lineView22.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    
    [scrollView addSubview:lineView22];
    
    
    
    
    
    UILabel *lineView3 = [[UILabel alloc] initWithFrame:CGRectMake(10,307 - 179 + 5 + 175*sizeScaleX + 39.5, ScreenWidth - 10, 0.5)];
    lineView3.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    
    [scrollView addSubview:lineView3];
    
    UILabel *lineView4 = [[UILabel alloc] initWithFrame:CGRectMake(10,347 - 179 + 5 + 175*sizeScaleX +39.5, ScreenWidth - 10, 0.5)];
    lineView4.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [scrollView addSubview:lineView4];
    
    
    
    
    
    UILabel *lineView6 = [[UILabel alloc] initWithFrame:CGRectMake(10,435 - 179 + 5 + 175*sizeScaleX + 39.5, ScreenWidth - 10, 0.5)];
    lineView6.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [scrollView addSubview:lineView6];
    
    
    UILabel *lineView7 = [[UILabel alloc] initWithFrame:CGRectMake(0,475 - 179 + 5 + 175*sizeScaleX + 39.5, ScreenWidth, 0.5)];
    lineView7.backgroundColor = [ColorUtil colorWithHexString:@"dedede"];
    [scrollView addSubview:lineView7];
    
    scrollView.bounces = NO;
    
     if(ScreenWidth > 320){
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - 20 - 49)];
     } else {
     
     [scrollView setContentSize:CGSizeMake(ScreenWidth, 600 - 82)];
     }
         
    [self.view addSubview:scrollView];
    
}

//获取验证图形
- (void)requestCategoryList:(NSString *)strUrl
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles?type=tx&id=%@&catch=false",SERVERURL,strUrl]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];//创建数据请求对象
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:5];
    [request setDelegate:self];//设置代理
    [request startAsynchronous];//发送异步请求
    
    //设置网络请求完成后调用的block
    [request setCompletionBlock:^{
        
        //         NSLog(@"%@",request.responseHeaders);
        
        //NSData *data = request.responseData;
       headerImgView.image = [UIImage imageWithData:request.responseData];
        
        //---------------判断数据的来源:网络 or缓存------------------
        if (request.didUseCachedResponse) {
            NSLog(@"数据来自缓存");
        } else {
            NSLog(@"数据来自网络");
        }
        
    }];
    
    //请求失败调用的block
    [request setFailedBlock:^{
        
        NSError *error = request.error;
        NSLog(@"请求网络出错：%@",error);
    }];
}



-(void)pushToUserInfoVC{
    
    // AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
    
    //获取银行卡信息
    [self requestLogin:kBusinessTagGetJRMyBankcard];
    
    //}else {
    //  [self.view makeToast:@"请先实名认证" duration:2 position:@"center"];
    //  }
    
    
    
}


- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
    if (view.tag == 0) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
            
            MoneyAccountViewController *cv = [[MoneyAccountViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            //cv.dic = dicBank;
            [self.navigationController pushViewController:cv animated:YES];
        }else {
            // [self.view makeToast:@"请先实名认证" duration:2 position:@"center"];
            
            LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] initWithNibName:@"LoginPassWordViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        
    } else if (view.tag == 1){
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
            
            DelegateTodayViewController *cv = [[DelegateTodayViewController alloc] init];
            
            // MyGainViewController *cv = [[MyGainViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }else {
            LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] initWithNibName:@"LoginPassWordViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (view.tag == 2){
        
        //DelegateTodayViewController *cv = [[DelegateTodayViewController alloc] init];
        
        MyGainViewController *cv = [[MyGainViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
        
        
    }else if (view.tag == 3){
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
            MyBuyViewController *cv = [[MyBuyViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }else {
            LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] initWithNibName:@"LoginPassWordViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (view.tag == 4){
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
            BussizeDetailViewController *cv = [[BussizeDetailViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        }else {
            LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] initWithNibName:@"LoginPassWordViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (view.tag == 5){
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
            
            MoneyInfoViewController *cv = [[MoneyInfoViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
        } else {
            
            LoginPassWordViewController *vc = [[LoginPassWordViewController alloc] initWithNibName:@"LoginPassWordViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (view.tag == 6){
        // AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        // if ([[delegate.dictionary objectForKey:@"isSetCert"] boolValue]) {
        
        MyMoneyViewController *cv = [[MyMoneyViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
        //} else {
        
        //[self.view makeToast:@"请先实名认证" duration:2 position:@"center"];
        // }
    } else if (view.tag == 7){
        
        
        PassWordMangerViewController *cv = [[PassWordMangerViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
        
    }
}

-(void)getUIFirst {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.logingUser.count > 0) {
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
            if (hasMore != 1&& hasMore == 0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.dimBackground = YES; //加层阴影
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"加载中...";
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    [self requestLogin:kBusinessTagGetJRMyzc];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                });
                
                
            }
            
            nameTitle.text = [[delegate.logingUser objectForKey:@"object"] objectForKey:@"username"];
           // [self requestCategoryList:<#(NSString *)#>]
            
        } else {
            
            //delegate.strlogin = @"1";
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
            // VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            //[self.navigationController presentModalViewController:VC animated:YES];
        }
        
    } else {
        // delegate.strlogin = @"1";
        LoginViewController *VC = [[LoginViewController alloc] init];
        
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
        
        //VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        // [self.navigationController presentModalViewController:VC animated:YES];
        
        
    }
    
}

-(void)getMoneyMethods:(UIButton *)sender {
    
    AppDelegate *deletate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[deletate.dictionary objectForKey:@"isSetCert"] boolValue]) {
        
        if ([[deletate.dictionary objectForKey:@"isBingingCard"] boolValue]) {
            if (sender.tag == 1001) {
                
                
                NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
                [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRapplyOutMoney owner:self];
                
            } else if (sender.tag == 1002){
                
                
                NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
                [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRapplyOutMoneyAgain owner:self];
            }
            
        } else {
            // NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            //[[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:kBusinessTagGetJRupdateUserInfo owner:self];
            [self.view makeToast:@"请先绑定银行卡" duration:2 position:@"center"];
        }
    } else {
        [self.view makeToast:@"请先实名认证" duration:2 position:@"center"];
        
    }
    
    
}


-(void)reloadDataWith:(NSMutableDictionary *)arraydata {
    
    //总资产
    
    if ([[arraydata objectForKey:@"zzc"] isEqualToString:@""]||[[arraydata objectForKey:@"zzc"] isEqualToString:@"0"]) {
        total.text = @"0.00";
    } else {
        NSString *strZzc = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"zzc"] doubleValue]];
        
        NSRange range1 = [strZzc rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range1));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string = [strZzc substringFromIndex:range1.location];
        
        NSString *str = [strZzc substringToIndex:range1.location];
        
        total.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
        
        
    }
    
    //incomeLab.text = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrZsz"] floatValue]];
    
    if ([[arraydata objectForKey:@"jrljdsy"] isEqualToString:@"0.0"]) {
        incomeLab.text = @"0.00";
    } else {
        
        NSString *strjrZsz = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljdsy"] doubleValue]];
        NSRange range3 = [strjrZsz rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range3));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string = [strjrZsz substringFromIndex:range3.location];
        
        NSString *str = [strjrZsz substringToIndex:range3.location];
        
        incomeLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
        
    }
    
    
    //累计收益
    
    //accumulatedLab.text = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] floatValue]];
    // accumulatedLab.text =[NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] floatValue]];
    
    if ([[arraydata objectForKey:@"jrljzsy"] isEqualToString:@"0"]) {
        accumulatedLab.text = @"0.00";
    } else {
        
        NSString *strrljzsy = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] doubleValue]];
        
        NSRange range = [strrljzsy rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string1 = [strrljzsy substringFromIndex:range.location];
        
        NSString *str1 = [strrljzsy substringToIndex:range.location];
        
        accumulatedLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str1],string1];
        
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
    if ([[jsonDic objectForKey:@"object"] isKindOfClass:[NSString class]]) {
        
        if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]&&[[jsonDic objectForKey:@"success"] boolValue] == NO) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.logingUser removeAllObjects];
            [delegate.dictionary removeAllObjects];
            [ASIHTTPRequest setSessionCookies:nil];
            LogOutViewController *cv = [[LogOutViewController alloc] init];
            cv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cv animated:YES];
            
        }
    }else {
        
        if (tag== kBusinessTagGetJRMyzc) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // [self.view makeToast:@"获取数据异常处理"];
                //            subing = NO;
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                // [self.view makeToast:@"登录成功!"];
                [self reloadDataWith:dataArray];
            }
        } else if (tag == kBusinessTagGetJRMyBankcard){
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                AccountInfoViewController *cv = [[AccountInfoViewController alloc] init];
                cv.dicData = @{};
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
                AccountInfoViewController *cv = [[AccountInfoViewController alloc] init];
                cv.dicData = [[jsonDic objectForKey:@"object"] objectAtIndex:0];
                cv.headImage = headerImgView.image;
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            }
            
        } else if (tag== kBusinessTagGetJRapplyOutMoney) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                
                TradingAccountViewController *cv = [[TradingAccountViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.strVC = @"2";
                
                if ([[[dataArray objectForKey:@"cgywcsResult"] objectForKey:@"FID_YHMMXY"] isEqualToString:@"2"]) {
                    
                    AddWithdrawViewController *vc = [[AddWithdrawViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                   // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//                    nav.delegate = self;
//                    nav.modalTransitionStyle = UIModalTransitionStyle;
//                    [self presentViewController:nav animated:YES completion:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    
                    WithdrawViewController *vc = [[WithdrawViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                   [self.navigationController pushViewController:vc animated:YES];
                    
                }
                
                
                /*
                 
                 WithdrawFirstViewController *cv = [[WithdrawFirstViewController alloc] init];
                 cv.dic = dataArray;
                 cv.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:cv animated:YES];
                 */
            }
        } else if (tag== kBusinessTagGetJRapplyOutMoneyAgain) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
                // [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:bankNumStr];
                //            subing = NO;
                
                TradingAccountViewController *cv = [[TradingAccountViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
                
                
                
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // [self.view makeToast:@"登录成功!"];
                //[self reloadDataWith:dataArray];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.strVC = @"2";
                /*
                 RechargeFirstViewController *cv = [[RechargeFirstViewController alloc] init];
                 cv.dic = dataArray;
                 cv.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:cv animated:YES];
                 */
                
                if ([[[dataArray objectForKey:@"cgywcsResult"] objectForKey:@"FID_YHMMXY"] isEqualToString:@"1"]) {
                    
                    AddRechargeViewController *vc = [[AddRechargeViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                    
                   [self.navigationController pushViewController:vc animated:YES];
                    
                    
                    
                } else {
                    
                    
                    
                    RechargeViewController *vc = [[RechargeViewController alloc] init];
                    
                    vc.hidesBottomBarWhenPushed = YES;
                    
                    vc.dic = dataArray;
                    
                   [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
        } else if (tag== kBusinessTagGetJRupdateUserInfo) {
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == YES) {
                //数据异常处理
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:bankNumStr];
                //            subing = NO;
                
                TradingAccountViewController *cv = [[TradingAccountViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
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
    if (tag==kBusinessTagGetJRMyzc) {
        hasMore = 1;
    }
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

-(void)dealloc {
    [scrollView removeFromSuperview];
    scrollView = nil;
    [total removeFromSuperview];
    total = nil;
    [incomeLab removeFromSuperview];
    incomeLab = nil;
    [accumulatedLab removeFromSuperview];
    accumulatedLab = nil;
    [nameTitle removeFromSuperview];
    nameTitle = nil;
    [headerImgView removeFromSuperview];
    headerImgView = nil;

}

@end
