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

@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet UIButton *remeber1;

- (IBAction)remeber1Methods:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *commit1;
- (IBAction)commit1Methods:(id)sender;

@end
