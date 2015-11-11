//
//  CustomCookieStorage.m
//  CoWork
//
//  Created by mac  on 14-7-24.
//  Copyright (c) 2014年 ApexSoft. All rights reserved.
//

#import "CustomCookieStorage.h"

@implementation CustomCookieStorage

- (void)setCookie:(NSHTTPCookie *)cookie{
    NSLog(@"setcookie = %@",cookie);
    
    [super setCookie:cookie];
}

@end
