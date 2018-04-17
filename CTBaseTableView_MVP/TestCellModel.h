//
//  TestCellModel.h
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import "CTBaseTableViewCellModel.h"

@interface TestCellModel : CTBaseTableViewCellModel
/**
 联系人姓名
 */
@property(nonatomic,copy)NSString *contactName;
/**
 联系电话
 */
@property(nonatomic,copy)NSString *contactNumber;

@end
