//
//  CT_TableViewProtocol.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    StartInitDataModal=0,//初始化数据
    LoadMoreDataModal,//加载更多数据
    
} TableViewInitDataModal;

@protocol CT_TableViewProtocol <NSObject>

@optional

//显示提示视图
- (void)showTipViewWithType:(TableViewInitDataModal)type;

//获取请求参数
- (NSMutableDictionary *)makePostParams;

//获取子类自定义单元格类名称
- (NSString *)getCustomeTableViewCellClassName;

//获取子类自定义单元格模型类名称
- (NSString *)getCustomeCellModelClassName;

//获取webservie请求方法 子方法名称 分页大小
- (NSMutableDictionary *)getWebserviceRequestInfo;

//获取http请求地址 分页大小
- (NSMutableDictionary *)getHttpsRequestInfo;

//重置上拉刷新
- (void)reStupTableviewFooterView;

//获取本地数据
- (NSArray *)getLocalData;

@end
