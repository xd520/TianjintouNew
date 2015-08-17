//
//  WithdrawViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-17.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WithdrawViewController : UIViewController<NetworkModuleDelegate>


@property (nonatomic,strong)  NSString *inputMoney;
@property (nonatomic,strong)  NSDictionary *dic;


- (IBAction)back:(id)sender;


@end
