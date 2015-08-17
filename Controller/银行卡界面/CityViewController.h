//
//  CityViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-27.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class LoginPassWordViewController;

@protocol CityViewControllerDelegate
- (void)reloadCityTableView:(NSDictionary *)_code;
@end

@interface CityViewController : UIViewController<NetworkModuleDelegate,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate>

@property (nonatomic,strong)NSString *strCode;
@property (nonatomic,strong)NSString *strTitle;

@property( assign, nonatomic ) id <CityViewControllerDelegate> delegate;


- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
