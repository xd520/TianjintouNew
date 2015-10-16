//
//  MddDownLoadTask.m
//  ChildrenLocation
//
//  Created by szalarm on 15/9/18.
//  Copyright (c) 2015年 szalarm. All rights reserved.
//

#import "MddDownLoadTask.h"

@interface MddDownLoadTask()
//私有
    @property (assign) long long contentLength;
    @property (assign) long long receiveLength;
    @property (strong) NSMutableData *receiveData;
    @property (strong) NSString *fileName;
    @property (strong) NSURLConnection *theConnection;
    @property (strong) NSURLRequest *theRequest;
    @property (strong) NSString *saveAsFilePath;
    //参数
    @property (strong) NSMutableDictionary * pData;
@end
@implementation MddDownLoadTask
@synthesize receiveData = _receiveData, fileName = _fileName,
theConnection=_theConnection, theRequest=_theRequest,saveAsFilePath=_saveAsFilePath,pData=_pData;
//绑定
@synthesize mddDelegate=mddDelegate;

//初始化
-(id) initWithDic:(NSMutableDictionary *) pData
{
    if (self=[super init]) {
        //缓存数据
        _pData=[pData mutableCopy];
        //保存路径
        _saveAsFilePath=[_pData valueForKey:@"saveAsFilePath"];
       // NSString * downloadUrl=[_pData valueForKey:@"downloadUrl"];
    
        self.httpURL= [_pData valueForKey:@"downloadUrl"];
        
        //self.httpURL= [[NSURL alloc] initWithString:downloadUrl ];
        self.theRequest=[NSURLRequest requestWithURL:self.httpURL
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:15.0];
        
        /*
         NSURLRequestReloadIgnoringLocalCacheData = 1,
         NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented
         NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,
         
         NSURLRequestReturnCacheDataElseLoad = 2,
         NSURLRequestReturnCacheDataDontLoad = 3,
         
         NSURLRequestReloadRevalidatingCacheData = 5
         
         */
        
    }
    return self;
}

//执行
-(void) runTask
{
//    NSMutableDictionary * rData=[_pData mutableCopy];
    __block long long _sum=0;
    //接收到
    __block long long _rcv=0;
    self.initProgress = ^(long long initValue){
        _sum = initValue;
        NSLog(@"%lli",initValue);
        _rcv = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            //ui界面
            
        });
    };
    self.loadedData = ^(long long loadedLength){
        NSLog(@"loadedLength:%lld",loadedLength);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_rcv == _sum) {
                
            } else {
                _rcv += loadedLength;
                NSLog(@"%f",_rcv/(1.0*_sum));
                
                if (_rcv >= _sum) {
//                    pSuccessHandler(_pData);
//                    pSuccessHandler(rData);
//                    NSLog(@"下载完成");
                }
            }
            
        });
    };

    [self startAsyn];

}

//开始进程
-(void) startAsyn{
    _contentLength=0;
    _receiveLength=0;
    self.receiveData = [[NSMutableData alloc] init];
    self.theConnection = [[NSURLConnection alloc] initWithRequest:self.theRequest delegate:self];
    //数据

}

//接收到http响应
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _contentLength = [response expectedContentLength];
    _fileName = [response suggestedFilename];
    if (self.initProgress != nil) {
        self.initProgress(_contentLength);
    }
    NSLog(@"data length is %lli", _contentLength);
}

//传输数据
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _receiveLength += data.length;
    [_receiveData appendData:data];
    if (self.loadedData != nil) {
        self.loadedData(data.length);
    }
    NSLog(@"data recvive is %lli", _receiveLength);
}

//错误
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
     [self.mddDelegate mddDownLoadErrorCallBack:error];
    [self releaseObjs];
    NSLog(@"%@",error.description);
}

//释放对象
-(void) releaseObjs{
    self.receiveData = nil;
    self.fileName = nil;
    self.theRequest = nil;
    self.theConnection = nil;
    self.saveAsFilePath=nil;
    //
    self.pData=nil;
    self.mddDelegate=nil;
}

//设置保存路径
-(void) setSavePath:(NSString *)pLocalFolder shortFileName:(NSString *)pShortFileName
{
    //获取完整目录名字
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //Document/(文件夹)/(文件名)
    self.saveAsFilePath=[[documentsDirectory stringByAppendingPathComponent:pLocalFolder]stringByAppendingPathComponent:pShortFileName];
    NSLog(@"path:%@",self.saveAsFilePath);
    
}
//保存路径
//-(void) setFullSavePath:(NSString *) pFullFilePath
//{
//    self.saveAsFilePath=pFullFilePath;
//    NSLog(@"path:%@",self.saveAsFilePath);
//    
//}

//成功下载完毕
-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //数据写入doument
    //获取完整目录名字
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //为空默认下载到document中
    if(_saveAsFilePath==nil||[_saveAsFilePath isEqualToString:@""])
    {
        _saveAsFilePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory, _fileName];
    }
    //创建文件
    [_receiveData writeToFile:_saveAsFilePath atomically:YES];
    NSLog(@"保存路径:%@",_saveAsFilePath);
    NSMutableDictionary * tmpData=[_pData mutableCopy];
    [self.mddDelegate mddDownLoadSuccessCallBack:tmpData];
    [self releaseObjs];
}



@end
