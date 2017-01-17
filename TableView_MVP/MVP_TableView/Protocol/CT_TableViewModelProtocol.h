//
//  CT_TableViewModelProtocol.h
//  webhall
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 深圳太极软件有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CT_TableViewModelProtocol <NSObject>

@optional

//初始化表格数据《表格数据模型实现该方法》
- (void)initStartTableViewData:(id)tbViewData;

//加载更多表格数据《表格数据模型实现该方法》
- (void)initMoreTableViewData:(id)tbViewData;

//加载本地数据
- (void)initLocalData:(NSArray *)localArray;
@end
