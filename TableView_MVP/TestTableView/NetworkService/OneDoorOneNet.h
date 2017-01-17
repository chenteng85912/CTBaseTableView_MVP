//
//  OneDoorOneNet.h
//  webhall
//
//  Created by Apple on 2016/10/28.
//  Copyright © 2016年 深圳太极软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

// 查询用户浏览记录
#define GET_RecordDatas        @"http://unilink.changchun.gov.cn:8000/services/interAction/findPageItems"

@interface OneDoorOneNet : NSObject


//post请求
+ (void)sendPostRequest:(NSString *)urlStr withParamas:(NSMutableDictionary *)paras complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest;

//get请求
+ (void)sendGetRequestWithUrl:(NSString *)urlStr complete:(void(^)(NSError *error, NSDictionary *objectDic))afterRequest;


@end
