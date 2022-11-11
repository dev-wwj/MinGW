//
//  ZFTabBar.m
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import "ZFTabBar.h"

#define kStartTag 200

#define DefaultLineColor ColorWithHex(0xebebeb)

@interface ZFTabBar() {
    NSPointerArray *_tabBarButtonArr;
}
@property (nonatomic, weak) ZFTabBarButton *selectedButton;
@property (nonatomic, strong) UIView *line;

@end

@implementation ZFTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, STT_OnePointHeight)];
        [self lineColor:UIColor.clearColor];
        [self addSubview:_line];
        [self addShadow];

        self.clipsToBounds = NO;
        self.backgroundColor = ColorWithHex(0xffffff);
        _tabBarButtonArr = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

- (void)addShadow {
    self.layer.shadowColor = UIColor.grayColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 3;
    CGFloat shadowPathWidth = self.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2, kScreenWidth, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = path.CGPath;
}

- (void)lineColor:(UIColor *)color {
    if (color != nil) {
        _line.backgroundColor = color;
    } else {
        _line.backgroundColor = DefaultLineColor;
    }
}

#pragma mark - public

- (void)config_insertTabBarBtn:(ZFTabBarButton *)item toIndex:(NSInteger)index {
    if (!item) {
        NSAssert(NO, @"button must not nil");
        return;
    }
    if (index < 0 || index > _tabBarButtonArr.count) {
        NSAssert(NO, @"index out of bounds exception");
        return;
    }
    
    item.tag = index + kStartTag;
    [item addTarget:self action:@selector(p_tabBatButtonAction:) forControlEvents:UIControlEventTouchDown];
    [item addTarget:self action:@selector(p_tabBatButtonDoubleClickAction:) forControlEvents:UIControlEventTouchDownRepeat];
    [self addSubview:item];
    
    // 补充插入逻辑
    if (index < _tabBarButtonArr.count) {
        for (NSInteger i = index; i < _tabBarButtonArr.count; i++) {
            ZFTabBarButton *btn = (__bridge ZFTabBarButton *)[_tabBarButtonArr pointerAtIndex:i];
            btn.tag++;
        }
    }
    
    [_tabBarButtonArr insertPointer:(__bridge void *)item atIndex:index];
}

- (void)config_updateWithIndex:(NSInteger)index toTabBarBtn:(ZFTabBarButton *)item {
    if (!item) {
        NSAssert(NO, @"button must not nil");
        return;
    }
    if (index < 0 || index > _tabBarButtonArr.count - 1) {
        NSAssert(NO, @"index out of bounds exception");
        return;
    }
    ZFTabBarButton *oldBtn = (__bridge ZFTabBarButton *)[_tabBarButtonArr pointerAtIndex:index];
    if (!oldBtn) {
        NSAssert(NO, @"old is nil");
    }
    if (oldBtn == self.selectedButton) {
        [item selectWithClick:NO];
        self.selectedButton = item;
    }
    
    // remove
    [self config_removeTabBarItemAtIndex:index];
    
    // add
    [self config_insertTabBarBtn:item toIndex:index];
}

- (void)config_removeTabBarItemAtIndex:(NSInteger)idx {
    if (idx < 0 || idx > _tabBarButtonArr.count - 1) {
        NSAssert(NO, @"index out of bounds exception");
        return;
    }
    // 如果移除的是当前选中的 系统会自动回调修改选中为0 所以这里不考虑处理
    if (idx < _tabBarButtonArr.count - 1) {
        for (NSInteger i = (idx + 1); i < _tabBarButtonArr.count; i++) {
            ZFTabBarButton *btn = (__bridge ZFTabBarButton *)[_tabBarButtonArr pointerAtIndex:i];
            btn.tag--;
        }
    }
    
    UIView *item = (__bridge UIView *)[_tabBarButtonArr pointerAtIndex:idx];
    [item removeFromSuperview];
    [_tabBarButtonArr removePointerAtIndex:idx];
}

- (void)updateTabButtonToSelectIdx:(NSInteger)selectIdx {
    if (selectIdx < 0 || selectIdx > _tabBarButtonArr.count - 1) {
        NSAssert(NO, @"index out of bounds exception");
        return;
    }
    ZFTabBarButton *button = (__bridge ZFTabBarButton *)[_tabBarButtonArr pointerAtIndex:selectIdx];
    if (!button) {
        NSAssert(NO, @"咦~~~");
    }
    if (button != self.selectedButton) {
        [self.selectedButton deSelect];
        
        [button selectWithClick:YES];
        
        self.selectedButton = button;
    }
}

- (ZFTabBarButton *)tabItemAtIdx:(NSInteger)idx{
   return (__bridge ZFTabBarButton *)[_tabBarButtonArr pointerAtIndex:idx];
}

#pragma mark - private

- (void)p_tabBatButtonDoubleClickAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(tabBar:didDoubleClickBtnIndex:oldIndex:)]) {
        [_delegate tabBar:self
         didDoubleClickBtnIndex:button.tag - kStartTag
                 oldIndex:self.selectedButton.tag - kStartTag];
    }
}

- (void)p_tabBatButtonAction:(ZFTabBarButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(tabBar:didClickBtnIndex:oldIndex:)]) {
        [_delegate tabBar:self
         didClickBtnIndex:button.tag - kStartTag
                 oldIndex:self.selectedButton.tag - kStartTag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width / _tabBarButtonArr.count;

    // 按钮的frame数据
    for (UIButton *btn in self.subviews) {
        if (![btn isKindOfClass:[ZFTabBarButton class]]) {
            continue;
        }
        btn.frame = CGRectMake((btn.tag - kStartTag) * buttonW, 0, buttonW, self.height-TAB_BAR_BOTTOM_MARGIN);
        ZFTabBarButton *zf_btn = (ZFTabBarButton *)btn;
        if (zf_btn.badgeText) {
            [zf_btn setBadgeText:zf_btn.badgeText];
        }
    }
}

@end
