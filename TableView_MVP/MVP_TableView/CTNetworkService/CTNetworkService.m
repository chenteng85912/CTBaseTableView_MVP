//
//  OneDoorOneNet.m
//  webhall
//
//  Created by Apple on 2016/10/28.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "CTNetworkService.h"
#import "CTRequest.h"

@interface CTNetworkService ()<NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (strong, nonatomic) CTRequest *request;
@property (assign, nonatomic) BOOL requesting;

@end

@implementation CTNetworkService

+ (instancetype)initWithRequest:(CTRequest *)request{
    return [[self alloc] initWithRequest:request];
}
-  (instancetype)initWithRequest:(CTRequest *)request{
    self = [super init];
    if (self) {
        self.request = request;
    }
    return self;
}

//发送网络请求
- (void)startRequest:(void(^)(NSError *error,  id resultObj))afterRequest{
    
    if (!self.request) {
        NSAssert(NO, @"网络请求为空---request");
        return;
    }
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.requesting) {
                return ;
            }
            if (!afterRequest) {
                return;
            }
            if (error) {
                afterRequest(error,nil);
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                
                afterRequest(nil,dict);

            }
        });
 
    }];
    
    //发送请求
    [dataTask resume];
    self.requesting = YES;
    _task = dataTask;
}

#pragma mark - NSURLSessionDataDelegate
/*
 // 只要访问的是HTTPS的路径就会调用
 // 该方法的作用就是处理服务器返回的证书, 需要在该方法中告诉系统是否需要安装服务器返回的证书
 // 1.从服务器返回的受保护空间中拿到证书的类型
 // 2.判断服务器返回的证书是否是服务器信任的
 // 3.根据服务器返回的受保护空间创建一个证书
 // 4.创建证书 安装证书
 //   completionHandler(NSURLSessionAuthChallengeUseCredential , credential);
 */
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    //AFNetworking中的处理方式
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        /*disposition：如何处理证书
         NSURLSessionAuthChallengePerformDefaultHandling:忽略证书 默认的做法
         NSURLSessionAuthChallengeUseCredential：使用指定的证书
         NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求,忽略证书
         NSURLSessionAuthChallengeRejectProtectionSpace 拒绝,忽略证书
         */
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)cancel{
    if (_task) {
        self.requesting = NO;
        NSLog(@"取消网络请求--------%@",self.request.URL.absoluteString);

        [_task cancel];
    }
}

@end
