//
//  TransferSuccessViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-14.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferSuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *pushAccount;
- (IBAction)pushAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *goonBtn;
- (IBAction)goOnMethods:(id)sender;

@end
