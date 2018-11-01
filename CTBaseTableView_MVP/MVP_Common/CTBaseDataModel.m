//
//  TYKYOriginDataModel.m
//  webhall
//
//  Created by tjsoft on 2017/4/12.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import "CTBaseDataModel.h"

@implementation CTBaseDataModel
+ (instancetype)initValueWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initValueWithDictionary:dic];
}
//kvc
- (instancetype)initValueWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            self.originDic = [dic mutableCopy];
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    return self;
}
//没有找到模型key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   
    if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]]) {
        self.originData = value;
    }else if ([key isEqualToString:@"error"]){
        self.errorMsg = value;
    }else{
    }
}

@end
