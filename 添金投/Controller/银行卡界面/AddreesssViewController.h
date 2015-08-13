//
//  AddreesssViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-26.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CityViewController.h"

@class LoginPassWordViewController;


@interface AddreesssViewController : UIViewController<NetworkModuleDelegate,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>
- (IBAction)back:(id)sender;

@property(nonatomic,strong)LoginPassWordViewController *logiVC;

@end
