//
//  LoginViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@protocol LoginVCDelegate <NSObject>

//LoginView专用
-(void)LoginViewVC:(LoginViewController *)widgetsVC loginOK:(id)nilplaceholder;
@end

#import "AppDelegate.h"
@interface LoginViewController : UIViewController<NetworkModuleDelegate,MBProgressHUDDelegate>


@property (strong, nonatomic)NSString *loginStr;

@property (weak, nonatomic) IBOutlet UITextField *code;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak,nonatomic) id<LoginVCDelegate> delegate;
- (IBAction)push:(id)sender;
- (IBAction)loginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)foggoterPW:(id)sender;
- (IBAction)quit:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *codeImgve;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@end
