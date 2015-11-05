//
//  YuYueViewController.h
//  添金投
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuMoneyViewController.h"

@interface YuYueViewController : UIViewController<YuYueViewControllerDelegate>

@property(nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSDictionary *dic;

- (IBAction)back:(id)sender;

@end
