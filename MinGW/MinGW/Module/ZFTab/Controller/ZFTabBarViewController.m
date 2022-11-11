//
//  ZFTabBarViewController.m
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import "ZFTabBarViewController.h"
#import <objc/runtime.h>
#import "CustomNaviViewController.h"
#import "SpeedViewController.h"
#import "CompassViewController.h"
#import "LogViewController.h"

@interface ZFTabBarViewController () <ZFTabBarDelegate>{
}

@property (nonatomic, assign) CGFloat tabBarHeight;

@property (strong, nonatomic) ZFTabBarButton *walkScrollTopBtn;
@property (nonatomic, strong) UIControl *tabBarRedView;

@end

@implementation ZFTabBarViewController

@synthesize customtabBar = _customtabBar;

#pragma mark -------override
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self p_setupViewControllers];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)statusBarOrientation:(NSNotification *)notification{
    self.customtabBar.frame = self.tabBar.bounds;

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
     
                                                  object:nil];
}


#pragma mark - setUp
/**
 *  初始化tabbar
 */
- (void)p_creatCustomtabBar {
    if (_customtabBar) {
        return;
    }
    CGRect rect = self.tabBar.bounds;
    rect.size.height = TAB_BAR_HEIGHT;
    _customtabBar = [[ZFTabBar alloc] initWithFrame:rect];
    _customtabBar.tag = 1000023;
    _customtabBar.delegate = self;
    [self.tabBar addSubview:_customtabBar];
    [self.tabBar setBarStyle:UIBarStyleBlack];
    [self.tabBar setBarTintColor:nil];
    
    if (@available(iOS 13.0, *)) {
        //iOS 13 去掉 tabbar 黑线
        UITabBarAppearance *appearance = self.tabBar.standardAppearance;
        appearance.backgroundImage = [YYImage imageWithColor:UIColor.clearColor];
        appearance.shadowImage  = [YYImage imageWithColor:UIColor.clearColor];
        appearance.backgroundEffect = nil;
        self.tabBar.standardAppearance = appearance;
    }else {
        [self.tabBar setShadowImage:[YYImage imageWithColor:UIColor.clearColor]];
        [self.tabBar setBackgroundImage:[YYImage imageWithColor:UIColor.clearColor]];
        [self.tabBar setBackgroundColor:[UIColor clearColor]];
    }
    
    _tabBarHeight = TAB_BAR_HEIGHT;
}

- (void)p_setupViewControllers {
    
    NSMutableArray<CustomNaviViewController *> *navVCs = [NSMutableArray array];
    
    [navVCs addObject:[self p_speedNav]];
    [navVCs addObject:[self p_pingNav]];
    [navVCs addObject:[self p_historyNav]];
    
    [self p_creatCustomtabBar];
    for (int index = 0; index < navVCs.count; index++) {
        CustomNaviViewController *nav = navVCs[index];
        [self.customtabBar config_insertTabBarBtn:nav.customTabBarItem toIndex:index];
    }
    
    // 这句会导致触发 setSelectIndex 先执行上面的创建
    self.viewControllers = navVCs;
}

- (CustomNaviViewController *)p_speedNav {
    SpeedViewController *firstPageVC = [[SpeedViewController alloc] init];
    
    CustomNaviViewController *nav = [[CustomNaviViewController alloc] initWithRootViewController:firstPageVC];
    nav.custom_tabBarItemTitle = @"velocity measurement";
    
    [nav.customTabBarItem setImage:[UIImage imageNamed:@"闪付_flash-payment (1)"] forState:UIControlStateNormal];
    [nav.customTabBarItem setImage:[UIImage imageNamed:@"闪付_flash-payment"] forState:UIControlStateSelected];
    
    [nav.customTabBarItem setTitle:nav.custom_tabBarItemTitle forState:UIControlStateNormal];
      
    
    // 禁用系统的tabbarButton
    nav.tabBarItem.enabled = NO;
    
    return nav;
}

