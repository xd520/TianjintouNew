//
//  DelegateTodayViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-14.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DelegateTodayViewController : UIViewController<NetworkModuleDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
- (IBAction)back:(id)sender;

@end
