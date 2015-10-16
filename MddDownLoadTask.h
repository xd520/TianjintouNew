//
//  MddDownLoadTask.h
//  ChildrenLocation
//
//  Created by szalarm on 15/9/18.
//  Copyright (c) 2015年 szalarm. All rights reserved.
//

#import <Foundation/Foundation.h>

//传参数协议
@protocol MddDownLoadTaskDelegate
//设置
//-(void) mddSetValue:(NSMutableDictionary *)pValue;
//可选
@optional
//出错
-(void) mddDownLoadErrorCallBack:(NSError *)pError;
//完成
-(void) mddDownLoadSuccessCallBack:(NSMutableDictionary *)pValue;
@end

#pragma mark 定义blocks
//初始化进度
typedef void (^initProgress)(long long initValue);
//下载数据
typedef void (^loadedData)(long long loadedLength);
/*
 下载线程
 saveAsFilePath 必须
 downloadUrl 必须
 */


/*
 用法
 //装箱
NSMutableDictionary * DownLoadParam=[NSMutableDictionary dictionary];

MessageData * msgData=[[MessageData alloc] initWithDic:pMessage.mMessageDic];
//拷贝
[DownLoadParam setObject:msgData forKey:@"server_msg"];
[DownLoadParam setObject:saveLocalPath forKey:@"savePath"];
[DownLoadParam setObject:saveLocalPath forKey:@"saveAsFilePath"];
[DownLoadParam setObject:tRelationSaveWav forKey:@"localPath"];
[DownLoadParam setObject:downloadUrl forKey:@"downloadUrl"];
//
MddDownLoadTask  * tDownLoadTask=[[MddDownLoadTask alloc] initWithDic:DownLoadParam];
tDownLoadTask.mddDelegate=self;
[tDownLoadTask runTask];
 */
@interface MddDownLoadTask : NSObject<NSURLConnectionDataDelegate,MddDownLoadTaskDelegate>
{
    //代理
    id <MddDownLoadTaskDelegate> mddDelegate;

}
#pragma mark 属性
@property (nonatomic,strong) id<MddDownLoadTaskDelegate> mddDelegate;
@property (strong) NSURL *httpURL;
@property (copy) void (^initProgress)(long long initValue);
@property (copy) void (^loadedData)(long long loadedLength);
//初始化
-(id) initWithDic:(NSMutableDictionary *) pData;

//执行
-(void) runTask;

@end
