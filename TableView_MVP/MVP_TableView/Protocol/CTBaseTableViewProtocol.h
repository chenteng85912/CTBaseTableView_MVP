//
//  CT_TableViewProtocol.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTBaseCellModel.h"

@class CTRequest;
typedef enum {
    StartInitDataModal=0,//初始化数据
    LoadMoreDataModal,//加载更多数据
    
} TableViewInitDataModal;

//-------------列表控制器基类代理---------------//

@protocol CTBaseTableViewProtocol <NSObject>
@optional

/**
 从子类获取带xib的自定义单元格类名称，用于父类列表注册
 
 @return 自定义单元格名称
 */
- (NSString *)customeCellNibName;

/**
 从子类获取不带xib的自定义单元格类名称，用于父类列表注册
 
 @return 自定义单元格名称
 */
- (NSString *)customeCellClassName;

/**
 采用系统单元格 从子类获取单元格身份标签
 
 @return 单元格身份标签
 */
- (NSString *)customeCellIdentifier;

/**
 获取子类自定义单元格模型类名称
 
 @return 单元格模型类名称
 */
- (NSString *)customeCellModelClassName;

/**
 表视图样式
 
 @return 表视图样式
 */
- (UITableViewStyle)tableViewStyle;

//是否集成下拉刷新
- (BOOL)makeMJRefresh;

@end

//-------------列表控制器子类Delegate代理---------------//
@protocol CTBaseTableViewDelegateProtocol <UITableViewDelegate>

/**
 数据初始化加成功
 */
- (void)loadDataSuccess;
/**
 加载数据后 界面根据不同的加载状态 显示不同的toast提示
 
 @param requesetState 数据加载状态
 */
- (void)showTipView:(RequesetStateModal)requesetState;

/**
 刷新数据
 
 @param dataArray 已经经过处理的模型数据
 */
- (void)reloadTableView:(NSMutableArray <CTBaseCellModel *>*)dataArray;

/**
 重置单元格底部视图
 
 @param pageSize 分页大小
 */
- (void)reStupTableviewFooterView:(NSInteger)pageSize;

@end

//-------------列表控制器子类DataSource代理---------------//
@protocol CTBaseTableViewDataSourceProtocol <UITableViewDataSource>
@optional

/**
 从子类获取请求参数
 @return 请求参数 字典对象
 */
- (NSDictionary *)postParams;

/**
 从子类获取数据加载方式
 
 @return 数据加载方式 枚举
 */
- (CTNetWorkRequestModal)requestModal;

/**
 从子类 获取http请求地址
 
 @return http请求地址
 */
- (NSString *)httpsUrlString;

/**
 从子类 获取存储到本地的字段
 
 @return 数据存储的KEY
 */
- (NSString *)saveLocalDataKey;

//获取分页大小

/**
 从子类 获取分页大小 默认是50
 
 @return 分页大小
 */
- (NSString *)pageSize;

/**
 自定义单元格 当采用系统单元格时 必须实现该代理方法
 
 @param tableView 列表对象
 @param indexPath indexPath对象
 @return 返回单元格对象
 */
- (UITableViewCell*)CTBaseTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end


