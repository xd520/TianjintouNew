//
//  MyTransferSuccessViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-14.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyTransferSuccessViewController.h"
#import "MyTransferDetailViewController.h"

@interface MyTransferSuccessViewController ()

@end

@implementation MyTransferSuccessViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    UIViewController *vc = [array objectAtIndex:array.count-4];
    
    if ([vc.nibName isEqualToString:@"MoneyAccountViewController"]) {
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
        [array removeObjectAtIndex:array.count-1];
       
        [self.navigationController setViewControllers:array];
        
        
    }
    /*
    MyTransferDetailViewController *vc = [[MyTransferDetailViewController alloc] initWithNibName:@"MyTransferDetailViewController" bundle:nil];
    [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject],vc]];
    */
}
@end
