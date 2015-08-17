//
//  MoneyAccountViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MoneyAccountViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,NetworkModuleDelegate>

@property(nonatomic,strong)NSDictionary *dic;
- (IBAction)back:(id)sender;

@end
