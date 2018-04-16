//
//  CT_RootTableViewController.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CTBaseTableViewController.h"
#import "CTBaseTableViewCellModel.h"
#import "CTBaseTableViewCellProtocol.h"
#import "CTRequestQueueManager.h"

#define CT_SUBCLASS_RESPONSE(Pselector) [self respondsToSelector:@selector(Pselector)]

#define CT_WEAKSELF      __weak typeof(self) weakSelf = self

@interface CTBaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

//上一次单元格数量
@property (assign, nonatomic) NSInteger oldDataNum;

//是否集成下拉刷新
@property (assign, nonatomic) BOOL mjRefresh;

//调度
@property (strong, nonatomic) CTBaseTableViewPresenter *presenter;

@end

@implementation CTBaseTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self p_initTableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (CT_SUBCLASS_RESPONSE(tableViewFrame)) {
        self.tableView.frame = self.tableViewFrame;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - TableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CT_SUBCLASS_RESPONSE(CTBaseTableView:cellForRowAtIndexPath:)) {
    
        return [self CTBaseTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    CTBaseTableViewCellModel <CTBaseTableViewCellModelProtocol> *model = self.dataArray[indexPath.row];
    
    NSString *cellIdentifier = nil;
    if (CT_SUBCLASS_RESPONSE(customeCellNibName)) {
        cellIdentifier = self.customeCellNibName;
    }
    if (CT_SUBCLASS_RESPONSE(customeCellClassName)) {
        cellIdentifier = self.customeCellClassName;
    }
    if (CT_SUBCLASS_RESPONSE(customeCellIdentifier)) {
        cellIdentifier = self.customeCellIdentifier;
    }
    
    id <CTBaseTableViewCellProtocol> cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
    if ([cell respondsToSelector:@selector(processCellData:indexPath:)]) {
        [cell processCellData:model indexPath:indexPath];
        
    }
    return (UITableViewCell*)cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CTBaseTableViewCellModel <CTBaseTableViewCellModelProtocol> *model = self.dataArray[indexPath.row];
    return model.cellHeight;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.001;
}

#pragma mark - TYKYTableViewProtocol
//重置上拉刷新
- (void)reStupTableviewFooterView:(NSInteger)pageSize{
    
    if (!_mjRefresh) {
        return;
    }
    if (self.dataArray.count%pageSize) {
        if (self.dataArray.count>0) {
            //添加无更多数据的提示
            [_tableView.mj_footer endRefreshingWithNoMoreData];

        }
    }else{
        if (_oldDataNum!=self.dataArray.count) {
            _oldDataNum = self.dataArray.count;

        }else{
            if (self.dataArray.count>0) {
                //添加无更多数据的提示
                [_tableView.mj_footer endRefreshingWithNoMoreData];

            }
        }
        
    }
}
//刷新数据
- (void)reloadTableView:(NSMutableArray <CTBaseTableViewCellModel *>*)dataArray{

    if (_mjRefresh) {
        [self.tableView.mj_header endRefreshing];

    }

    self.dataArray = dataArray;
    [self.tableView reloadData];

}

#pragma mark -private methods 列表初始化
- (void)p_initTableView{
    
    if (CT_SUBCLASS_RESPONSE(customeCellNibName)&&self.customeCellNibName) {
        
        [self.tableView registerNib:[UINib nibWithNibName:self.customeCellNibName bundle:nil]
                forCellReuseIdentifier:self.customeCellNibName];
    }
    if (CT_SUBCLASS_RESPONSE(customeCellClassName)&&self.customeCellClassName) {
        
        [self.tableView registerClass:NSClassFromString(self.customeCellClassName)
               forCellReuseIdentifier:self.customeCellClassName];
    }
    
    if (CT_SUBCLASS_RESPONSE(customeCellIdentifier)&&self.customeCellIdentifier) {
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:self.customeCellIdentifier];
    }
    
    if (CT_SUBCLASS_RESPONSE(makeMJRefresh)) {
        _mjRefresh = self.makeMJRefresh;
        if (_mjRefresh) {
            self.tableView.mj_header = [self p_makeMJRefeshWithTarget:self andMethod:@selector(p_initStartData)];
            CT_WEAKSELF;
            self.tableView.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
                [weakSelf p_loadMoreData];
            }];
        }
        
    }

}

#pragma mark -private methods 加载数据
//刷新数据
- (void)fetchData{
    if (_mjRefresh) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self p_initStartData];
    }
}
//首次从网络请求数据
- (void)p_initStartData{
    
    //获取列表数据，网络请求、或者到本地去取
    _oldDataNum = 0;
    [self.presenter initStartData];

}
//请求更多数据
- (void)p_loadMoreData{
    [self.presenter loadMoreData];
 
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

#pragma mark - getters and setters
- (NSMutableArray <CTBaseTableViewCellModel *>*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableViewStyle tbViewStyle = UITableViewStylePlain;
        if (CT_SUBCLASS_RESPONSE(tableViewStyle)) {
            tbViewStyle = [self tableViewStyle];
            
        }
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
 
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:tbViewStyle];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
- (CTBaseTableViewPresenter *)presenter{
    if (!_presenter) {
        _presenter = [CTBaseTableViewPresenter new];
        _presenter.tbViewVC = self;
        CT_WEAKSELF;
        _presenter.presenterBlock = ^(id<CTNetworkProtocol> network) {
            NSString *name = [NSString stringWithUTF8String:object_getClassName(weakSelf)];
            [CTRequestQueueManager setRequestOperation:network forKey:name];
            NSLog(@"成功初始化网络请求对象--------%@",name);

        };
    }
    return _presenter;
}

@end
