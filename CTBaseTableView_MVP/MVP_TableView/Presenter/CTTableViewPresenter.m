//
//  CT_TableViewPrensenter.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/22.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTTableViewPresenter.h"
#import "CTTableViewProtocol.h"
#import "CTNetworkService.h"
#import "CTBaseTableViewModel.h"
#import "CTBaseTableViewCellProtocol.h"
#import "MJRefresh.h"
#import "CTRequestQueueManager.h"

@interface CTTableViewPresenter ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIViewController <CTTableViewDelegateProtocol,CTTableViewDataSourceProtocol> *tbViewController;

@property (nonatomic, strong) UITableView *tableView;

//列表对应的数据模型
@property (strong, nonatomic) CTBaseTableViewModel *tableViewData;

@property (assign, nonatomic) BOOL mjRefresh;
//分页
@property (assign, nonatomic) NSInteger pageNo;
@property (copy, nonatomic)   NSString *pageSize;
@property (nonatomic, assign) NSInteger oldDataNum;

@end

@implementation CTTableViewPresenter

#pragma mark -CTTableViewPresenterProtocol
+ (instancetype)initWithTableViewController:(UIViewController <CTTableViewDelegateProtocol,CTTableViewDataSourceProtocol>*)viewController{
    return [[self alloc] initWithTableViewController:viewController];
}
- (instancetype)initWithTableViewController:(UIViewController <CTTableViewDelegateProtocol,CTTableViewDataSourceProtocol>*)viewController{
    self = [super init];
    if (self) {
        _tbViewController = viewController;
        if (CT_SUBCLASS_RESPONSE(_tbViewController, pageSize)) {
            _pageSize = _tbViewController.pageSize? _tbViewController.pageSize : @"50";
        }
    }
    return self;
}


- (void)fetchData {
    if (_mjRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self p_fetchData];
    }
  
}

