//
//  NetworkService.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CT_TableviewNetworkProtocol.h"

#define SOAP_METHODNAME     @"soapMethodName"
#define METHODNAME          @"methodName"
#define CHILD_URL           @"childUrl"
#define SERVICE_METHOD      @"ServiceMethod"

#define URL_STR             @"urlStr"
#define PAGE_SIZE_REQUEST   @"pageSize"

typedef enum {
    HttpsRequestModal=0,    //http请求
    WebserviceRequestModal, //webservice请求
    InitLocalDataModal,     //加载本地数据
    
} NetWorkRequesetModal;

@interface NetworkService : NSObject<CT_TableviewNetworkProtocol>

@end
