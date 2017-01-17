//
//  CT_TableViewCellModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CT_TableViewCellModelProtocol.h"

@interface CT_TableViewCellModel : NSObject<CT_TableViewCellModelProtocol>

@property (assign, nonatomic) CGFloat cellHeight;//单元格高度---自定义模型里面实现该协议方法

@end
