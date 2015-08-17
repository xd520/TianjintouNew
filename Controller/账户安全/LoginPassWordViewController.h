//
//  LoginPassWordViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DDList.h"
#import "PassValueDelegate.h"

@class PassWordMangerViewController;
@interface LoginPassWordViewController : UIViewController<NetworkModuleDelegate,PassValueDelegate,MBProgressHUDDelegate>
{
    DDList				 *_ddList;
}

@property(nonatomic,strong)NSDictionary *cityDic;
@property(nonatomic,strong)NSDictionary *addressDic;

@property(nonatomic,strong)PassWordMangerViewController *vcCtrl;

@property (weak, nonatomic) IBOutlet UILabel *falemLab;


@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UITextField *passNum;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextField *detailAdd;
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;

- (IBAction)sheetMethods:(id)sender;


- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordAgain;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)sureMethods:(id)sender;

- (void)setDDListHidden:(BOOL)hidden;

@end
