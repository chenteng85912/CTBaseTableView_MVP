//
//  CT_TableViewCellModelProtocol.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTBaseCellModelProtocol <NSObject>

@optional

//kvc初始化模型《父类单元格模型 实现该协议方法》
- (instancetype)initValueWithDictionary:(NSDictionary *)cellInfo;

- (void)CTSetValue:(id)value forUndefinedKey:(NSString *)key;

//计算单元格高度《自定义单元格模型 实现该协议方法》
- (void)calculateSizeConstrainedToSize:(CGSize)size;

@end
