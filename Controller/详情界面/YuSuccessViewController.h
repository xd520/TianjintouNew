//
//  YuSuccessViewController.h
//  添金投
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuSuccessViewController : UIViewController
- (IBAction)backMyAccount:(id)sender;
- (IBAction)backMyYuYue:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *myAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *myYuyueBtn;

@end
