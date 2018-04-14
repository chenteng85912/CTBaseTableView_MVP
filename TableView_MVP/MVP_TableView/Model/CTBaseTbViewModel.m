//
//  CT_TableViewModel.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTBaseTbViewModel.h"
#import "CTBaseCellModel.h"
#import "CTBaseCellModelProtocol.h"

@implementation CTBaseTbViewModel

//初始化数据
- (void)initStartTableViewData:(id)tbViewData{
    [self.dataSourceArray removeAllObjects];
    [self p_initData:tbViewData];
}

//加载更多数据
- (void)initMoreTableViewData:(id)tbViewData{
    [self p_initData:tbViewData];
}

//生成数据模型
- (void)p_initData:(id)tbViewData{
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
                id <CTBaseCellModelProtocol> cellModel = [aclass new];
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
            id <CTBaseCellModelProtocol> cellModel = [aclass new];
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
#pragma mark lazy
- (NSMutableArray <CTBaseCellModel *> *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray new];
        
    }
    return _dataSourceArray;
}

@end
