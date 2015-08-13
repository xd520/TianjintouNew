
//
//  NetworkModule.m
//  mPortal
//
//  Created by chen neng on 11-12-20.
//  Copyright (c) 2011年 ydtf. All rights reserved.
//

#import "NetworkModule.h"

@implementation NetworkModule

//SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkModule);
//实现单例
static NetworkModule *sharedGizmoNetworkModule = nil;
+(NetworkModule *)sharedNetworkModule
{
    @synchronized(self){
        if (sharedGizmoNetworkModule == nil) {
            //内存处理过
            //原
            [[self alloc] init];
            //改[[[self alloc] init] autorelease];
        }
    }
    return sharedGizmoNetworkModule;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if (sharedGizmoNetworkModule == nil) {
            sharedGizmoNetworkModule = [super allocWithZone:zone];
            return sharedGizmoNetworkModule;
        }
    }
    return nil;
}
+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        queue=[[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)postBusinessReq:(NSString*)xml 
                   tag:(kBusinessTag)tag 
                 owner:(id<NetworkModuleDelegate>)owner{
    PostRequest* req=(PostRequest*)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (req==nil) {
        req=[[PostRequest alloc]init];
    }
    req.businessTag=tag;
    req.postStatus=kPostStatusNone;
    
    [queue setObject:req forKey:[NSNumber numberWithInt:tag]];
    req.enc=NSUTF8StringEncoding;
    req.owner=owner;

    req.url=[URLUtil getURLByBusinessTag:tag];
    NSLog(@"%s:%@",__FUNCTION__,req.url);
    [req postXML:xml delegate:self];
    if(owner!=nil) [owner beginPost:tag];
}
-(void)postBusinessReqWithParamters:(NSMutableDictionary *)dic
                                tag:(kBusinessTag)tag
                              owner:(id<NetworkModuleDelegate>)owner
{
    PostRequest* req=(PostRequest *)[queue objectForKey:[NSNumber numberWithInt:tag]];
    //req为空就为get 请求
    if (req==nil) {
        req=[[PostRequest alloc]init];
    }
    
    
    req.businessTag=tag;
    req.postStatus=kPostStatusNone;
    
    [queue setObject:req forKey:[NSNumber numberWithInt:tag]];
    req.enc=NSUTF8StringEncoding;
    req.owner=owner;
    
    req.url=[URLUtil getURLByBusinessTag:tag];
   // NSLog(@"%s:%@",__FUNCTION__,req.url);
//判定是否为https 请求
   // NSString *str = [req absoluteURL];
    
    NSLog(@"%u",tag);
    
    [req postDictionary:dic delegate:self];

    if(owner!=nil) [owner beginPost:tag];
}
-(void)postBusinessReqWithParamtersAndFile:(NSMutableDictionary *)dic number:(int)num  withFileName:(NSString *)str fileData:(UIImage *)data tag:(kBusinessTag)tag
                                     owner:(id<NetworkModuleDelegate>)owner
{
    [self cancel:tag];
    
    PostRequest* req=(PostRequest *)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (req==nil) {
        req=[[PostRequest alloc]init];
    }
    req.businessTag=tag;
    req.postStatus=kPostStatusNone;
    
    [queue setObject:req forKey:[NSNumber numberWithInt:tag]];
    req.enc=NSUTF8StringEncoding;
    req.owner=owner;
    
    req.url=[URLUtil getURLByBusinessTag:tag];
    NSLog(@"%s:%@",__FUNCTION__,req.url);
    [req postDictionaryAndData:dic number:num name:str data:(NSData *)data delegate:self];
    
    if(owner!=nil) [owner beginPost:tag];
}
-(void)cancel:(kBusinessTag)tag{
    PostRequest* req=(PostRequest*)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (req && [req isKindOfClass:[PostRequest class]]) {
        [req cancel];
    }
}
#pragma mark ASIHTTPRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    PostRequest* req=(PostRequest*)[queue objectForKey:
                                    [NSNumber numberWithInteger:request.tag]];
    req.postStatus=kPostStatusEnded;
    if (req.owner!=nil) {
        [req.owner endPost:req.result
				  business: req.businessTag];
    }

}
// 请求失败，获取 error
- (void)requestFailed:(ASIHTTPRequest *)request
{
    PostRequest* req=(PostRequest*)[queue objectForKey:
                                    [NSNumber numberWithInteger:request.tag]];
	NSError *error = [request error];
	if (req.owner!=nil) {
        [req.owner errorPost:error
					business: req.businessTag];
    }
}
-(void)dealloc{
    [queue release];
    [super dealloc];
}

@end
