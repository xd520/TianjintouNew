//
//  Child.m
//  CommenUser
//
//  Created by Yonghui Xiong on 14-10-24.
//  Copyright (c) 2014年 ApexSoft. All rights reserved.
//

#import "Child.h"

@implementation Child

-(id)init{

    self = [super init];
    if (self != nil) {
        //self.age = 100;
//定时器
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(push:) userInfo:nil repeats:YES];
    
    }
    return self;
}

//定时器方法
-(void)push:(NSTimer *)timer {
    self.age--;
    if (self.age <= 0) {
        [timer invalidate];
    }
}


@end
