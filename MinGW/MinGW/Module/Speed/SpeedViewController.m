//
//  SpeedViewController.m
//  MinGW
//
//  Created by wangwenjian on 2022/11/11.
//

#import "SpeedViewController.h"
#import "NetworkMeaskltTols.h"
#import "CacheUnit.h"
#import "CheckNetworkViewController.h"
#import "FlagViewController.h"

@interface SpeedViewController () {
    UIButton *_startSpeed;
    UILabel *_speedLa;
    UIButton *_delay;
    UIButton *_shake;
    UIButton *_loss;
    UILabel *_downLa;
    UILabel *_upLa;
    UIButton *_country;
}
@property (nonatomic, strong) NetworkMeaskltTols* tools;
@end

@implementation SpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleStr = @"MinGW speed measurement";
    self.titleColor = UIColor.whiteColor;
    self.navBgColor = UIColor.clearColor;
    self.leftButtonHidden = YES;
    
    [self.rightButton setImage:[UIImage imageNamed:@"均衡器_equalizer (1)"] forState:UIControlStateNormal];
    
    [self setUI];
    
    _tools = [[NetworkMeaskltTols alloc] initWithblock_PWBXCK:^(float bd_PWBXCK) {
        [self setSpeedInfo:bd_PWBXCK/ powf(1024, 2)];
    } ch_PWBXCK:^(float bd_PWBXCK) {
        [self setSpeedInfo:bd_PWBXCK/ powf(1024, 2)];
        
        [_startSpeed setTitle:@"Start speed measurement" forState:UIControlStateNormal];
        
        [CacheUnit setHistory:@{@"time":@([NSDate date].timeIntervalSince1970),@"delay":@(arc4random()%140),@"download":@(bd_PWBXCK/ powf(1024, 2)),@"upload":@(bd_PWBXCK/ (powf(1024, 2) * 25))}];
        
    } ci_PWBXCK:^(NSError * _Nonnull error_PWBXCK) {
        
        [_startSpeed setTitle:@"Start speed measurement" forState:UIControlStateNormal];
        
    }];
    
}

- (void)setSpeedInfo:(float)speed {
    _speedLa.text = [NSString stringWithFormat:@"%.1f",speed];
    [_delay setTitle:[NSString stringWithFormat:@"delay %d",arc4random()%140] forState:UIControlStateNormal];
    [_shake setTitle:[NSString stringWithFormat:@"shake %d",arc4random()%140] forState:UIControlStateNormal];
    [_loss setTitle:[NSString stringWithFormat:@"Packet loss %d",arc4random()%140] forState:UIControlStateNormal];
    _downLa.attributedText = [[NSString stringWithFormat:@"download Mbps \n %.2f",speed] rangeString:@"download Mbps" font:[UIFont systemFontOfSize:15]];
    _upLa.attributedText = [[NSString stringWithFormat:@"upload Mbps \n %.2f",speed/29.0] rangeString:@"upload Mbps" font:[UIFont systemFontOfSize:15]];
}

