//
//
//  Created by TENG on 2017/11/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TYKYRequest;
@protocol CTNetworkProtocol <NSObject>

//发送网络请求
- (void)startRequest:(void(^)(NSError *error,  id resultObj))afterRequest;

//取消网络请求
- (void)cancel;

@end

