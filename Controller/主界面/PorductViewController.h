//
//  PorductViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PorductViewController : UIViewController <MBProgressHUDDelegate,NetworkModuleDelegate,SRRefreshDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)transVC:(id)sender;
- (IBAction)back:(id)sender;

@end
