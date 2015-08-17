//
//  TradingAccountViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingAccountViewController : UIViewController

@property(nonatomic,strong)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *moneyAccount;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
- (IBAction)bindCard:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *readyBtn;
- (IBAction)readyMethods:(id)sender;

@end
