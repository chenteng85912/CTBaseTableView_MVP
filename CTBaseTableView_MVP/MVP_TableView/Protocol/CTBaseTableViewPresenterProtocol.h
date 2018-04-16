//
//  TYKYTableViewPresenterProtocol.h
//  MVPProject
//
//  Created by Apple on 2017/1/24.
//  Copyright © 2017年 Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CTBaseTableViewPresenterProtocol <NSObject>

/**
 初始化数据
 */
- (void)initStartData;

/**
加载更多数据
 */
- (void)loadMoreData;


@end
