//
//  ZFTabBarButton+Level.h
//  NativeEastNews
//
//  Created by donglinxin on 16/9/21.
//  Copyright © 2016年 Gaoxin. All rights reserved.
//  为button添加等级
//
#import "ZFTabBarButton.h"

typedef NS_ENUM(NSInteger, RippleAnimationState){
    RippleAnimationNone,       // 正常状态
    RippleAnimationReppling,   // 待刷新状态(波纹动画)
    RippleAnimationRotating    // 刷新状态 (旋转动画)
};

@interface ZFTabBarButton (Level)

// 是否应用刷新动画
@property (nonatomic, assign) BOOL supportAnimation;


// 刷新/待刷新状态是 显示的icon
@property (nonatomic, strong, readonly) ZFTabBarButton *rippleCopyBtnView;


// 当前状态
@property (nonatomic, assign, readonly) RippleAnimationState btnRippleState;
- (void)changeRippleStateTo:(RippleAnimationState)rippleState;



// 选中状态变更时 更新动画
- (void)btnSelectDidChange:(BOOL)toSelect;
@end
