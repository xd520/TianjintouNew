//
//  MyBuyViewController.h
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DDList.h"
#import "PassValueDelegate.h"

@interface MyBuyViewController : UIViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SRRefreshDelegate,NetworkModuleDelegate,PassValueDelegate>{
    DDList				 *_ddList;
}

- (void)setDDListHidden:(BOOL)hidden;

- (IBAction)back:(id)sender;

@end
