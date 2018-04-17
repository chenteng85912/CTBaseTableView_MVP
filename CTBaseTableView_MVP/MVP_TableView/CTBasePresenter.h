//
//  CTBasePresenter.h
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTBasePresenterProtocol.h"

@interface CTBasePresenter : NSObject<CTBasePresenterProtocol>
{
    
    //MVP中负责更新的视图
    __weak  UIViewController <CTBaseViewControllerDelegateProtocol,CTBaseViewControllerDataSourceProtocol> * _viewController;
    
}


@end
