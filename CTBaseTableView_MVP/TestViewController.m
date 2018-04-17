//
//  TestViewController.m
//  CTBaseTableView_MVP
//
//  Created by 陈腾 on 2018/4/17.
//  Copyright © 2018年 腾. All rights reserved.
//

#import "TestViewController.h"
#import "CTTableViewPresenter.h"
#import "TestCellModel.h"
#import "TestTableViewCell.h"

@interface TestViewController ()<CTTableViewDelegateProtocol,CTTableViewDataSourceProtocol>

@property (nonatomic, strong) CTTableViewPresenter *presenter;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _presenter = [CTTableViewPresenter initWithTableViewController:self];
    
    [_presenter fetchData];
    // Do any additional setup after loading the view.
}
/**
 获取请求参数
 @return 请求参数 字典对象
 */
- (NSDictionary *)postParams{
    NSDictionary *dic = @{@"":@""};
    return dic;
}

/**
 请求地址
 
 @return 请求地址
 */
- (NSString *)requestUrlString{
    return @"";
}

- (NSString *)requestModal{
    return @"POST";
}
- (NSString *)customeCellClassName{
    return NSStringFromClass([TestTableViewCell class]);
}

- (NSString *)customeCellModelClassName{
    return NSStringFromClass([TestCellModel class]);
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)data{
    NSLog(@"seleted cell indexPath :%@",indexPath);
}
@end
