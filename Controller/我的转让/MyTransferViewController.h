//
//  MyTransferViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-26.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyTransferViewController : UIViewController<NetworkModuleDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSString *transferStr;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *yeatLL;
@property (weak, nonatomic) IBOutlet UILabel *gainStaly;
@property (weak, nonatomic) IBOutlet UILabel *lastDate;
@property (weak, nonatomic) IBOutlet UILabel *shouxuFei;
@property (weak, nonatomic) IBOutlet UILabel *tatalMoney;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMehods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
- (IBAction)transferMethods:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *textView;


@end
