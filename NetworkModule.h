//
//  NetworkModule.h
//  mPortal
//
//  Created by chen neng on 11-12-20.
//  Copyright (c) 2011年 ydtf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostRequest.h"
#import "URLUtil.h"

@interface NetworkModule : NSObject
<ASIHTTPRequestDelegate>{
    NSMutableDictionary* queue;
}
+(NetworkModule *)sharedNetworkModule;
-(void)postBusinessReq:(NSString *)xml 
                   tag:(kBusinessTag)tag 
                 owner:(id<NetworkModuleDelegate>)owner;
-(void)postBusinessReqWithParamters:(NSMutableDictionary *)dic
                   tag:(kBusinessTag)tag
                 owner:(id<NetworkModuleDelegate>)owner;
-(void)postBusinessReqWithParamtersAndFile:(NSMutableDictionary *)dic
    number:(int)num  withFileName:(NSString *)str fileData:(NSData *)data tag:(kBusinessTag)tag
                              owner:(id<NetworkModuleDelegate>)owner;
-(void)cancel:(kBusinessTag)tag;

@end
