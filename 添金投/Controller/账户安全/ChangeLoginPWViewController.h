//
//  ChangeLoginPWViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-7.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeLoginPWViewController : UIViewController

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPW;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMehtods:(id)sender;

- (IBAction)askForMethods:(id)sender;

@end
