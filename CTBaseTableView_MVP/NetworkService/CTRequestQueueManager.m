//
//
//  Created by TENG on 2018/2/2.
//  Copyright © 2018年 TENG. All rights reserved.
//

#import "CTRequestQueueManager.h"
#import "CTNetworkProtocol.h"

@implementation CTRequestQueueManager

static NSMutableDictionary <NSString *, id<CTNetworkProtocol> >*queueDic;

+ (void)initialize{
    if (self == [CTRequestQueueManager class]) {
        queueDic = [NSMutableDictionary new];
    }
}

/**
 set requestOperation
 
 @param request :one request conforms TYKYNetworkProtocol
 @param key :class name
 */
+ (void)setRequestOperation:(nullable id <CTNetworkProtocol>)request
                     forKey:(nullable NSString *)key {
    if (key) {
        [self p_cancelRequestOperationWithKey:key];
        if (request) {
            queueDic[key] = request;
            NSLog(@"网络请求队列:%@",queueDic);
        }
    }
}

/**
 取消网络请求
 
 @param className 网络请求存储className
 */
+ (void)cancelRequestOperation:(NSString *)className {
    
    for (NSString *qKey in queueDic.allKeys) {
        if ([qKey isEqualToString:className]||[qKey containsString:className]) {
            [self p_cancelRequestOperationWithKey:qKey];
        }
    }
}

+ (void)p_cancelRequestOperationWithKey:(NSString  *)key{
    id operation = queueDic[key];
    if (operation) {
        if ([operation conformsToProtocol:@protocol(CTNetworkProtocol)]){
            [(id<CTNetworkProtocol>) operation cancel];
        }
        [queueDic removeObjectForKey:key];
    }
}

@end
