//
//  BaseViewController.m
//  NativeEastNews
//
//  Created by xox on 16/3/28.
//  Copyright © 2016年 Gaoxin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    UIImageView *_bgImg;
}
@property (strong, nonatomic) UIView *customNavgationBar;
@end

@implementation BaseViewController

- (void)setBackgrounImage:(NSString *)backgrounImage {
    _bgImg.image = [UIImage imageNamed:backgrounImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImg = [[UIImageView alloc] init];
    bgImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    _bgImg = bgImg;
    
    [self initNavigationBar];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)initNavigationBar {
    if (_customNavgationBar) {
        return;
    }
    
    _customNavgationBar = [[UIView alloc] init];
    _customNavgationBar.backgroundColor = self.navBgColor?:[UIColor whiteColor];
    [self.view addSubview:_customNavgationBar];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:self.backImage ? : [UIImage imageNamed:@"返回浅"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(defaultLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_customNavgationBar addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton addTarget:self action:@selector(defaultRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_customNavgationBar addSubview:_rightButton];
    
    _centerLabel = [[UILabel alloc] init];
    _centerLabel.tag = 10023;
    _centerLabel.textColor = ColorWithHex(0x222222);
    _centerLabel.font = [UIFont boldSystemFontOfSize:18];
    _centerLabel.textAlignment = NSTextAlignmentCenter;
    [_customNavgationBar addSubview:_centerLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorWithHex(0xeeeeee);
    lineView.hidden = !_showBarLine;
    [_customNavgationBar addSubview:lineView];
    
    [_customNavgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(NAV_BAR_HEIGHT);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self->_customNavgationBar);
        make.width.height.mas_equalTo(44);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->_customNavgationBar);
        make.right.equalTo(self->_customNavgationBar).offset(-8);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
    }];
    
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self->_customNavgationBar);
        make.height.mas_equalTo(44);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self->_customNavgationBar);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)refreshNavBarHeight {
    [_customNavgationBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(NAV_BAR_HEIGHT);
    }];
}

#pragma mark - getter/setter
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    const int screenW = SCREEN_SIZE_MIN;
    if (screenW <= 320 && _titleStr.length > 40) {
        _titleStr = [[_titleStr substringToIndex:40] stringByAppendingString:@"..."];
    }else if (screenW == 375 && _titleStr.length > 40) {
        _titleStr = [[_titleStr substringToIndex:40] stringByAppendingString:@"..."];
    }else {
        // >= 414
        if (_titleStr.length > 40) {
            _titleStr = [[_titleStr substringToIndex:40] stringByAppendingString:@"..."];
        }
    }
    self.centerLabel.text = _titleStr;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.centerLabel.textColor = titleColor;
}

- (void)setNavBgColor:(UIColor *)navBgColor {
    _navBgColor = navBgColor;
    _customNavgationBar.backgroundColor = navBgColor?:[UIColor whiteColor];
}

- (void)setLeftButtonHidden:(BOOL)leftButtonHidden {
    _leftButtonHidden      = leftButtonHidden;
    self.leftButton.hidden = leftButtonHidden;
}

- (void)setRightButtonHidden:(BOOL)rightButtonHidden {
    _rightButtonHidden      = rightButtonHidden;
    self.rightButton.hidden = rightButtonHidden;
}

- (void)hiddenNavigationBar {
    self.customNavgationBar.hidden = YES;
}

- (void)showNavigationBar:(BOOL)animation {
    self.customNavgationBar.hidden = NO;
    
    if (animation) {
        self.customNavgationBar.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.customNavgationBar.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

//默认pop
- (void)defaultLeftBtnClick {
    if (self.navigationController.viewControllers.count == 1 && self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultRightBtnClick {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



- (void)ex_configNavBarBGView:(UIImageView *)bgView {
    if (bgView == nil) {
        return;
    }
    
    [self.customNavgationBar insertSubview:bgView atIndex:0];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}

- (void)setBackImage:(UIImage *)backImage {
    _backImage = backImage;
    if (_leftButton) {
        [_leftButton setImage:_backImage ? : [UIImage imageNamed:@"返回浅"] forState:UIControlStateNormal];
    }
}
@end
