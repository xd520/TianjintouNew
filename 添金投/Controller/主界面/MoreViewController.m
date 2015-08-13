//
//  MoreViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "MessgeCenterViewController.h"
#import "PassWordMangerViewController.h"
#import "UserBackViewController.h"
#import "CheckVersonViewController.h"
#import "MyUserMangerViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PublicViewController.h"
#import "LogOutViewController.h"
#import "MyLabel.h"
#import "MyView.h"

@interface MoreViewController ()
{
    NSArray *array;
    NSArray *arrImage;
    UILabel *_longtime;
     UILabel *_longtime1;
}
@end

@implementation MoreViewController

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
    [self getUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
   [_table setScrollEnabled:NO];
   // array = @[@"信息公告",@"检查更新",@"关于我们"];
     array = @[@"信息公告",@"关于我们"];
   // arrImage = @[[UIImage imageNamed:@"icon_pwd"],[UIImage imageNamed:@"icon_update"],[UIImage imageNamed:@"我的客户经理"]];
    
    
    _logoutBtn.backgroundColor = [ColorUtil colorWithHexString:@"fe8103"];
    _logoutBtn.layer.cornerRadius = 4;
    _logoutBtn.layer.masksToBounds = YES;
    
    /*
    MyLabel *lab = [[MyLabel alloc] initWithFrame:CGRectMake(50, 200, 200, 40)];
    //lab.backgroundColor = [UIColor brownColor];
    lab.textColor = [UIColor blueColor];
    lab.text = @"You Are Sb!";
    [self.view addSubview:lab];
    
    MyView *view = [[MyView alloc] initWithFrame:CGRectMake(50, 200, 220, 100)];
    [self.view addSubview:view];
    */
    
    
   }

-(void)getUI{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.logingUser.count > 0) {
        if ([[delegate.logingUser objectForKey:@"success"] boolValue] == YES) {
            _logoutBtn.hidden = NO;
        }else {
            
            _logoutBtn.hidden = YES;
        }
    }else {
        _logoutBtn.hidden = YES;
        
    }


}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
   
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepairCellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    //cell.imageView.image = [arrImage objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 35, 10, 20, 20)];
    img.image = [UIImage imageNamed:@"next_icon"];
    [cell addSubview:img];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
    [subView setBackgroundColor:[ColorUtil colorWithHexString:@"dcdcdc"]];
    //if ([indexPath row] != 2) {
        [cell.contentView addSubview:subView];
    //}

    
    /*
     UITableViewCellSelectionStyleNone,
     UITableViewCellSelectionStyleBlue,
     UITableViewCellSelectionStyleGray,
     UITableViewCellSelectionStyleDefault
     
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
//    NSLog(@"select:%ld", indexPath.row);
    
       
    if (indexPath.row == 0) {
        PublicViewController *cv = [[PublicViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    }else if (indexPath.row == 2) {
        
        [self onCheckVersion];
        
//        CheckVersonViewController *cv = [[CheckVersonViewController alloc] init];
//        cv.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:cv animated:YES];
    }else if (indexPath.row == 1) {
        AboutViewController *cv = [[AboutViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    }else if (indexPath.row == 5) {
        UserBackViewController *cv = [[UserBackViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    }else if (indexPath.row == 4) {
        MyUserMangerViewController *cv = [[MyUserMangerViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    } else  if (indexPath.row == 3) {
        MessgeCenterViewController *cv = [[MessgeCenterViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}



-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
   
     NSString *URL = @"http://itunes.apple.com/lookup?id=1002325180";
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setURL:[NSURL URLWithString:URL]];
     [request setHTTPMethod:@"POST"];
     NSHTTPURLResponse *urlResponse = nil;
     NSError *error = nil;
     NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
     
     NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
     NSDictionary *dic = [results JSONValue];
     NSArray *infoArray = [dic objectForKey:@"results"];
     if ([infoArray count]) {
     NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
     NSString *lastVersion = [releaseInfo objectForKey:@"version"];
     
    if (![lastVersion isEqualToString:currentVersion]) {
        //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
        alert.tag = 10000;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 10001;
        [alert show];
        }
     } else {
     
         [self.view makeToast:@"还没上架，请延后" duration:2 position:@"center"];
     }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutBtn:(id)sender {
  
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"注销" message:@"是否要退出该帐号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = 10003;
    [outAlert show];
   
    
   
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    } else if (alertView.tag==10003){
        
    if (buttonIndex != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES; //加层阴影
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self requestCategoryList:kBusinessTagGetJRLogout];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
        
        }
    }
}

//获取品牌列表
- (void)requestCategoryList:(kBusinessTag)_tag
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"请求品牌列表");
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [[NetworkModule sharedNetworkModule] postBusinessReqWithParamters:paraDic tag:_tag owner:self];
    
}




#pragma mark - NetworkModuleDelegate Methods
-(void)beginPost:(kBusinessTag)tag{
    
}
-(void)endPost:(NSString *)result business:(kBusinessTag)tag{
    NSLog(@"%s %d 收到数据:%@", __FUNCTION__, __LINE__, result);
     NSMutableDictionary *jsonDic = [result JSONValue];
	if (tag==kBusinessTagGetJRLogout) {
       
            NSMutableDictionary *dataArray = [jsonDic objectForKey:@"object"];
            if ([[jsonDic objectForKey:@"success"] boolValue] == NO) {
                //数据异常处理
               
                if ([[jsonDic objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                  
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.logingUser removeAllObjects];
                    [delegate.dictionary removeAllObjects];
                    [ASIHTTPRequest setSessionCookies:nil];
                    LogOutViewController *cv = [[LogOutViewController alloc] init];
                    cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                } else {
                
                
                [self.view makeToast:@"注销失败"];
                }
            } else {
                
                _logoutBtn.hidden = YES;
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.logingUser removeAllObjects];
                [self.view makeToast:@"注销成功"];
                 delegate.strlogin = @"0";
                }
            }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] cancel:tag];
}
-(void)errorPost:(NSError *)err business:(kBusinessTag)tag{
    NSLog(@"%s Error:%@", __FUNCTION__, @"连接数据服务器超时");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法连接" message:@"您所在地的网络信号微弱，无法连接到服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
   // if (tag == kBusinessTagGetLogOut) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //}
    [[NetworkModule sharedNetworkModule] cancel:tag];
}




- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
