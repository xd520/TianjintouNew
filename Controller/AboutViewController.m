//
//  AboutViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"

@interface AboutViewController ()
{
    float addHight;
    
}
@end

@implementation AboutViewController

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
    
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 263 +addHight + 40*i, ScreenWidth, 1)];
        lineView.backgroundColor = [ColorUtil colorWithHexString:@"eeeeee"];
        [self.view addSubview:lineView];
    }
    
    _imgView.frame = CGRectMake((ScreenWidth - 80)/2, 20, 80, 80);
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    _versonLab.text = [NSString stringWithFormat:@"添金投:v%@",currentVersion];
    
    
    UILabel *lablast = [[UILabel alloc] initWithFrame:CGRectMake(15, ScreenHeight -25 - 14, ScreenWidth - 30, 13)];
    lablast.text = @"津ICP备08102316号";
    lablast.textAlignment = NSTextAlignmentCenter;
    lablast.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lablast];
    
    
    
    UILabel *lab= [[UILabel alloc] initWithFrame:CGRectMake(10, ScreenHeight -30 - 28, ScreenWidth - 20, 12)];
    lab.text = @"版权所有 © 天津股权交易所";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:lab];
    

    
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
