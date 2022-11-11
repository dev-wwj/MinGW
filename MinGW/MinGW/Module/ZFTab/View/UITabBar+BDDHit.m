//
//  UITabBar+BDDHit.m
//  步多多
//
//  Created by Chenyoh on 2022/1/21.
//  Copyright © 2022 songheng. All rights reserved.
//

#import "UITabBar+BDDHit.h"

@implementation UITabBar (BDDHit)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.isHidden) {
//        return [super hitTest:point withEvent:event];
//    }
//    UIView *tempView = [self viewWithTag:1000023];
//    if (!tempView) {
//        return [super hitTest:point withEvent:event];
//    }
//    for (UIButton *btn in tempView.subviews) {
//        if ([btn isKindOfClass:[ZFTabBarButton class]]) {
//            if (CGRectContainsPoint(btn.frame, point)) {
//                return btn;
//            }
//        }
//    }
    return [super hitTest:point withEvent:event];
}

@end
