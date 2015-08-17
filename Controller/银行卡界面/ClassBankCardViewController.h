//
//  ClassBankCardViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-19.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class BindCardViewController;
@protocol ClassBankViewControllerDelegate
- (void)reloadTableView:(NSDictionary *)_code;
@end

@interface ClassBankCardViewController : UIViewController<NetworkModuleDelegate,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
- (IBAction)back:(id)sender;

@property(nonatomic,strong)BindCardViewController *bindVC;
@property( assign, nonatomic ) id <ClassBankViewControllerDelegate> delegate;

@end
