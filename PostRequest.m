//
//  PostRequest.m
//  mPortal
//
//  Created by chen neng on 11-12-20.
//  Copyright (c) 2011年 ydtf. All rights reserved.
//

#import "PostRequest.h"
#import "Https.h"

@implementation PostRequest
@synthesize postStatus;
@synthesize enc,url;
@synthesize businessTag;
@synthesize owner;
-(void)cancel{
    if (_request!=nil) {
        [_request release],
        _request=nil;
    }
}
-(void)setOwner:(id<NetworkModuleDelegate>)_owner{
    owner=[_owner retain];
}
-(id<NetworkModuleDelegate>)owner{
    return owner;
}

-(NSString*)result{
    if(postStatus==kPostStatusEnded){
        NSData *data = [_request responseData];
        //`处理
        //原NSString* string=[[NSString alloc] initWithData:data encoding:self.enc];
        NSString* string=[[[NSString alloc] initWithData:data encoding:self.enc] autorelease];
        return string;
    }else
        return nil;
}

-(void)postXML:(NSString*)xml delegate:(id)delegate{
    [self cancel];
    _request=[[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]]retain];
	[_request setShouldAttemptPersistentConnection:NO];
    [_request setResponseEncoding:self.enc];
	NSMutableDictionary *reqHeaders = [[NSMutableDictionary alloc] init];
	[reqHeaders setValue:@"text/xml; charset=UTF-8" forKey:@"Content-Type"];
	_request.requestHeaders = reqHeaders;
	[reqHeaders release];
    NSLog(@"post xml:%@",xml);
    // 重要
    _request.tag=self.businessTag;
	[_request appendPostData:[xml dataUsingEncoding:self.enc]];
    [_request setDelegate:delegate];
    postStatus=kPostStatusBeging;
	[_request startAsynchronous];
}

//wowjsfjisj 
-(void)postDictionary:(NSMutableDictionary *)dic delegate:(id)delegate
{
    [self cancel];
    _request = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]] retain];
//判断是否为https请求
    NSString *str = [_request.url absoluteString];
    
    NSLog(@"%@",str);
    
    
    
    /*
   if ([[_request.url scheme] isEqualToString:@"https"]){
    
        [_request setValidatesSecureCertificate:NO];
        [_request setClientCertificateIdentity:[Https Instance].identify];
        // [_request setValue:finalHost forHTTPHeaderField:@"Host"];
    
    }
    */
    [_request setShouldAttemptPersistentConnection:YES];
    [_request setTimeOutSeconds:10];
    [_request setResponseEncoding:self.enc];
    
//判定字典dic 是否为空  如果不加判定就默认为GET 请求
 // 当dic == nil； 的时候是GET请求
    if (dic!=nil) {
    NSEnumerator *enumerator = [[dic keyEnumerator] retain];
    if ([dic count] == 0) {
        [_request setPostValue:nil forKey:nil];
    } else {
    for (NSString *key in enumerator) {
        [_request setPostValue:[dic objectForKey:key] forKey:key];
    }
    }
    [enumerator release];
    }
 
  //设置请求头
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@"ios" forKey:@"Request-By"];
   [_request setRequestHeaders:dictionary];
    
    _request.tag = self.businessTag;
    [_request setDelegate:delegate];
    postStatus = kPostStatusBeging;
    [_request startAsynchronous];
}



//https 请求方法
-(void)postHttpsDictionary:(NSMutableDictionary *)dic delegate:(id)delegate
{
    [self cancel];
    //NSString *finalHost=@"192.168.1.57 www.lym6520.com";
    _request = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]] retain];
    [_request setValidatesSecureCertificate:NO];
    [_request setClientCertificateIdentity:[Https Instance].identify];
   // [_request setValue:finalHost forHTTPHeaderField:@"Host"];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    [_request setResponseEncoding:self.enc];
    //判定字典dic 是否为空  如果不加判定就默认为GET 请求
    // 当dic == nil； 的时候是GET请求
    if (dic!=nil) {
        NSEnumerator *enumerator = [[dic keyEnumerator] retain];
        if ([dic count] == 0) {
            [_request setPostValue:nil forKey:nil];
        } else {
            for (NSString *key in enumerator) {
                [_request setPostValue:[dic objectForKey:key] forKey:key];
            }
        }
        [enumerator release];
    }
    _request.tag = self.businessTag;
    [_request setDelegate:delegate];
    postStatus = kPostStatusBeging;
    [_request startAsynchronous];
}

-(void)postDictionaryAndData:(NSMutableDictionary *)dic number:(int)num name:(NSString *)str data:(NSData *)data delegate:(id)delegate
{
    [self cancel];
    _request = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]] retain];
    
     NSString *str1 = [_request.url scheme];
    NSLog(@"%@",str1);
    
    
    [_request setShouldAttemptPersistentConnection:NO];
    
    [_request setTimeOutSeconds:10];
    [_request setResponseEncoding:self.enc];
    NSEnumerator *enumerator = [[dic keyEnumerator] retain];
    for (NSString *key in enumerator) {
        [_request setPostValue:[dic objectForKey:key] forKey:key];
    }
    [enumerator release];
    [_request setData:data withFileName:[NSString stringWithFormat:@"%@%i.jpg",str,num] andContentType:@"image/jpg" forKey:@"upfile"];
    _request.tag = self.businessTag;
    [_request setDelegate:delegate];
    postStatus = kPostStatusBeging;
    [_request startAsynchronous];
}
////收拾收拾是收拾收拾是是

-(void)dealloc{
    [owner release],owner=nil;
    [_request release];
    [super dealloc];
}
@end
