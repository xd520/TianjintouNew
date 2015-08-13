//
//  ConfirmTransferViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-25.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ConfirmTransferViewController : UIViewController<NetworkModuleDelegate,MBProgressHUDDelegate>
- (IBAction)back:(id)sender;

@property(nonatomic,strong)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *yeatLL;
@property (weak, nonatomic) IBOutlet UILabel *gainStaly;
@property (weak, nonatomic) IBOutlet UILabel *lastDate;
@property (weak, nonatomic) IBOutlet UILabel *shouxuFei;
@property (weak, nonatomic) IBOutlet UILabel *tatalMoney;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMehods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *textView;

@end
