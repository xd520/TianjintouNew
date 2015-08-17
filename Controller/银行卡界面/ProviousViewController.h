//
//  ProviousViewController.h
//  添金投
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProviousViewControllerDelegate
- (void)reloadProviousTableView:(NSDictionary *)_code;
@end
@interface ProviousViewController : UIViewController

@property( assign, nonatomic ) id <ProviousViewControllerDelegate> delegate;


- (IBAction)back:(id)sender;

@end
