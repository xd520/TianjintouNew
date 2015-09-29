//
//  ForgetPWDViewController.h
//  添金投
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPWDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *userName;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextMethods:(id)sender;




@end
