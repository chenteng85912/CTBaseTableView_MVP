//
//  NetworkService.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "NetworkService.h"
#import "OneDoorOneNet.h"
@implementation NetworkService

+ (void)fetchDataWithUrlStr:(NSString *)urlStr andParamas:(NSMutableDictionary *)paramas Complete:(void(^)(id obj))afterRequest{
    
    [OneDoorOneNet sendPostRequest:urlStr withParamas:paramas complete:^(NSError *error, NSDictionary *objectDic) {
        if (afterRequest) {
            afterRequest(objectDic);
        }
    }];
    
}
+ (void)fetchDataWithWebserviceInfo:(NSMutableDictionary *)serviceInfo andParamas:(NSMutableDictionary *)paramas Complete:(void(^)(id obj))afterRequest{

}
@end
