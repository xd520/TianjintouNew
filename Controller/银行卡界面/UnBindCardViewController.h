//
//  UnBindCardViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-27.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UnBindCardViewController : UIViewController<NetworkModuleDelegate>

- (IBAction)back:(id)sender;
//@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,strong) NSString *cardBankStr;

@property (nonatomic,strong) NSString *bankAccountStr;
@property (nonatomic,strong) NSString *bankcodeStr;

@property (weak, nonatomic) IBOutlet UITextField *codeNum;
@property (weak, nonatomic) IBOutlet UITextField *jiaoyiPW;
@property (weak, nonatomic) IBOutlet UIButton *sheetBtn;
- (IBAction)sheetMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
- (IBAction)biandMethods:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bank;

@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (weak, nonatomic) IBOutlet UILabel *bankAccount;



@end
