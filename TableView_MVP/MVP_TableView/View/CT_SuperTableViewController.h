//
//  CT_RootTableViewController.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CT_TableViewProtocol.h"
#import "CT_TableViewModelProtocol.h"
#import "CT_TableViewModel.h"
#import "NetworkService.h"
#import "MJRefresh.h"

@class CT_TableViewCellModel;
@interface CT_SuperTableViewController : UITableViewController<CT_TableViewProtocol>

//表视图数据源
@property (strong, nonatomic) NSMutableArray <CT_TableViewCellModel *>*dataArray;
//列表对应的数据模型
@property (strong, nonatomic) CT_TableViewModel <CT_TableViewModelProtocol>*tableViewData;
//网络请求方式
@property (assign, nonatomic) NetWorkRequesetModal requestModal;
//首次从网络请求数据
- (void)initStartData;
//页面加载一次
@property (assign, nonatomic) BOOL isLoad;
@end
