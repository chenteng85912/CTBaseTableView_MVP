//
//  CT_TableViewCellModel.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CT_TableViewCellModel.h"

@implementation CT_TableViewCellModel

- (instancetype)initValueWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
//没有找到模型key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
