//
//  TransferDetailsViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-16.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TransferDetailsViewController : UIViewController<MBProgressHUDDelegate,NetworkModuleDelegate>

@property(nonatomic,strong)NSString *wth;
@property(nonatomic,strong)NSString *gqdm;
@property(nonatomic,assign)BOOL flag;


- (IBAction)back:(id)sender;

@end
