//
//  Https.h
//  TeenagersCreateModel
//
//  Created by Yonghui Xiong on 14-11-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Https : NSObject
{
    BOOL             isHttps;                     //当前是否是https协议
    SecIdentityRef   identify;                    //https验证通行证
}

@property(nonatomic,assign)SecIdentityRef  identify;
@property(nonatomic,assign) BOOL  isHttps;

- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data;
+(Https *) Instance;


@end
