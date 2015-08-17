//
//  EstimateViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "EstimateViewController.h"
#import "AppDelegate.h"

@interface EstimateViewController ()
{
 
    float addHight;
}
@end

@implementation EstimateViewController

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
    
    //添加指示器及遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/introduction/introduction?gqdm=%@&&gqlb=%@",SERVERURL,_gqdm,_gqlb]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    

    
   
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


/*
-(void)udateUIDeafualt {
    if (self.dic.count > 0) {
        int line = 1;
        int juli = 5;
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSArray *titleArr = @[@"产品名称",@"产品代码",@"发行总规模",@"期限",@"起购金额",@"预期年化",@"起息时间",@"兑付时间",@"取现到账"];
        NSArray *arr = @[[_dic objectForKey:@"CPMC"],[_dic objectForKey:@"GQDM"],[NSString stringWithFormat:@"%@元",[self AddComma:[numberFormatter stringFromNumber:[_dic objectForKey:@"ZGB"]]]],[NSString stringWithFormat:@"%@天",[_dic objectForKey:@"QX"]],[NSString stringWithFormat:@"%@",[_dic objectForKey:@"TZJD"]],[_dic objectForKey:@"SYL"],[_dic objectForKey:@"FID_JXRQ"],[_dic objectForKey:@"DQRQ"],[_dic objectForKey:@"FXMS"]];
    for (int i = 0; i < titleArr.count; i++) {
        if (i < 2) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, juli + i*line + i*40, ScreenWidth - 10, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 12.5, 80, 15)];
            lab.text = [titleArr objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = [ColorUtil colorWithHexString:@"999999"];
            [view addSubview:lab];
            
            UILabel *labTip = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, ScreenWidth - 10 - 90, 40)];
            labTip.text = [arr objectAtIndex:i];
            labTip.textAlignment = NSTextAlignmentRight;
            labTip.font = [UIFont systemFontOfSize:14];
            labTip.numberOfLines = 0;
            labTip.textColor = [ColorUtil colorWithHexString:@"333333"];
            [view addSubview:labTip];
            
            [scrollView addSubview:view];
            
            
        } else if (i < 5&& i >= 2){
        
          UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, juli*2 + i*line + i*40, ScreenWidth - 10, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 12.5, 80, 15)];
            lab.text = [titleArr objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = [ColorUtil colorWithHexString:@"999999"];
            [view addSubview:lab];
            
            UILabel *labTip = [[UILabel alloc] initWithFrame:CGRectMake(85, 12.5, ScreenWidth - 10 - 90, 15)];
            labTip.text = [arr objectAtIndex:i];
            labTip.textAlignment = NSTextAlignmentRight;
            labTip.font = [UIFont systemFontOfSize:15];
            labTip.textColor = [ColorUtil colorWithHexString:@"333333"];
            [view addSubview:labTip];
            
            [scrollView addSubview:view];
            
        
        } else if (i >= 5&&i<9) {
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, juli*3 + i*line + i*40, ScreenWidth - 10, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 12.5, 80, 15)];
            lab.text = [titleArr objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = [ColorUtil colorWithHexString:@"999999"];
            [view addSubview:lab];
            
            UILabel *labTip = [[UILabel alloc] initWithFrame:CGRectMake(85, 12.5, ScreenWidth - 10 - 90, 15)];
            labTip.text = [arr objectAtIndex:i];
            labTip.textAlignment = NSTextAlignmentRight;
            labTip.font = [UIFont systemFontOfSize:15];
            labTip.textColor = [ColorUtil colorWithHexString:@"333333"];
            [view addSubview:labTip];
            
            [scrollView addSubview:view];

        
        
        }else if (i >= 9 &&i < 11){
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, juli*4 + i*line + i*40, ScreenWidth - 10, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 12.5, 80, 15)];
            lab.text = [titleArr objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = [ColorUtil colorWithHexString:@"999999"];
            [view addSubview:lab];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 35, 7.5, 25, 25)];
            icon.image = [UIImage imageNamed:@"next"];
            [view addSubview:icon];
            [scrollView addSubview:view];

            
            
            
        } else if (i == 11){
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, juli*5 + i*line + i*40, ScreenWidth - 10, 40)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 12.5, 120, 15)];
            lab.text = [titleArr objectAtIndex:i];
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = [ColorUtil colorWithHexString:@"999999"];
            [view addSubview:lab];
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 35, 7.5, 25, 25)];
            icon.image = [UIImage imageNamed:@"next"];
            [view addSubview:icon];
            
            [scrollView addSubview:view];
        
        }
    }
    

 [scrollView setContentSize:CGSizeMake(ScreenWidth, juli*5 + 12*line + 9*40)];
    }
}

*/



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
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    // webView 的缓存处理
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
