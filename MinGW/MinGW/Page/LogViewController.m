//
//  LogViewController.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "LogViewController.h"
#import "LogCell.h"
#import "DetailViewController.h"
#import "SetViewController.h"
#import "CacheUnit.h"
#import "NSData+YYAdd.h"

@interface LogViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *historyData;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleStr = @"history";
    self.leftButtonHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _historyData = [CacheUnit getHistoryList];
    if (! _historyData){
        _historyData = @[@{@"delay":@(1),@"download":@(0.436434),@"time":@(1668183354.453084),@"upload":@(0.01745853)},
        @{@"delay":@(24),@"download":@(0.336434),@"time":@(1668173434.453084),@"upload":@(0.01445853)}];
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"LogCell" bundle:nil] forCellReuseIdentifier:@"_cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(NAV_BAR_HEIGHT);
            make.bottom.mas_equalTo(-TAB_BAR_HEIGHT);
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _historyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    NSDictionary *dic = _historyData[indexPath.row];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dic[@"time"] doubleValue]];
    cell.dateLabel.text = [date stringWithFormat:@"MM:ss"];
    cell.delayLabel.text =  [NSString stringWithFormat:@"%.03f",  [dic[@"delay"] doubleValue]];
    cell.uploadLabel.text = [NSString stringWithFormat:@"%.03f",  [dic[@"upload"] doubleValue]];
    cell.downloadLabel.text =    [NSString stringWithFormat:@"%.03f",  [dic[@"download"] doubleValue]];
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    detail.dic = _historyData[indexPath.row];
    [self.navigationController pushViewController:detail animated:true];
}


@end
