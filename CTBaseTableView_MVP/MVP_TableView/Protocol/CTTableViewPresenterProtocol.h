//
//  TYKYTableViewPresenterProtocol.h
//  MVPProject
//
//  Created by Apple on 2017/1/24.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTTableViewProtocol.h"

@protocol CTTableViewPresenterProtocol <NSObject>

+ (instancetype)initWithTableViewController:(UIViewController <CTTableViewDelegateProtocol,CTTableViewDataSourceProtocol>*)viewController;

/**
 初始化数据
 */
- (void)fetchData;

@end
