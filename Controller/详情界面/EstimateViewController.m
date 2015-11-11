//
//  EstimateViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "EstimateViewController.h"
#import "AppDelegate.h"
#import "ReadViewController.h"

@interface EstimateViewController ()
{
    MBProgressHUD *hud;
    NSString *filePath;
    
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
    
    _titleName.text = _name;
    
    
    //添加指示器及遮罩
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES; //加层阴影
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/introduction/introduction?gqdm=%@&&gqlb=%@",SERVERURL,_gqdm,_gqlb]];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/website/infonews/appDetail?id=%@",SERVERURL,_Id]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:request];
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
            
            NSArray *array = [self convertURLToArray:request.URL.absoluteString];
            
            [self suburlString:[array objectAtIndex:2]];
            
            
            NSLog(@"%@  %@",array,[self suburlString:[array objectAtIndex:2]]);
            
            // NSString *documentPath = [saveLocalPath  stringByAppendingPathComponent:@"pdf.pdf"];
            
            if ([[self suburlString:[array objectAtIndex:2]] isEqualToString:@"txt"]) {
                NSString* fileName = @"down_form.txt";
                NSString* documentPath = [saveLocalPath stringByAppendingPathComponent:fileName];
                filePath = documentPath;
            } else if ([[self suburlString:[array objectAtIndex:2]] isEqualToString:@"pdf"]){
                
                NSString* fileName = @"down_form.pdf";
                NSString* documentPath = [saveLocalPath stringByAppendingPathComponent:fileName];
                filePath = documentPath;
            }
            
            
            //添加指示器及遮罩
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES; //加层阴影
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"正在下载中...";
            
            
            NSMutableDictionary * DownLoadParam=[NSMutableDictionary dictionary];
            
            
            [DownLoadParam setObject:filePath forKey:@"saveAsFilePath"];
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



- (NSArray *)convertURLToArray:(NSString *)string{
    if([string rangeOfString:@"?"].length != 0){
        NSInteger i = [string rangeOfString:@"?"].location;
        NSString *newString = [string substringFromIndex:i+1];
        return [newString componentsSeparatedByString:@"&"];
    }
    else{
        return  nil;
    }
}


//将?后面的字符串截掉
- (NSString *)suburlString:(NSString *)urlString{
    
    //return  [urlString substringFromIndex:[urlString rangeOfString:@"="].location + 1];
    
    return [urlString substringFromIndex:urlString.length - 3];
    
}


-(void) mddDownLoadErrorCallBack:(NSError *)pError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.view makeToast:@"下载失败!"];
    
}
//完成
-(void) mddDownLoadSuccessCallBack:(NSMutableDictionary *)pValue{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[_webView goBack];
    //[self.view makeToast:@"下载成功!"];
    NSLog(@"%@",pValue);
    
    //[[CustomCookieStorage sharedHTTPCookieStorage] cookiesForURL:[pValue valueForKey:@"downloadUrl"]];
    
    
    
    //    QLPreviewController *vc = [[QLPreviewController alloc] init];
    //    vc.delegate = self;
    //    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    
    
    // [documentController presentPreviewAnimated:YES];
    
    
    
    ReadViewController *vc = [[ReadViewController alloc] init];
    vc.path = filePath;
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
