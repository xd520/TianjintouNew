//
//  MyAuthorityViewController.h
//  添金投
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAuthorityViewController : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *myAuthority;
@property (weak, nonatomic) IBOutlet UILabel *authority;
@property (weak, nonatomic) IBOutlet UIButton *rember;
- (IBAction)remberMethods:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitMethods:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@end
