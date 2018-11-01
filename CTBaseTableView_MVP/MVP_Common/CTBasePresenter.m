//
//  CTBasePresenter.m
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import "CTBasePresenter.h"
#import "CTNetworkService.h"
#import "CTRequestQueueManager.h"
#import "CTBaseViewControllerProtocol.h"
#import "CTBaseDataModel.h"

NSInteger const kSuccessCode = 200;
@implementation CTBasePresenter

+ (instancetype)initWithViewController:(UIViewController <CTBaseViewControllerDataSourceProtocol,CTBaseViewControllerDelegateProtocol> *)viewController {
  
    return [[self alloc] initWithViewController:viewController];
}

- (instancetype)initWithViewController:(UIViewController<CTBaseViewControllerDataSourceProtocol,CTBaseViewControllerDelegateProtocol> *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)attachViewController:(UIViewController <CTBaseViewControllerDataSourceProtocol,CTBaseViewControllerDelegateProtocol> *)viewController {
    _viewController = viewController;
}

- (void)detachViewController {
    _viewController = nil;
}

- (void)attempRequest:(CTRequestBlock)complete {
    if (!_viewController) {
        return;
    }
    if (!CT_SUBCLASS_RESPONSE(_viewController, requestUrlString)||!_viewController.requestUrlString) {
        return;
    }
  
    CTNetWorkRequestModal requestModal = CTPOSTRequestModal;
    if (!CT_SUBCLASS_RESPONSE(_viewController, requestModal)&&![_viewController.requestModal isEqualToString:@"GET"]) {
          requestModal = CTGETRequestModal;
    }
    if (requestModal==CTPOSTRequestModal) {
        if ((CT_SUBCLASS_RESPONSE(_viewController, postParams)&&!_viewController.postParams)
            ||!CT_SUBCLASS_RESPONSE(_viewController, postParams)) {
            return;
        }
    }

    CTRequest *request = [CTRequest creatNetworkRequest:_viewController.requestUrlString requestModel:requestModal params:_viewController.postParams];
    CTNetworkService <CTNetworkProtocol> *network = [CTNetworkService initWithRequest:request];
    
    //保持请求对象 可以后续取消
    NSString *name = [NSString stringWithUTF8String:object_getClassName(_viewController)];
    [CTRequestQueueManager setRequestOperation:network forKey:name];
    
    CT_WEAKSELF;
    [network startRequest:^(NSError *error, id objectDic) {
        if (complete) {
            complete(error,objectDic);
        }
        [weakSelf showRequestResult:error resultObject:objectDic];
        
        //完成后移除请求对象
        [CTRequestQueueManager cancelRequestOperation:name];
    }];
}
- (void)showRequestResult:(NSError *)error resultObject:(NSDictionary *)objectDic {
    
    if (error.code==-1009) {
        if ([_viewController respondsToSelector:@selector(requestFail:)]) {
            
            [_viewController requestFail:error.localizedDescription];
        }
        return;
    }
    CTBaseDataModel *origin = [CTBaseDataModel initValueWithDictionary:objectDic];
    
    if (origin.code.integerValue!=kSuccessCode||error) {
        if (!origin.errorMsg) {
            origin.errorMsg = @"网络错误,请重试";
        }
        if ([_viewController respondsToSelector:@selector(requestFail:)]) {
            [_viewController requestFail:origin.errorMsg];
        }
        return;
    }
    
    if ([_viewController respondsToSelector:@selector(requestSuccess:)]) {
        [_viewController requestSuccess:origin.originData];
    }
}
- (void)dealloc {
    NSLog(@"%@------dealloc",NSStringFromClass(self.class));
}

@end
