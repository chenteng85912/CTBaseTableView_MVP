//
//  CT_TableViewPrensenter.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTBaseTableViewPresenter.h"
#import "CTBaseTableViewProtocol.h"
#import "CTNetworkProtocol.h"
#import "CTBaseTableViewPresenterProtocol.h"
#import "CTNetworkService.h"

@interface CTBaseTableViewPresenter ()

//列表对应的数据模型
@property (strong, nonatomic) CTBaseTableViewModel *tableViewData;

//分页
@property (assign, nonatomic) NSInteger pageNo;
//分页大小  子类里面初始化（默认为50）
@property (strong, nonatomic) NSString *pageSize;

//网络请求方式
@property (assign, nonatomic) CTNetWorkRequestModal requestModal;

@end

@implementation CTBaseTableViewPresenter

#pragma mark -TYKYTableViewPresenterProtocol
- (void)initStartData {

    
   [self fetchDataComplete:^(NSError *error, id objectDic) {
     
       [self.tableViewData initStartTableViewData:objectDic];
       [self.tbViewVC reloadTableView:self.tableViewData.dataSourceArray];
//       [self.tbViewVC showTipView:StartInitDataModal];
       [self.tbViewVC reStupTableviewFooterView:_pageSize.integerValue];

       if ([self.tbViewVC respondsToSelector:@selector(loadDataSuccess)]) {
           [self.tbViewVC loadDataSuccess];
       }
       
   }];
    
}

- (void)loadMoreData {
    _pageNo++;

    [self fetchDataComplete:^(NSError *error, NSDictionary *objectDic) {
        [self.tableViewData initMoreTableViewData:objectDic];
        [self.tbViewVC reloadTableView:self.tableViewData.dataSourceArray];
        
//        [self.tbViewVC showTipView:LoadMoreDataModal];
        [self.tbViewVC reStupTableviewFooterView:_pageSize.integerValue];

    }];
}


#pragma mark -请求网络
- (void)fetchDataComplete:(void(^)(NSError *error, id objectDic))afterRequest{
    if (![_tbViewVC respondsToSelector:@selector(requestUrlString)]) {
        if (afterRequest) {
            afterRequest(nil,nil);
        }
        return;
    }
    
    CTRequest *request = [CTRequest creatNetworkRequest:_tbViewVC.requestUrlString requestModel:_tbViewVC.requestModal params:_tbViewVC.postParams];
    CTNetworkService <CTNetworkProtocol> *network = [CTNetworkService initWithRequest:request];
    if (self.presenterBlock) {
        self.presenterBlock(network);
    }
    [network startRequest:^(NSError *error, id objectDic) {
        afterRequest(error,objectDic);
        
    }];
    
}

- (CTBaseTableViewModel *)tableViewData{
    if (!_tableViewData) {
        _tableViewData = [CTBaseTableViewModel new];
        if ([_tbViewVC respondsToSelector:@selector(customeCellModelClassName)]) {
            _tableViewData.customeCellModelName = _tbViewVC.customeCellModelClassName;
            
        }
    }
    
    return _tableViewData;
}

- (CTNetWorkRequestModal)requestModal{
    if (!_requestModal) {
        if ([_tbViewVC respondsToSelector:@selector(requestModal)]) {
            _requestModal = _tbViewVC.requestModal;
        }else{
            _requestModal = CTPOSTRequestModal;
        }
    }
    return _requestModal;
}
@end
