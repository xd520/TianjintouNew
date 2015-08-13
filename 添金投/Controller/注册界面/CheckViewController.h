//
//  CheckViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class Child;

@interface CheckViewController : UIViewController<NetworkModuleDelegate>{
    Child *child;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *checkNumText;
@property (weak, nonatomic) IBOutlet UIButton *checkNumBtn;

- (IBAction)back:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)checkNumMethods:(id)sender;

@end
