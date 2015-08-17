//
//  AddRechargeViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-2.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"
#import "AppDelegate.h"

@interface AddRechargeViewController : UIViewController<NetworkModuleDelegate>

@property (nonatomic,strong)  NSDictionary *dic;


- (IBAction)back:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *bankCardView;

@end
