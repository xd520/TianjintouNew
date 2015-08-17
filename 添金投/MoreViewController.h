//
//  MoreViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreViewController;
@protocol LogOutVCDelegate <NSObject>

//LoginView专用
-(void)LogOutViewVC:(MoreViewController *)widgetsVC loginOK:(id)nilplaceholder;

@end

@interface MoreViewController : UIViewController
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic) id<LogOutVCDelegate> delegate;
- (IBAction)logoutBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end