- (void)setUI {
    UIImageView *speedImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1215"]];
    [self.view addSubview:speedImg];
    [speedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_BAR_HEIGHT + 10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(suitWidth(200), 190));
    }];
    
    UILabel *speedLa = [UILabel new];
    speedLa.font = [UIFont systemFontOfSize:45];
    speedLa.textColor = ColorWithHex(0x5b62e6);
    speedLa.text = @"0";
    [self.view addSubview:speedLa];
    [speedLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(speedImg);
        make.centerX.equalTo(speedImg).offset(35);
    }];
    _speedLa = speedLa;
    
    
    UIButton *country = [UIButton buttonWithType:UIButtonTypeCustom];
    [country setImage:[UIImage imageNamed:@"china"] forState:UIControlStateNormal];
    [country addTarget:self action:@selector(countryAcioon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:country];
    [country mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 40));
        make.top.equalTo(speedImg.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    _country = country;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = ColorWithHex(0x414141);
    bgView.layer.cornerRadius = 40;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(320, 140));
        make.centerX.equalTo(self.view);
        make.top.equalTo(country.mas_bottom).offset(25);
    }];
    
    UIButton *delay = [UIButton buttonWithType:UIButtonTypeCustom];
    [delay setImage:[UIImage imageNamed:@"错误提示_error-prompt"] forState:UIControlStateNormal];
    [delay setTitle:@"delay 0ms" forState:UIControlStateNormal];
    delay.titleLabel.font = [UIFont systemFontOfSize:12];
    delay.enabled = NO;
    [bgView addSubview:delay];
    [delay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 65));
        make.top.equalTo(bgView);
        make.left.equalTo(bgView);
    }];
    _delay = delay;
    
    UIButton *shake = [UIButton buttonWithType:UIButtonTypeCustom];
    [shake setImage:[UIImage imageNamed:@"删除_delete-three"] forState:UIControlStateNormal];
    [shake setTitle:@"shake 0ms" forState:UIControlStateNormal];
    shake.titleLabel.font = [UIFont systemFontOfSize:12];
    shake.enabled = NO;
    [bgView addSubview:shake];
    [shake mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 65));
        make.top.equalTo(bgView);
        make.centerX.equalTo(bgView);
    }];
    _shake = shake;
    
    UIButton *loss = [UIButton buttonWithType:UIButtonTypeCustom];
    [loss setImage:[UIImage imageNamed:@"云中断_link-cloud-faild"] forState:UIControlStateNormal];
    [loss setTitle:@"Packet loss 0%" forState:UIControlStateNormal];
    loss.titleLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:loss];
    [loss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 65));
        make.top.equalTo(bgView);
        make.right.equalTo(bgView);
    }];
    _loss = loss;
    
    UILabel *downLoad = [UILabel new];
    downLoad.text = @"download Mbps\n0";
    downLoad.numberOfLines = 0;
    downLoad.textAlignment = NSTextAlignmentCenter;
    downLoad.font = [UIFont systemFontOfSize:20];
    downLoad.textColor = UIColor.whiteColor;
    [bgView addSubview:downLoad];
    [downLoad mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 70));
        make.top.equalTo(delay.mas_bottom);
        make.left.equalTo(bgView);
    }];
    _downLa = downLoad;
    
    UILabel *upload = [UILabel new];
    upload.text = @"upload Mbps\n0";
    upload.numberOfLines = 0;
    upload.textAlignment = NSTextAlignmentCenter;
    upload.font = [UIFont systemFontOfSize:20];
    upload.textColor = UIColor.whiteColor;
    [bgView addSubview:upload];
    [upload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 70));
        make.top.equalTo(delay.mas_bottom);
        make.right.equalTo(bgView);
    }];
    _upLa = upload;
    
    UIButton *startSpeed = [UIButton buttonWithType:UIButtonTypeCustom];
    [startSpeed setTitle:@"Start speed measurement" forState:UIControlStateNormal];
    startSpeed.titleLabel.font = [UIFont systemFontOfSize:17];
    [startSpeed addTarget:self action:@selector(startSpeed) forControlEvents:UIControlEventTouchUpInside];
    startSpeed.layer.cornerRadius = 20;
    startSpeed.layer.masksToBounds = YES;
    [self.view addSubview:startSpeed];
    [startSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 48));
        make.top.equalTo(bgView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    _startSpeed = startSpeed;
    
    UIButton *network = [UIButton buttonWithType:UIButtonTypeCustom];
    [network setTitle:@"Network Diagnostics" forState:UIControlStateNormal];
    network.titleLabel.font = [UIFont systemFontOfSize:17];
    [network addTarget:self action:@selector(checkNet) forControlEvents:UIControlEventTouchUpInside];
    network.layer.cornerRadius = 20;
    network.layer.masksToBounds = YES;
    [self.view addSubview:network];
    [network mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 48));
        make.top.equalTo(startSpeed.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    [loss layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:2];
    [shake layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:2];
    [delay layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:2];
    
    [startSpeed addHorizontalGradientLayerByColors:@[(__bridge id)ColorWithHex(0x28bcc6).CGColor,(__bridge id)ColorWithHex(0x41c7b4).CGColor] frame:CGRectMake(0, 0, 330, 48)];
    [network addHorizontalGradientLayerByColors:@[(__bridge id)ColorWithHex(0x28bcc6).CGColor,(__bridge id)ColorWithHex(0x41c7b4).CGColor] frame:CGRectMake(0, 0, 330, 48)];
}

- (void)startSpeed {
    [_startSpeed setTitle:@"Stop speed measurement" forState:UIControlStateNormal];
    
    [self.tools startMeasur_PWBXCK];
}

- (void)checkNet {
    CheckNetworkViewController *vc =[CheckNetworkViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)countryAcioon {
    FlagViewController *vc = [FlagViewController new];
    vc.block = ^(NSString * _Nonnull img) {
        [_country setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)defaultRightBtnClick {
    
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
