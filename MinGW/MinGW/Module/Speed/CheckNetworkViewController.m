//
//  CheckNetworkViewController.m
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import "CheckNetworkViewController.h"
#import "CheckTableViewCell.h"

@interface CheckNetworkViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CheckNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navBgColor = UIColor.clearColor;
    self.titleStr = @"Network Diagnostics";
    self.titleColor = UIColor.whiteColor;
    
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@{@"title":@"Network Settings",@"subtitle":@"Little sun"}];
    [self.dataSource addObject:@{@"title":@"signal intensity",@"subtitle":@"normal"}];
    [self.dataSource addObject:@{@"title":@"DNS Status",@"subtitle":@"正常normal"}];
    [self.dataSource addObject:@{@"title":@"Network connectivity",@"subtitle":@"normal"}];
    [self.dataSource addObject:@{@"title":@"Server communication",@"subtitle":@"normal"}];
    [self setUI];
}

- (void)setUI {
    UIImageView *speedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1215"]];
    [self.view addSubview:speedImg];
    [speedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_BAR_HEIGHT + 10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(suitWidth(200), 190));
    }];
    
    [self tableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != -1 &&[[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != 0){
            [self showCheckout:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showCheckout:1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showCheckout:2];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showCheckout:3];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showCheckout:4];
                        });
                    });
                });
            });
        }else{
            
        }
    });
}

- (void)showCheckout:(int)index {
    CheckTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.image.hidden = NO;
    cell.subtitle.hidden = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckTableViewCell" forIndexPath:indexPath];
    cell.info = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  54;
}

#pragma mark -tableView
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        [self.view addSubview:tableView];
        _tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CheckTableViewCell class] forCellReuseIdentifier:@"CheckTableViewCell"];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.backgroundColor = ColorWithHex(0x414141);
        tableView.layer.cornerRadius = 20;
        tableView.layer.masksToBounds = YES;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.bottom.mas_equalTo(-TAB_BAR_HEIGHT - 60);
            make.height.mas_equalTo(270);
        }];
    }
    return _tableView;
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
