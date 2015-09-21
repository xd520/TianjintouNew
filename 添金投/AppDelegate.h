//
//  AppDelegate.h
//  添金投
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorUtil.h"
#import "MBProgressHUD.h"
#import "NetworkModule.h"
#import "Toast+UIView.h"
#import "SBJson.h"
#import "SRRefreshView.h"
#import "SHLUILabel.h"
#import "ASIHTTPRequest.h"
#import "OpenUDID.h"
#import "HMSegmentedControl.h"
#import "LogOutViewController.h"
#import "LoginViewController.h"
#import "Base64XD.h"

#define NUMBERS @"0123456789\n"
//#define SERVERURL @"http://192.168.1.110:8803"
//测试图片
//#define SERVERURL @"http://192.168.2.219:8080/account"
//天津投
//#define SERVERURL @"http://192.168.1.110:8805"
//天津投生产环境
#define SERVERURL @"http://www.tjtou.cn"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSMutableDictionary *dic;
@property (strong, nonatomic)NSString *strVC;
//从哪登录的
@property (strong, nonatomic)NSString *strlogin;

@property (strong, nonatomic) NSMutableDictionary *logingUser;
@property (strong, nonatomic)UITabBarController *tabBarController;


@end

