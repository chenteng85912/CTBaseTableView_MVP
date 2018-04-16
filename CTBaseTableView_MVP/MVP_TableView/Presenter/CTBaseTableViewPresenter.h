//
//  CT_TableViewPrensenter.h
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTBaseTableViewModel.h"
#import "CTBaseTableViewPresenterProtocol.h"

@protocol CTBaseTableViewDelegateProtocol;
@protocol CTSubTableViewDataSourceProtocol;
@protocol CTNetworkProtocol;
@protocol CTNetworkPCTBaseTableViewPresenterProtocolrotocol;

typedef void (^CTTbViewPresenterBlock) (id <CTNetworkProtocol> network);

@interface CTBaseTableViewPresenter : NSObject<CTBaseTableViewPresenterProtocol>

@property (weak, nonatomic) id <CTBaseTableViewDelegateProtocol,CTSubTableViewDataSourceProtocol>tbViewVC;//弱引用 避免循环引用



@property (strong, nonatomic) CTTbViewPresenterBlock presenterBlock;

@end
