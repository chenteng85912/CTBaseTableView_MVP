//
//  CT_TableviewNetworkProtocol.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CT_TableviewNetworkProtocol <NSObject>

@optional

//https请求
+ (void)fetchDataWithUrlStr:(NSString *)urlStr andParamas:(NSMutableDictionary *)paramas Complete:(void(^)(id obj))afterRequest;

//webservice请求
+ (void)fetchDataWithWebserviceInfo:(NSMutableDictionary *)serviceInfo andParamas:(NSMutableDictionary *)paramas Complete:(void(^)(id obj))afterRequest;

@end
