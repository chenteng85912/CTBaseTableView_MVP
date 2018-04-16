//
//
//  Created by TENG on 2017/11/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CTNetWorkRequestModal) {
    CTPOSTRequestModal,      //post请求
    CTGETRequestModal        //get请求
};

@interface CTRequest : NSMutableURLRequest

@property (nonatomic, assign) CTNetWorkRequestModal requestModel;

+ (instancetype)creatNetworkRequest:(NSString * _Nullable)urlStr
                       requestModel:(CTNetWorkRequestModal)requestModel
                             params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
