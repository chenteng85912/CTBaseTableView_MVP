//
//
//  Created by TENG on 2017/11/7.
//  Copyright © 2017年 TENG. All rights reserved.
//

#import "CTRequest.h"

NSInteger const kRequestTimeOut = 30.0;

@implementation CTRequest

+ (instancetype)creatNetworkRequest:(NSString * _Nullable)urlStr
                       requestModel:(CTNetWorkRequestModal)requestModel
                             params:(NSDictionary *)params {

    if (requestModel == CTPOSTRequestModal&&!params) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:urlStr];

    CTRequest *request = [[self alloc] initWithURL:url];
    if (requestModel == CTPOSTRequestModal) {
        request.HTTPMethod  = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        request.HTTPBody = jsonData;
    }else{
        request.HTTPMethod  = @"GET";
    }
    
    request.timeoutInterval = kRequestTimeOut;
    request.requestModel = requestModel;
    
    return request;
}

@end
