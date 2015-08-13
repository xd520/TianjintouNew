//
//  RegesterViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class Child;
@interface RegesterViewController : UIViewController<NetworkModuleDelegate>{
    Child *child;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)pushProcoalVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;
- (IBAction)sheetMethods:(id)sender;

- (IBAction)back:(id)sender;
- (IBAction)next:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *passWordView;

@property (weak, nonatomic) IBOutlet UIView *allView;




@end
