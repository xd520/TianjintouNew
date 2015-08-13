//
//  ColorUtil.h
//  Electron
//
//  Created by Lin Zhao on 14-5-24.
//  Copyright (c) 2014年 Wutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorUtil : NSObject

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (UIColor *) colorWithHexString: (NSString *)color withApla:(float)_apla;


@end
