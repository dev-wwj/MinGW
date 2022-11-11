//
//  BaseViewController.h
//  NativeEastNews
//
//  Created by xox on 16/3/28.
//  Copyright © 2016年 Gaoxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic, copy) NSString *titleStr; // 导航栏标题

@property (nonatomic, assign) BOOL leftButtonHidden;
@property (nonatomic, assign) BOOL rightButtonHidden;

@property (nonatomic, strong) UIColor *navBgColor; // 导航栏背景色
@property (nonatomic, assign) BOOL showBarLine; //是否显示导航栏下面的分割线
@property (nonatomic, strong) UIColor *titleColor; // 标题颜色

@property (readonly, nonatomic, strong) UIButton *leftButton;
@property (readonly, nonatomic, strong) UIButton *rightButton;
@property (readonly, nonatomic, strong) UILabel *centerLabel;

@property (nonatomic ,strong) NSString *backgrounImage;

@property (nonatomic, strong) UIImage *backImage;

- (void)defaultLeftBtnClick;
- (void)defaultRightBtnClick;
- (void)hiddenNavigationBar;
- (void)showNavigationBar:(BOOL)animation;
///刷新导航栏高度 适配导航栏高度出错的问题
- (void)refreshNavBarHeight;

- (void)ex_configNavBarBGView:(UIImageView *)bgView;

@end
