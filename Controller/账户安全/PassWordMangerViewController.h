//
//  PassWordMangerViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PassWordMangerViewController : UIViewController<NetworkModuleDelegate>



@property (weak, nonatomic) IBOutlet UILabel *firstLab;//安全设置
@property (weak, nonatomic) IBOutlet UILabel *secondLab;//银行卡
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;//交易密码
@property (weak, nonatomic) IBOutlet UILabel *forthLab;//登录密码

@property (weak, nonatomic) IBOutlet UIImageView *bankCard;


- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *loginView; //安全设置
@property (weak, nonatomic) IBOutlet UIView *changView;//银行卡
@property (weak, nonatomic) IBOutlet UIView *resetView;//交易密码
@property (weak, nonatomic) IBOutlet UIView *sureLoginView;//登录密码

@property (weak, nonatomic) IBOutlet UIImageView *riskImgView;



@end
