//
//  ZFTabBarButton.h
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFTabBarButton : UIButton

@property (nonatomic, copy) NSString *badgeText;
// badgeText == @""时 小红点size
@property (nonatomic, assign) CGSize dotSize;

// 是否展示大按钮
@property (nonatomic, copy) NSString *activityUrl;

// 选中
- (void)selectWithClick:(BOOL)click;
// 取消选中
- (void)deSelect;
@end

