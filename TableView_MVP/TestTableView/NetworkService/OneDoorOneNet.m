//
//  OneDoorOneNet.m
//  webhall
//
//  Created by Apple on 2016/10/28.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import "OneDoorOneNet.h"

@interface OneDoorOneNet ()

@end
@implementation OneDoorOneNet


//post请求
+ (void)sendPostRequest:(NSString *)urlStr withParamas:(NSMutableDictionary *)paras complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paras options:NSJSONWritingPrettyPrinted error:&error];
    
    request.HTTPBody = jsonData;
    
    [OneDoorOneNet sendRequest:request complete:^(NSError *error, NSDictionary *objectDic) {
        if (afterRequest) {
            afterRequest(error,objectDic);
            
        }
    }];
    
}

//get请求
+ (void)sendGetRequestWithUrl:(NSString *)urlStr complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest
{
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"GET";
    
    [OneDoorOneNet sendRequest:request complete:^(NSError *error, NSDictionary *objectDic) {
        afterRequest(error,objectDic);
    }];
}

+(void)sendRequest:(NSMutableURLRequest *)request complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest{
    
    //超时时间
    request.timeoutInterval = 100.0f;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                afterRequest(error,nil);
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"网络请求返回的数据:%@",dict);
                afterRequest(nil,dict);
            }
        });
 
    }];
    
    //发送请求
    [dataTask resume];
}

@end
