//
//  CT_RootTableViewController.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTBaseTableViewProtocol.h"
#import "CTBaseTableViewPresenter.h"
#import "MJRefresh.h"

@class CTBaseTableViewCellModel;

@interface CTBaseTableViewController : UIViewController<CTBaseTableViewDelegateProtocol,CTSubTableViewDataSourceProtocol>

//列表数据源
@property (strong, nonatomic) NSMutableArray <CTBaseTableViewCellModel *>*dataArray;


@end
