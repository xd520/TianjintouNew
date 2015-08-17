//
//  TransferViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TransferViewController : UIViewController<MBProgressHUDDelegate,NetworkModuleDelegate,SRRefreshDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)back:(id)sender;

@end
