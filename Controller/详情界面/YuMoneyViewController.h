//
//  YuMoneyViewController.h
//  添金投
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YuYueViewControllerDelegate
- (void)reloadMoneyView:(NSDictionary *)_code;
@end

@class YuYueViewController;
@interface YuMoneyViewController : UIViewController
- (IBAction)back:(id)sender;

@property( assign, nonatomic ) id <YuYueViewControllerDelegate> delegate;

@end
