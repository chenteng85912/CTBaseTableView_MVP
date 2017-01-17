//
//  CT_TableViewCellProtocol.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CT_TableViewCellModelProtocol.h"

@protocol CT_TableViewCellProtocol <NSObject>

@optional

//单元格数据处理和界面布局《单元格实现该方法》
- (void)processCellData:(id <CT_TableViewCellModelProtocol>)data;

@end
