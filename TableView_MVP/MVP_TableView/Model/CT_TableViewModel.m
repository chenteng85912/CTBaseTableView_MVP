//
//  CT_TableViewModel.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CT_TableViewModel.h"
#import "CT_TableViewCellModel.h"
#import "CT_SuperTableViewController.h"

@implementation CT_TableViewModel

- (NSMutableArray <CT_TableViewCellModel*>*)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray new];
        
    }
    return _dataSourceArray;
}

//初始化数据
- (void)initStartTableViewData:(id)tbViewData{
    [self.dataSourceArray removeAllObjects];
    [self initData:tbViewData];
}
//加载更多数据
- (void)initMoreTableViewData:(id)tbViewData{
    [self initData:tbViewData];
}

//生成数据模型
- (void)initData:(id)tbViewData{
    self.code = [tbViewData valueForKey:CODE];
    if (self.code.integerValue==200) {
        self.requestState = RequestSuccessModal;
    }
    self.message = [tbViewData valueForKey:MESSAGE];
    
    id value = [tbViewData valueForKey:DATA];
    
    if ([value isKindOfClass:[NSArray class]]) {
        if (!self.customeCellModelName) {
            return;
        }
        for (id valueData in value) {
          
            Class  aclass = NSClassFromString(self.customeCellModelName);
            if (aclass)
            {
                id <CT_TableViewCellModelProtocol> cellModel = [aclass new];
                if ([cellModel respondsToSelector:@selector(initValueWithDictionary:)]) {
                    cellModel = [cellModel initValueWithDictionary:valueData];
                    if ([cellModel respondsToSelector:@selector(calculateSizeConstrainedToSize:)]) {
                        [cellModel calculateSizeConstrainedToSize:CGSizeZero];

                    }
                }
                [self.dataSourceArray addObject:cellModel];
                
            }
            
        }
    }
}
//加载本地数据
- (void)initLocalData:(NSArray *)localArray{
    if (!localArray) {
        return;
    }
    if (!self.customeCellModelName) {
        return;
    }
    for (id valueData in localArray) {
        
        Class  aclass = NSClassFromString(self.customeCellModelName);
        if (aclass)
        {
            id <CT_TableViewCellModelProtocol> cellModel = [aclass new];
            if ([cellModel respondsToSelector:@selector(initValueWithDictionary:)]) {
                cellModel = [cellModel initValueWithDictionary:valueData];
                if ([cellModel respondsToSelector:@selector(calculateSizeConstrainedToSize:)]) {
                    [cellModel calculateSizeConstrainedToSize:CGSizeZero];
                    
                }
            }
            [self.dataSourceArray addObject:cellModel];
            
        }
        
    }
}
//字典过滤
//- (NSMutableDictionary *)fitterDic:(NSDictionary *)dic{
//    NSMutableDictionary *newDic = [dic mutableCopy];
//    for (NSString *key in newDic.allKeys) {
//        id value = newDic[key];
//        if (!value|[value isKindOfClass:[NSNull class]]) {
//            [newDic setObject:@"" forKey:key];
//        }
//    }
//    return newDic;
//}
@end