- (CustomNaviViewController *)p_pingNav {
    
    CompassViewController *compassVC = [[CompassViewController alloc] init];
    CustomNaviViewController *nav = [[CustomNaviViewController alloc] initWithRootViewController:compassVC];
    nav.custom_tabBarItemTitle = @"compass";
    
    [nav.customTabBarItem setImage:[UIImage imageNamed:@"指南针_compass-one"] forState:UIControlStateNormal];
    [nav.customTabBarItem setImage:[UIImage imageNamed:@"指南针_compass-one (1)"] forState:UIControlStateSelected];
    [nav.customTabBarItem setTitle:nav.custom_tabBarItemTitle forState:UIControlStateNormal];
    
    // 禁用系统的tabbarButton
    nav.tabBarItem.enabled = NO;
    
    return nav;
}

- (CustomNaviViewController *)p_historyNav {
    LogViewController *logVC = [[LogViewController alloc] init];
    
    CustomNaviViewController *nav = [[CustomNaviViewController alloc] initWithRootViewController:logVC];
    nav.custom_tabBarItemTitle = @"history";
    
    [nav.customTabBarItem setImage:[UIImage imageNamed:@"历史记录_history (1)"] forState:UIControlStateNormal];
    [nav.customTabBarItem setImage:[UIImage imageNamed:@"历史记录_history"] forState:UIControlStateSelected];
    [nav.customTabBarItem setTitle:nav.custom_tabBarItemTitle forState:UIControlStateNormal];
    
    
    _mineTabButton = nav.customTabBarItem;
    
    // 禁用系统的tabbarButton
    nav.tabBarItem.enabled = NO;
    return nav;
}

#pragma mark - layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self adjustTabBarHeight];
}

- (void)adjustTabBarHeight {
    CGFloat tabBarH = _tabBarHeight > 0 ? _tabBarHeight : self.tabBar.height;
    [self updateTabBarHeight:tabBarH];
}
- (void)updateTabBarHeight:(CGFloat)height {
//    self.customtabBar.origin.y = self.tabBar.height - height;
    self.customtabBar.height = height;
}

#pragma mark - Override
// 1.手动修改selectedIndex时（包含tabButton点击时） 2.修改viewControllers时（包含初始化时的修改）
- (void)setSelectedIndex:(NSUInteger)selectedIdx {
    [super setSelectedIndex:selectedIdx];
    [self.customtabBar updateTabButtonToSelectIdx:selectedIdx];
}

#pragma mark - ZFTabBarDelegate
- (void)tabBar:(ZFTabBar *)tabBar didDoubleClickBtnIndex:(NSInteger)newIdx oldIndex:(NSInteger)oldIdx {
    if (newIdx == 0 && newIdx == oldIdx) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BDDRefreshWalkFeed" object:nil];
    }
}

- (void)notiWalkFeedScrollToTop {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BDDRefreshWalkFeed" object:nil];
}

- (void)tabBar:(ZFTabBar *)tabBar didClickBtnIndex:(NSInteger)newIdx oldIndex:(NSInteger)oldIdx {
    [self setSelectedIndex:newIdx];
}
#pragma mark - TabBar截图

- (void)takeTabBarSnapshot {
}
@end

#pragma mark ------UIViewController 自定义TabBar分类
@implementation UIViewController (UIViewControllerCustomTabBarItem)

static char itemKey;
- (ZFTabBarButton *)customTabBarItem {
    ZFTabBarButton *item = objc_getAssociatedObject(self, &itemKey);
    if (!item) {
        item = [[ZFTabBarButton alloc] init];
        objc_setAssociatedObject(self, &itemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}
- (void)resetCustomTabBarItem:(ZFTabBarButton *)customTabBarItem {
    objc_setAssociatedObject(self, &itemKey, customTabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setCustom_tabBarItemTitle:(NSString *)custom_tabBarItemTitle {
    objc_setAssociatedObject(self, @selector(custom_tabBarItemTitle), custom_tabBarItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)custom_tabBarItemTitle {
    return objc_getAssociatedObject(self, @selector(custom_tabBarItemTitle));
}


@end
