//
//
//  Created by TENG on 2018/2/2.
//  Copyright © 2018年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CTNetworkProtocol;

@interface CTRequestQueueManager : NSObject

/**
 set requestOperation
 
 @param request :one request conforms CTNetworkProtocol
 @param key :class name
 */
+ (void)setRequestOperation:(nullable id <CTNetworkProtocol>)request
                     forKey:(nullable NSString *)key;

/**
 取消某个网络请求
 
 @param className 网络请求存储className
 */
+ (void)cancelRequestOperation:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
