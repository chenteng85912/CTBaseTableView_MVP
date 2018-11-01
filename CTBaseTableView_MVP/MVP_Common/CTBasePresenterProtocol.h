//
//  CTBasePresenterProtocol.h
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTBaseViewControllerProtocol.h"

@protocol CTBasePresenterProtocol <NSObject>

@optional
/**
 初始化presenter，并绑定控制器

 @param viewController 遵循CTBaseViewControllerProtocol协议的控制器
 @return 返回presenter对象
 */
+ (instancetype)initWithViewController:(UIViewController <CTBaseViewControllerDelegateProtocol,CTBaseViewControllerDataSourceProtocol>*)viewController;


/**
 绑定控制器 未通过上述工厂方法初始化presenter、或者需要重新绑定控制器时 使用该方法进行绑定

 @param viewController 遵循CTBaseViewControllerProtocol协议的控制器
 */
- (void)attachViewController:(UIViewController <CTBaseViewControllerDelegateProtocol,CTBaseViewControllerDataSourceProtocol> *)viewController;

/**
 解绑
 */
- (void)detachViewController;

/**
 开始网络请求 首次或者重新获取数据
 */
- (void)attempRequest:(CTRequestBlock)complete;

@end