- (void)p_fetchData{
    _oldDataNum = 0;
    _pageNo = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_tbViewController.postParams];
    [dic setObject:@(_pageNo) forKey:@"pageNo"];
    CT_WEAKSELF;

    [self attempRequest:dic complete:^(NSError *error, id objectDic) {
        [weakSelf.tableViewData initStartTableViewData:objectDic];
        [weakSelf.tableView reloadData];
        [weakSelf reStupTableviewFooterView];

    }];
}
- (void)p_fetchMoreData {
    _pageNo++;
    
    CT_WEAKSELF;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_tbViewController.postParams];
    [dic setObject:@(_pageNo) forKey:@"pageNo"];
    [self attempRequest:dic complete:^(NSError *error, id objectDic) {
        [weakSelf.tableViewData initMoreTableViewData:objectDic];
        [weakSelf.tableView reloadData];
        
        [weakSelf reStupTableviewFooterView];

    }];
}
- (void)attempRequest:(NSDictionary *)params complete:(CTRequestBlock)complete{
    if (!_tbViewController) {
        return;
    }
    if (!CT_SUBCLASS_RESPONSE(_tbViewController, requestUrlString)||!_tbViewController.requestUrlString) {
        return;
    }
    
    CTNetWorkRequestModal requestModal = CTPOSTRequestModal;
    if (!CT_SUBCLASS_RESPONSE(_tbViewController, requestModal)&&![_tbViewController.requestModal isEqualToString:@"GET"]) {
        requestModal = CTGETRequestModal;
    }
    if (requestModal==CTPOSTRequestModal) {
        if ((CT_SUBCLASS_RESPONSE(_tbViewController, postParams)&&!_tbViewController.postParams)
            ||!CT_SUBCLASS_RESPONSE(_tbViewController, postParams)) {
            return;
        }
    }
    
    CTRequest *request = [CTRequest creatNetworkRequest:_tbViewController.requestUrlString requestModel:requestModal params:_tbViewController.postParams];
    CTNetworkService <CTNetworkProtocol> *network = [CTNetworkService initWithRequest:request];
    
    //保持请求对象 可以后续取消
    NSString *name = [NSString stringWithUTF8String:object_getClassName(_tbViewController)];
    [CTRequestQueueManager setRequestOperation:network forKey:name];
    
    [network startRequest:^(NSError *error, id objectDic) {
        if (complete) {
            complete(error,objectDic);
        }
        
        //完成后移除请求对象
        [CTRequestQueueManager cancelRequestOperation:name];
    }];
}
#pragma mark - TYKYTableViewProtocol
//重置上拉刷新
- (void)reStupTableviewFooterView{
    
    if (!_mjRefresh) {
        return;
    }
    self.tableView.mj_footer = nil;
    NSInteger totalNum = self.tableViewData.dataSourceArray.count;

    if (totalNum%_pageSize.integerValue>0) {
        if (totalNum>0) {
            //添加无更多数据的提示
            
        }
    }else{
        if (_oldDataNum!=totalNum) {
            _oldDataNum = totalNum;
        
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(p_fetchMoreData)];
            
            
        }else{
            self.tableView.mj_footer = nil;
            if (totalNum>0) {
                //添加无更多数据的提示
            }
        }
        
    }
}
#pragma mark - TableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CT_SUBCLASS_RESPONSE(_tbViewController,CTBaseTableView:cellForRowAtIndexPath:)) {
        
        return [_tbViewController CTBaseTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    NSString *cellIdentifier = nil;
    if (CT_SUBCLASS_RESPONSE(_tbViewController,customeCellNibName)) {
        cellIdentifier = _tbViewController.customeCellNibName;
    }
    if (CT_SUBCLASS_RESPONSE(_tbViewController,customeCellClassName)) {
        cellIdentifier = _tbViewController.customeCellClassName;
    }
    
    id <CTBaseTableViewCellProtocol> cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return (UITableViewCell*)cell;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{    CTBaseTableViewCellModel <CTBaseTableViewCellModelProtocol> *model = self.tableViewData.dataSourceArray[indexPath.row];

    id <CTBaseTableViewCellProtocol> mycell = (id <CTBaseTableViewCellProtocol>)cell;
    
    if ([mycell respondsToSelector:@selector(processCellData:indexPath:)]) {
        [mycell processCellData:model indexPath:indexPath];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CTBaseTableViewCellModel  *model = self.tableViewData.dataSourceArray[indexPath.row];
    return model.cellHeight;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CTBaseTableViewCellModel  *model = self.tableViewData.dataSourceArray[indexPath.row];
    if (CT_SUBCLASS_RESPONSE(_tbViewController, didSelectRowAtIndexPath:data:)) {
        [_tbViewController didSelectRowAtIndexPath:indexPath data:model];
    }
}
- (void)p_initTableView{
    
    if (CT_SUBCLASS_RESPONSE(_tbViewController,customeCellNibName)&&_tbViewController.customeCellNibName) {
        
        [self.tableView registerNib:[UINib nibWithNibName:_tbViewController.customeCellNibName bundle:nil]
             forCellReuseIdentifier:_tbViewController.customeCellNibName];
    }
    if (CT_SUBCLASS_RESPONSE(_tbViewController,customeCellClassName)&&_tbViewController.customeCellClassName) {
        
        [self.tableView registerClass:NSClassFromString(_tbViewController.customeCellClassName)
               forCellReuseIdentifier:_tbViewController.customeCellClassName];
    }
    
    if (CT_SUBCLASS_RESPONSE(_tbViewController,makeMJRefresh)) {
        _mjRefresh = _tbViewController.makeMJRefresh;
        if (_mjRefresh) {
            self.tableView.mj_header = [self p_makeMJRefeshWithTarget:self andMethod:@selector(p_fetchData)];

        }
        
    }
    
}
#pragma mark -private methods 设置明杰刷新
- (MJRefreshNormalHeader *)p_makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc]init];
    [header setTitle:@"继续下拉以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10];
    //    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    
    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.stateLabel.textColor = [UIColor blackColor];
    
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    return header;
}
#pragma mark - lazy
- (CTBaseTableViewModel *)tableViewData{
    if (!_tableViewData) {
        _tableViewData = [CTBaseTableViewModel new];
        if ([_tbViewController respondsToSelector:@selector(customeCellModelClassName)]) {
            _tableViewData.customeCellModelName = _tbViewController.customeCellModelClassName;
            
        }
    }
    
    return _tableViewData;
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableViewStyle tbViewStyle = UITableViewStylePlain;
        if (CT_SUBCLASS_RESPONSE(_tbViewController,tableViewStyle)) {
            tbViewStyle = _tbViewController.tableViewStyle;
            
        }
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
      
        _tableView = [[UITableView alloc] initWithFrame:_tbViewController.view.bounds style:tbViewStyle];
        if (CT_SUBCLASS_RESPONSE(_tbViewController,tableViewFrame)) {
            _tableView.frame = _tbViewController.tableViewFrame;
        }
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        [_tbViewController.view addSubview:_tableView];
        
    }
    return _tableView;
}

@end
