//
//  FoggterAgainViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-3.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FoggterAgainViewController : UIViewController

@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *sessionId;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMethods:(id)sender;

@end
