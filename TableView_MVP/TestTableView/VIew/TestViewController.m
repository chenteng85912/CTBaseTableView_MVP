//
//  TestViewController.m
//  TableView_MVP
//
//  Created by 腾 on 2017/1/15.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "TestViewController.h"
#import "TableViewCell.h"
#import "NavigateManager.h"
#import "TestCellModel.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)loadView {
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

//网络请求方式
- (NetWorkRequesetModal)requestModal{
    return HttpsRequestModal;
}

#pragma mark  CT_TableViewProtocol
//设置webservice请求方法
- (NSMutableDictionary *)getWebserviceRequestInfo{
    NSMutableDictionary *webservice = [NSMutableDictionary new];
    [webservice setObject:@"" forKey:METHODNAME];
    [webservice setObject:@"" forKey:CHILD_URL];
    [webservice setObject:@"" forKey:SOAP_METHODNAME];
    [webservice setObject:@"" forKey:SERVICE_METHOD];

    [webservice setObject:@"50" forKey:PAGE_SIZE_REQUEST];

    return webservice;
}

//设置http请求方法
- (NSMutableDictionary *)getHttpsRequestInfo{
    NSMutableDictionary *tbInfo = [NSMutableDictionary new];
    [tbInfo setObject:@"50" forKey:PAGE_SIZE_REQUEST];
    [tbInfo setObject:@"http://unilink.changchun.gov.cn:8000/services/interAction/findPageItems" forKey:URL_STR];
    
    return tbInfo;
}
//获取自定义单元格类名称
- (NSString *)getCustomeTableViewCellClassName{
    return NSStringFromClass([TableViewCell class]);
}
//获取自定义单元格模型类名称
- (NSString *)getCustomeCellModelClassName{
    return NSStringFromClass([TestCellModel class]);
}
//请求参数 不用设置分页和页码（父类已经设置）
- (NSMutableDictionary *)makePostParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"query"  forKey:@"type"];
    [params setObject:@"65698"  forKey:@"userId"];

    return params;
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id <CT_TableViewCellModelProtocol> model = self.dataArray[indexPath.row];
    TableViewCell <CT_TableViewCellProtocol>*mycell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    [mycell processCellData:model];
    return mycell;
}

//单元格点击动作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TestViewController *test = [TestViewController new];
    [NavigateManager pushViewController:test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
