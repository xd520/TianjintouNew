//
//  Base64.h
//  Sellthree
//
//  Created by Chris on 14-7-28.
//  Copyright (c) 2014年 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64XD : NSObject
{
    NSString *strBase64;
}

@property(nonatomic,retain)NSString *strBase64;

+ (id)encodeBase64String:(NSString *)input;
+ (id)decodeBase64String:(NSString *)input;
+ (id)encodeBase64Data:(NSData *)data;
+ (id)decodeBase64Data:(NSData *)data;
@end
