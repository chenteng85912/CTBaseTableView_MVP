//
//  CT_TableViewProtocol.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTBaseViewControllerProtocol.h"

@protocol CTTableViewDelegateProtocol <CTBaseViewControllerDelegateProtocol>

@optional

/**
 数据初始化加成功
 */
- (void)loadDataSuccess;

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)data;

@end

@protocol CTTableViewDataSourceProtocol <CTBaseViewControllerDataSourceProtocol>

@optional

/**
 获取带xib的自定义单元格类名称，用于父类列表注册
 
 @return 自定义单元格名称
 */
- (NSString *)customeCellNibName;

/**
 获取不带xib的自定义单元格类名称，用于父类列表注册
 
 @return 自定义单元格名称
 */
- (NSString *)customeCellClassName;


/**
 获取自定义单元格模型类名称
 
 @return 单元格模型类名称
 */
- (NSString *)customeCellModelClassName;

/**
 表视图样式
 
 @return 表视图样式
 */
- (UITableViewStyle)tableViewStyle;


/**
 tableview frame

 @return frame
 */
- (CGRect)tableViewFrame;


/**
 分页大小

 @return 分页大小 默认为50；
 */
- (NSString *)pageSize;

/**
 是否集成下拉刷新

 @return 是否集成下拉刷新
 */
- (BOOL)makeMJRefresh;

/**
 自定义单元格 当采用系统单元格时 必须实现该代理方法
 
 @param tableView 列表对象
 @param indexPath indexPath对象
 @return 返回单元格对象
 */
- (UITableViewCell*)CTBaseTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end


