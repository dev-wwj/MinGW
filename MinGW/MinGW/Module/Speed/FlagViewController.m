//
//  FlagViewController.m
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import "FlagViewController.h"
#import "FlagTableViewCell.h"

@interface FlagViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation FlagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@"american-flag-2043285__340",@"argentina-162229__340",@"china",@"germany-flag-1783774__340",@"italy-162326__340",@"nigeria-162376__340",@"swiss-flag-3109178__340",@"ukraine-162450__340",@"union-jack-1027898__340"];
    self.titleStr = @"switch";
    self.titleColor = UIColor.whiteColor;
    self.view.backgroundColor = UIColor.blackColor;
    
    [self tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlagTableViewCell" forIndexPath:indexPath];
    cell.info = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  75;
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
        [tableView registerClass:[FlagTableViewCell class] forCellReuseIdentifier:@"FlagTableViewCell"];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.backgroundColor = ColorWithHex(0x414141);
        tableView.layer.cornerRadius = 20;
        tableView.layer.masksToBounds = YES;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-TAB_BAR_HEIGHT - 40);
        }];
    }
    return _tableView;
}

@end
