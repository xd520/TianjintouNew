//
//  ReSetPassWordViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-13.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReSetPassWordViewController : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordAgain;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureMethods:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *code;

@property (weak, nonatomic) IBOutlet UIButton *sheetCodeBtn;
- (IBAction)sheetCodeMethods:(id)sender;



@end
