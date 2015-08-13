//
//  FriendsViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "FriendsViewController.h"
#import "AppDelegate.h"

@interface FriendsViewController ()
{
    float addHight;
}
@end

@implementation FriendsViewController

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
    
    _imgView.frame = CGRectMake((ScreenWidth - 120)/2, 106 + addHight, 120, 120);
    
    
    
    [self requestCategoryList];
}

//获取验证图形
- (void)requestCategoryList
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/recommend/QRCode",SERVERURL]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];//创建数据请求对象
    [request setRequestMethod:@"POST"];
    //[requestReport setPostValue:[delegate.dic objectForKey:@"username"] forKey:@"username"];
    [request setPostValue:@"120" forKey:@"width"];
    [request setPostValue:@"120" forKey:@"height"];
    
    [request setTimeOutSeconds:5];
    [request setDelegate:self];//设置代理
    [request startAsynchronous];//发送异步请求
    
    //设置网络请求完成后调用的block
    [request setCompletionBlock:^{
        
        //         NSLog(@"%@",request.responseHeaders);
        
        //NSData *data = request.responseData;
        self.imgView.image = [UIImage imageWithData:request.responseData];
        
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
