//
//  FlagViewController.m
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import "FlagViewController.h"
#import "FlagTableViewCell.h"

@interface FlagViewController ()<UITableViewDelegate,UITableViewDataSource> {
    int index;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation FlagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    index = 2;
    self.dataSource = @[@"american-flag-2043285__340",@"argentina-162229__340",@"china",@"germany-flag-1783774__340",@"italy-162326__340",@"nigeria-162376__340",@"swiss-flag-3109178__340",@"ukraine-162450__340",@"union-jack-1027898__340"];
    self.titleStr = @"switch";
    self.titleColor = UIColor.whiteColor;
    self.navBgColor = UIColor.clearColor;
    
    [self tableView];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitle:@"determine" forState:UIControlStateNormal];
    [sure setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    sure.layer.cornerRadius = 12;
    sure.layer.masksToBounds = YES;
    [self.view addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(170, 54));
        make.bottom.mas_equalTo(-40);
        make.centerX.equalTo(self.view);
    }];
    
    [sure addHorizontalGradientLayerByColors:@[(__bridge id)ColorWithHex(0x28bcc6).CGColor,(__bridge id)ColorWithHex(0x41c7b4).CGColor] frame:CGRectMake(0, 0, 170, 54)];
}

- (void)sureAction {
    _block(self.dataSource[index]);
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:YES];
    index = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
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
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(NAV_BAR_HEIGHT + 20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-110);
        }];
    }
    return _tableView;
}

@end
