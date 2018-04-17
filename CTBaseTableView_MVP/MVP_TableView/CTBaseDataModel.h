//
//  TYKYOriginDataModel.h
//  webhall
//
//  Created by tjsoft on 2017/4/12.
//  Copyright © 2017年 深圳太极云软有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTBaseDataModel : NSObject

@property (strong, nonatomic) NSDictionary *originDic;

@property (strong, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) id originData;

+ (instancetype)initValueWithDictionary:(NSDictionary *)dic;

@end
