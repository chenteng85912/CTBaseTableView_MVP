//
//  CTBaseViewControllerProtocol.h
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CTRequestBlock) (NSError *error, id objectDic);
#define CT_SUBCLASS_RESPONSE(rootVC,Pselector) [rootVC respondsToSelector:@selector(Pselector)]
#define CT_WEAKSELF      __weak typeof(self) weakSelf = self

@protocol CTBaseViewControllerDataSourceProtocol <NSObject>

@optional

/**
 获取请求参数
 @return 请求参数 字典对象
 */
- (NSDictionary *)postParams;

/**
 请求地址
 
 @return 请求地址
 */
- (NSString *)requestUrlString;

/**
 获取数据加载方式 默认为POST
 
 @return 数据加载方式 POST OR  GET
 */
- (NSString *)requestModal;


@end

@protocol CTBaseViewControllerDelegateProtocol <NSObject>

@optional

//请求成功
- (void)requestSuccess:(id)resultData;

//请求失败
- (void)requestFail:(NSString *)errorMsg;


@end
