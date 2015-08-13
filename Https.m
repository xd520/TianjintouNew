//
//  Https.m
//  TeenagersCreateModel
//
//  Created by Yonghui Xiong on 14-11-21.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "Https.h"

@implementation Https
@synthesize isHttps,identify;
static Https *http = nil;
+ (Https * )Instance{
    @synchronized(self)
	{
		if  (http  ==  nil)
		{
			http = [[Https alloc] init];
            
            [http InitConfig];
            //            [sjkhEngine initColor_datas];
        }
    }
	return  http;
}

- (void)InitConfig{
    isHttps = YES;
    
        
    SecTrustRef trust = NULL;
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"server" ofType:@"p12"]];
    NSLog(@"pkcs12data = %@",PKCS12Data);
    [[Https Instance] extractIdentity:&identify andTrust:&trust fromPKCS12Data:PKCS12Data];
    
}
/*
- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    
    
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("changeit"); //证书密码
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    //securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,optionsDictionary,&items);
    
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        NSLog(@"tempidentify = %@",tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}
*/


- (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
	OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("changeit"); //证书密码
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { password };
	
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    //	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"" forKey:(id)kSecImportExportPassphrase];
	
	CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
	//securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,optionsDictionary,&items);
    BOOL bSuccess = YES;
    
	if (securityError == 0) {
		CFDictionaryRef myIdentityAndTrust = (CFDictionaryRef)CFArrayGetValueAtIndex (items, 0);
		const void *tempIdentity = NULL;
		tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
		*outIdentity = (SecIdentityRef)tempIdentity;
		const void *tempTrust = NULL;
		tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
		*outTrust = (SecTrustRef)tempTrust;
        bSuccess = YES;
	}
    else {
	 	bSuccess = NO;
	}
    
    //    CFRelease(optionsDictionary);
    //    CFRelease(items);
	return bSuccess;
}

@end
