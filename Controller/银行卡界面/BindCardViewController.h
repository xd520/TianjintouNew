//
//  BindCardViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-2.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassBankCardViewController.h"
#import "ProviousViewController.h"
#import "CityViewController.h"

@interface BindCardViewController : UIViewController<ClassBankViewControllerDelegate,NetworkModuleDelegate,ProviousViewControllerDelegate,CityViewControllerDelegate>

@property (strong, nonatomic) NSString *pushStr;

//@property (nonatomic,strong) NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UIView *chikarenView;

@property (weak, nonatomic) IBOutlet UIView *yinhangView;
@property (weak, nonatomic) IBOutlet UIView *yinhangkahaoView;
@property (weak, nonatomic) IBOutlet UIView *shengfenView;

@property (weak, nonatomic) IBOutlet UIView *diquView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *bindCardLab;
@property (weak, nonatomic) IBOutlet UITextField *bankAccount;
@property (weak, nonatomic) IBOutlet UILabel *proviousLab;//开户省份
@property (weak, nonatomic) IBOutlet UILabel *addressLab;//开户地区

- (IBAction)commitBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *commit;
- (IBAction)back:(id)sender;

@end
