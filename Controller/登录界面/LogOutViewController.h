//
//  LogOutViewController.h
//  贵州金融资产股权交易
//
//  Created by mac on 15-5-21.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LogOutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *code;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *codeImgve;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
