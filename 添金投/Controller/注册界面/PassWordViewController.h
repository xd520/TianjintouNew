//
//  PassWordViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PassWordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passWordAgain;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)back:(id)sender;
- (IBAction)next:(id)sender;

@end
