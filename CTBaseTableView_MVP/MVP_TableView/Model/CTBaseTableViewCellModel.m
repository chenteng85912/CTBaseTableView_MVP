//
//  CT_TableViewCellModel.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTBaseTableViewCellModel.h"

@implementation CTBaseTableViewCellModel

- (instancetype)initValueWithDictionary:(NSDictionary *)cellInfo {
    self = [super init];
    if (self) {
        _originCellInfo = cellInfo;
        _cellHeight = 50;
        [self setValuesForKeysWithDictionary:cellInfo];
    }
    return self;
}
//没有找到模型key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([self respondsToSelector:@selector(CTSetValue:forUndefinedKey:)]) {
        [self CTSetValue:value forUndefinedKey:key];
    }
}
@end
