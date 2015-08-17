//
//  ProductDetailViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

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
    
    [self reloadViewUIData];
}


-(void)reloadViewUIData {
    if (_dic.count != 0) {
    self.productName.text = [NSString stringWithFormat:@"%@元",[_dic objectForKey:@"CPMC"]];
    self.priceGive.text = [NSString stringWithFormat:@"%@元",[_dic objectForKey:@"JYXX"]];
    self.myLife.text = @"0.00";
    self.yearLL.text = [NSString stringWithFormat:@"%@元",[_dic objectForKey:@"SYL"]];
    self.addPrice.text = [NSString stringWithFormat:@"%@元",[_dic objectForKey:@"DZJE"]];
    self.nextDate.text = [NSString stringWithFormat:@"%@元",[_dic objectForKey:@"DQRQ"]];
    
    _timeTouzi.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _timeTouzi.layer.borderWidth = 1;
    
    _timeTouzi.layer.masksToBounds = YES;
    
    _timeTouzi.layer.cornerRadius = 15;
    
    [_timeTouzi setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    }
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

- (IBAction)timeTouziMethods:(id)sender {
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
