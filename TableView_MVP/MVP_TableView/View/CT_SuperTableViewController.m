//
//  CT_RootTableViewController.m
//  TableView_MVP
//
//  Created by Apple on 2017/1/16.
//  Copyright © 2017年 腾. All rights reserved.
//

#import "CT_SuperTableViewController.h"
#import "CT_TableViewCellModel.h"
#import "CT_TableViewModel.h"

NSString *const PAGENO = @"pageNo";
NSString *const PAGESIZE = @"pageSize";

@interface CT_SuperTableViewController ()

//分页
@property (assign, nonatomic) NSInteger pageNo;
//分页大小
@property (strong, nonatomic) NSString *pageSize;
//网络请求参数
@property (strong, nonatomic) NSMutableDictionary *paramas;
//上一次单元格数量
@property (assign, nonatomic) NSInteger oldDataNum;
//网络请求地址
@property (strong, nonatomic) NSString *requesetUrlStr;


@end

@implementation CT_SuperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
 
    [self getDataFromSubClass];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_isLoad) {
        _isLoad = YES;
        [self.tableView.mj_header beginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 }
//初始化数据
- (void)getDataFromSubClass{
    if (self.requestModal==WebserviceRequestModal) {
        if ([self respondsToSelector:@selector(getWebserviceRequestInfo)]) {
            self.pageSize = [self getWebserviceRequestInfo][PAGE_SIZE_REQUEST];
            
        }
    }else if (self.requestModal==HttpsRequestModal){
        if ([self respondsToSelector:@selector(getHttpsRequestInfo)]) {
            NSMutableDictionary *tbInfo = [self getHttpsRequestInfo];
            self.requesetUrlStr = tbInfo[URL_STR];
            self.pageSize = tbInfo[PAGE_SIZE_REQUEST];
        }
    }else{
        //加载本地数据
    }
    
    if ([self respondsToSelector:@selector(getCustomeTableViewCellClassName)]) {
        [self.tableView registerNib:[UINib nibWithNibName:[self getCustomeTableViewCellClassName] bundle:nil] forCellReuseIdentifier:[self getCustomeTableViewCellClassName]];
        
    }
    if ([self respondsToSelector:@selector(getCustomeCellModelClassName)]) {
        self.tableViewData.customeCellModelName = [self getCustomeCellModelClassName];
        
    }
    
    self.tableView.mj_header = [self makeMJRefeshWithTarget:self andMethod:@selector(initStartData)];

}

//懒加载 请求参数 初始化分页大小
- (NSMutableDictionary *)paramas{
    if (!_paramas) {
       
        _paramas = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    self.pageSize,PAGESIZE,nil];
    }
    return _paramas;
}
//懒加载 列表数据大模型
- (CT_TableViewModel*)tableViewData{
    if (!_tableViewData) {
        _tableViewData = [CT_TableViewModel new];
    }
    return _tableViewData;
}
//懒加载 单元格数据模型
- (NSMutableArray <CT_TableViewCellModel *>*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

//首次从网络请求数据
- (void)initStartData{
    
    //加载本地数据
    if (self.requestModal==InitLocalDataModal) {
        [self.tableView.mj_header endRefreshing];

        if ([self respondsToSelector:@selector(getLocalData)]) {
            [self.tableViewData initLocalData:[self getLocalData]];
            [self initTableViewDataSource:self.tableViewData.dataSourceArray];
            if ([self respondsToSelector:@selector(showTipViewWithType:)]) {
                [self showTipViewWithType:StartInitDataModal];
                
            }
        }
       
        return;
    }
    
    if (!self.requesetUrlStr&&self.requestModal==HttpsRequestModal) {
        return;
    }
    _pageNo = 1;
    _oldDataNum = 0;
    [self.paramas setObject:[NSString stringWithFormat:@"%ld",(long)_pageNo] forKey:PAGENO];
    if ([self respondsToSelector:@selector(makePostParams)]) {
        [self.paramas setValuesForKeysWithDictionary:[self makePostParams]];
        
    }
    self.tableView.mj_footer = nil;
    __weak typeof (self)weakSelf = self;
    [self fetchDataComplete:^(id obj) {
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.tableViewData initStartTableViewData:obj];
        [weakSelf initTableViewDataSource:weakSelf.tableViewData.dataSourceArray];

        [weakSelf reStupTableviewFooterView];
        
        if ([weakSelf respondsToSelector:@selector(showTipViewWithType:)]) {
            [weakSelf showTipViewWithType:StartInitDataModal];
            
        }
    }];
    
}
//请求更多数据
- (void)loadMoreData{
    if (!self.requesetUrlStr&&self.requestModal==HttpsRequestModal) {
        return;
    }
    _pageNo++;
    [self.paramas setObject:[NSString stringWithFormat:@"%ld",(long)_pageNo] forKey:PAGENO];
    
    __weak typeof (self)weakSelf = self;
    [self fetchDataComplete:^(id obj) {
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [weakSelf.tableViewData initMoreTableViewData:obj];

        [weakSelf initTableViewDataSource:weakSelf.tableViewData.dataSourceArray];
        [weakSelf reStupTableviewFooterView];
        
        if ([weakSelf respondsToSelector:@selector(showTipViewWithType:)]) {
            [weakSelf showTipViewWithType:StartInitDataModal];
            
        }
    }];
    
}
//请求网络
- (void)fetchDataComplete:(void(^)(id obj))afterRequest{
    if (self.requestModal==HttpsRequestModal) {
        [NetworkService fetchDataWithUrlStr:self.requesetUrlStr andParamas:self.paramas Complete:^(id obj) {
            if (afterRequest) {
                afterRequest(obj);
            }
        }];
    }else if (self.requestModal==WebserviceRequestModal){
      
        if ([self respondsToSelector:@selector(getWebserviceRequestInfo)]) {
            [self.paramas removeObjectForKey:PAGENO];
            [self.paramas removeObjectForKey:PAGESIZE];
            [NetworkService fetchDataWithWebserviceInfo:[self getWebserviceRequestInfo] andParamas:self.paramas Complete:^(id obj) {
                if (afterRequest) {
                    afterRequest(obj);
                }
            }];
        }
      
    }
  
}
//刷新数据
- (void)initTableViewDataSource:(NSMutableArray <CT_TableViewCellModel *>*)dataArray{
    self.dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CT_TableViewCellModel <CT_TableViewCellModelProtocol> *model = self.dataArray[indexPath.row];
    return model.cellHeight;;
}

//重置上拉刷新
- (void)reStupTableviewFooterView{
    
    if (self.dataArray.count%self.pageSize.integerValue) {
        self.tableView.mj_footer = nil;
        if (self.dataArray.count>0) {
            
        }
    }else{
        if (_oldDataNum!=self.dataArray.count) {
            _oldDataNum = self.dataArray.count;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

        }else{
            self.tableView.mj_footer = nil;
            if (self.dataArray.count>0) {
                
            }
        }
        
    }
}

- (MJRefreshNormalHeader *)makeMJRefeshWithTarget:(id)root andMethod:(SEL)methodName{
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc]init];
    [header setTitle:@"继续下拉以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.stateLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
    header.lastUpdatedTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10];
    
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
    header.refreshingTarget = root;
    header.refreshingAction = methodName;
    return header;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
