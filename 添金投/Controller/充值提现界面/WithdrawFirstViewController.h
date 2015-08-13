//
//  WithdrawFirstViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-18.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawFirstViewController : UIViewController

@property (nonatomic,strong)  NSDictionary *dic;
@property (nonatomic,strong)  NSString *flag;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *tailNum;
@property (weak, nonatomic) IBOutlet UITextField *inPutMoney;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
- (IBAction)rechargeMehtods:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@end
