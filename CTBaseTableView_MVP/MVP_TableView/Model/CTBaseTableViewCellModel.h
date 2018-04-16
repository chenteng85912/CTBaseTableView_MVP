//
//  CT_TableViewCellModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTBaseTableViewCellModelProtocol.h"

@interface CTBaseTableViewCellModel : NSObject<CTBaseTableViewCellModelProtocol>

//原始数据
@property (nonatomic, copy) NSDictionary *originCellInfo;

//单元格高度 默认50
@property (nonatomic, assign) CGFloat cellHeight;

@end
