//
//  WebDetailViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-23.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "WebDetailViewController.h"
#import "AppDelegate.h"
#import "MddDownLoadTask.h"

@interface WebDetailViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation WebDetailViewController

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
    
    _titleLab.text = _name;
    
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    
    
    
    //添加指示器及遮罩
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/info/detail?id=%@&&classId=999",SERVERURL,_Id]];
         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/website/infonews/appDetail?id=%@",SERVERURL,_Id]];
        
       // /page/website/infonews/detail?id=560
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:request];
       // [_webView loadHTMLString:<#(nonnull NSString *)#> baseURL:request];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"%@",request.URL);
    
    
    switch (navigationType)
    {
            //点击连接
        case UIWebViewNavigationTypeLinkClicked:
        {
            NSLog(@"clicked");
            
           
            //拷贝
            
            NSString *saveLocalPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
            
            NSString *documentPath = [saveLocalPath  stringByAppendingPathComponent:@"/txt.txt"];
            
            
            NSMutableDictionary * DownLoadParam=[NSMutableDictionary dictionary];
            
          
            [DownLoadParam setObject:documentPath forKey:@"saveAsFilePath"];
            [DownLoadParam setObject:request.URL forKey:@"downloadUrl"];
            
            MddDownLoadTask  * tDownLoadTask=[[MddDownLoadTask alloc] initWithDic:DownLoadParam];
            tDownLoadTask.mddDelegate=self;
            [tDownLoadTask runTask];
            
            
           // [self DownLoadFile:request.URL withpath:documentPath];
            }
            break;
            //提交表单
        case UIWebViewNavigationTypeFormSubmitted:
        {
            NSLog(@"submitted");
        }
        default:
            break;
    }
    
    
    
    return YES;
}


-(void) mddDownLoadErrorCallBack:(NSError *)pError{
    
    [self.view makeToast:@"下载失败!"];

}
//完成
-(void) mddDownLoadSuccessCallBack:(NSMutableDictionary *)pValue{

    [_webView goBack];
    
    [self.view makeToast:@"下载成功!"];
    NSLog(@"%@",pValue);

}



- (void) DownLoadFile:(NSURL *)url withpath:(NSString *)path{
    //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [self.view bringSubviewToFront:hud];
    //    hud.mode = MBProgressHUDModeIndeterminate;
    
    if(hud){
        [hud hide:YES];
        
    }
    
    hud.labelText = @"正在下载文档...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if(data!=nil&&data.length!=0){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *err = nil;
                
                hud.labelText = @"下载成功";
                [hud hide:YES afterDelay:0.5];
                
                if([data writeToFile:path options:NSDataWritingAtomic error:&err]){
                   // [self QuickLookDoc];
                    
                }
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"下载失败";
                [hud hide:YES afterDelay:0.5];
            });
        }
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
