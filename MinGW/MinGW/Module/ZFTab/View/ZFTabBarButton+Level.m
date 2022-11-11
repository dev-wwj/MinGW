//
//  UIButton+Level.m
//  NativeEastNews
//
//  Created by administrator on 16/9/21.
//  Copyright © 2016年 Gaoxin. All rights reserved.
//

#import "ZFTabBarButton+Level.h"
#import <objc/runtime.h>

//static CGFloat const kStateChangeDuration = .3;
static char levelKey ;


@implementation ZFTabBarButton (Level)

#pragma mark - public property
- (ZFTabBarButton *)rippleCopyBtnView {
    ZFTabBarButton *copyBtn = objc_getAssociatedObject(self, @selector(rippleCopyBtnView));
    if (!copyBtn) {
        copyBtn        = [[ZFTabBarButton alloc] init];
        copyBtn.hidden = YES;               // 默认隐藏
        copyBtn.userInteractionEnabled = NO;
        [self addSubview:copyBtn];
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        objc_setAssociatedObject(self, @selector(rippleCopyBtnView), copyBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return copyBtn;
}
- (void)setSupportAnimation:(BOOL)supportAnimation {
    objc_setAssociatedObject(self, @selector(supportAnimation), @(supportAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)supportAnimation {
    return [objc_getAssociatedObject(self, @selector(supportAnimation)) boolValue];
}


#pragma mark - private property
- (CAReplicatorLayer *)rippleLayer {
    return objc_getAssociatedObject(self, @selector(rippleLayer));
}
- (void)setRippleLayer:(CAReplicatorLayer *)rippleLayer {
    objc_setAssociatedObject(self, @selector(rippleLayer), rippleLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)rippleContainerView {
    return objc_getAssociatedObject(self, @selector(rippleContainerView));
}
- (void)setRippleContainerView:(UIView *)rippleContainerView {
    objc_setAssociatedObject(self, @selector(rippleContainerView), rippleContainerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 状态
- (RippleAnimationState)btnRippleState {
    return (RippleAnimationState)[objc_getAssociatedObject(self, &levelKey) integerValue] ? : RippleAnimationNone ;
}
- (void)changeRippleStateTo:(RippleAnimationState)rippleState {
    if (self.supportAnimation == NO) {
        return;
    }
    RippleAnimationState oldState = self.btnRippleState;
    if (oldState == rippleState) {
        return;
    }
    
    if (rippleState == RippleAnimationRotating) {
        if (self.selected == NO) {
            return;
        }
        if (oldState != RippleAnimationReppling) {
            // 目前直允许 ripple -> rotare
            return;
        }
        // 显示
        self.rippleCopyBtnView.hidden = NO;
        self.rippleCopyBtnView.imageView.transform = CGAffineTransformIdentity;
        [self.rippleCopyBtnView.imageView.layer removeAllAnimations];
        // 停止
        [self p_stopXiuyixiuAnimation];
        // 动画
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.fromValue         = @0;
        rotate.toValue           = @(M_PI*2);
        rotate.speed             = .4;
        rotate.repeatCount       = HUGE_VALF;
        [self.rippleCopyBtnView.imageView.layer addAnimation:rotate forKey:@"refreshRotate"];
        
    }else if (rippleState == RippleAnimationNone) {
        
        [self p_removeAllRippleInfo];
        
    }else if (rippleState == RippleAnimationReppling) {
        if (self.selected == NO) {
            return;
        }
        //
        [self p_toRepplingAnimation];
    }

    objc_setAssociatedObject(self, &levelKey, @(rippleState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)btnSelectDidChange:(BOOL)toSelect {
    if (self.supportAnimation == NO) {
        return;
    }
    if (toSelect == YES) {
        // 开启一个临时出现动画
        if (self.btnRippleState == RippleAnimationReppling) {
            [self p_toRepplingAnimation];
        }
        
    }else {
        // 如果当前刷新状态 直接结束
        if (self.btnRippleState == RippleAnimationRotating) {
            [self changeRippleStateTo:RippleAnimationNone];
        }
        
        // 开启一个临时消失动画
        [self p_deSelectAnimationIfNeed];
        
        // 变为非选中状态 -> 移除ripple所有
        [self p_removeAllRippleInfo];
    }
}

#pragma mark - private
- (void)p_removeAllRippleInfo {
    if (self.rippleCopyBtnView.isHidden) {
        return;
    }
    // 停止ripple动画
    [self p_stopXiuyixiuAnimation];
    
    // 停止旋转动画
    [self.rippleCopyBtnView.imageView.layer removeAllAnimations];
    self.rippleCopyBtnView.imageView.transform = CGAffineTransformIdentity;
    
    // 隐藏
    self.rippleCopyBtnView.hidden = YES;
}
- (void)p_deSelectAnimationIfNeed {
    if (self.btnRippleState != RippleAnimationNone) {
        // 提示刷新 或者 刷新状态 -> 做个临时动画
        self.superview.userInteractionEnabled = NO;
        //
        [self.rippleCopyBtnView.imageView.layer removeAllAnimations];
        
        UIView *snapView = [self.rippleCopyBtnView.imageView snapshotViewAfterScreenUpdates:NO];
        snapView.frame   = self.rippleCopyBtnView.imageView.frame;
        [self addSubview:snapView];
        
        [UIView animateWithDuration:0.2 animations:^{
            snapView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI), CGAffineTransformMakeScale(0.4, 0.4));
        }completion:^(BOOL finished) {
            self.superview.userInteractionEnabled = YES;
            [snapView removeFromSuperview];
        }];
    }
}
- (void)p_toRepplingAnimation {
    self.superview.userInteractionEnabled = NO;
    
    self.rippleCopyBtnView.hidden = NO;
    [self.rippleCopyBtnView.imageView.layer removeAllAnimations];
    self.rippleCopyBtnView.imageView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-M_PI), CGAffineTransformMakeScale(0.4, 0.4));
    
    [UIView animateWithDuration:0.2 animations:^{
        self.rippleCopyBtnView.imageView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
        self.superview.userInteractionEnabled = YES;
        self.rippleCopyBtnView.imageView.transform = CGAffineTransformIdentity;
    }];
    
    [self p_startXiuyixiuAnimation];
}


- (void)p_startXiuyixiuAnimation {
    if (CGRectEqualToRect(self.frame, CGRectZero)) { //如果没有设置frame 直接返回
        return;
    }
    //
    [self p_stopXiuyixiuAnimation];
    
    if (!self.selected) {
        return;
    }
    
    CGRect rect     = CGRectMake(0, 0, 10, 10);
    if (!self.rippleContainerView) {
        UIView *xiuView = [[UIView alloc] initWithFrame:rect];
        [self.rippleCopyBtnView addSubview:xiuView];
        [xiuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageView);
            make.size.mas_equalTo(rect.size);
        }];
        self.rippleContainerView = xiuView;
    }else {
        self.rippleContainerView.hidden = NO;
    }
    
    //
    CALayer *layer        = [CALayer layer];
    layer.frame           = rect;
    layer.backgroundColor = ColorWithHex(0xFF3552).CGColor;
    layer.cornerRadius    = 5;
    layer.masksToBounds   = YES;

    //
    CABasicAnimation *opKey = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opKey.duration          = 1.92;
    opKey.fromValue         = @.4;
    opKey.toValue           = @0;
    
    CABasicAnimation *scaleKey = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleKey.duration          = 1.92;
    scaleKey.fromValue         = @1;
    scaleKey.toValue           = @6;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations  = @[opKey,scaleKey];
    group.repeatCount = INT_MAX;
    group.duration    = 1.92 + 3.5;
    
    //
    [layer addAnimation:group forKey:@"RippleAnimaton-"];
    //
    CAReplicatorLayer *replayer = [CAReplicatorLayer layer];
    [replayer addSublayer:layer];
    replayer.frame         = rect;
    replayer.instanceCount = 3;
    replayer.instanceDelay = 1.0;
    
    [self.rippleContainerView.layer addSublayer:replayer];
    
    self.rippleLayer = replayer;
}


- (void)p_stopXiuyixiuAnimation {
    if (self.rippleContainerView) {
        self.rippleContainerView.hidden = YES;
        [self.rippleLayer removeAllAnimations];
        [self.rippleLayer removeFromSuperlayer];
        self.rippleLayer = nil;
    }
}
@end
