//
//  CT_TableViewModel.h
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTBaseTableViewCellModel.h"

#define returnValue     @"returnValue"
#define CODE            @"code"
#define MESSAGE         @"msg"
#define DATA            @"data"

typedef NS_ENUM(NSInteger,RequesetStateModal){
    RequestSuccessModal=0,  //请求成功
    RequestTimeOutModal,    //请求超时
    RequestFailModal,       //请求失败
    NetworkHaveProblem      //网络错误
    
};

@interface CTBaseTableViewModel : NSObject

@property (strong, nonatomic) NSString *code;//状态码
@property (strong, nonatomic) NSString *message;//网络反馈信息
@property (strong, nonatomic) NSString *customeCellModelName;//自定义单元格模型类名

@property (strong, nonatomic) NSMutableArray <CTBaseTableViewCellModel *> *dataSourceArray;//表视图数据源,数据更新后复制给列表VC的dataArray;
@property (assign, nonatomic) RequesetStateModal requestState;//请求状态

//初始化表格数据《表格数据模型实现该方法》
- (void)initStartTableViewData:(id)tbViewData;

//加载更多表格数据《表格数据模型实现该方法》
- (void)initMoreTableViewData:(id)tbViewData;

@end
