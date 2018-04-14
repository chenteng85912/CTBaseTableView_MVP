//
//  OneDoorOneNet.h
//  webhall
//
//  Created by Apple on 2016/10/28.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CTNetworkProtocol.h"

@class CTRequest;

@interface CTNetworkService : NSObject<CTNetworkProtocol>

+ (instancetype)initWithRequest:(CTRequest *)request;

@end
