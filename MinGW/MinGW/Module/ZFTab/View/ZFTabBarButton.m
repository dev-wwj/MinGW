//
//  ZFTabBarButton.m
//  ZFTabBar
//
//  Created by 任子丰 on 15/9/10.
//  Copyright (c) 2014年 任子丰. All rights reserved.
//

// 图标的比例
#define ZFTabBarButtonImageRatio 0.6
// 按钮的默认文字颜色
#define  ZFTabBarButtonTitleColor [UIColor lightGrayColor]
// 按钮的选中文字颜色
#define  ZFTabBarButtonTitleSelectedColor [UIColor colorWithRed:244.0/255.0 green:75.0/255.0 blue:80/255.0 alpha:1]

#import "ZFTabBarButton.h"
#import "ZFTabBarButton+Level.h"

@interface ZFTabBarButton()

@property (nonatomic,strong) UILabel *badgeLabel;

@end

@implementation ZFTabBarButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    // 图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
    
    // 文字居中
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    
    // 文字颜色
    [self setTitleColor:ColorWithHex(0x9397A1) forState:UIControlStateNormal];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
}

#pragma mark - Override

- (void)setHighlighted:(BOOL)highlighted {}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = ceilf(contentRect.size.height * ZFTabBarButtonImageRatio);
    return CGRectMake(0, 6, imageW, imageH-6);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    CGFloat height = contentRect.size.height;
    CGFloat titleY = ceilf(height * ZFTabBarButtonImageRatio);
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = height - titleY;
    return CGRectMake(0, titleY-1, titleW, titleH);
} 

#pragma mark - public

- (void)selectWithClick:(BOOL)click {
    self.selected = YES;
    if (click) {
        [self p_shiverWithTouch];
    }
    
    [self btnSelectDidChange:YES];
}

- (void)deSelect {
    self.selected = NO;
    self.imageView.transform = CGAffineTransformIdentity;
    
    [self btnSelectDidChange:NO];
}

#pragma mark - private

- (void)p_shiverWithTouch {
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.imageView.transform = CGAffineTransformIdentity;
                                          } completion:nil];
                     }];
}

#pragma mark - badge

- (void)setBadgeText:(NSString *)badgeText {
    if (!badgeText || [badgeText isKindOfClass:[NSString class]] == NO) {
        _badgeText = nil;
        _badgeLabel.hidden = YES;
    }else if (badgeText.length == 0) {
        // 红点
        _badgeText = @"";
        
        self.badgeLabel.hidden = NO;
        [self.badgeLabel setText:@""];
        
        CGFloat badgeW_H = 9;
        self.badgeLabel.layer.cornerRadius = badgeW_H / 2;
        self.badgeLabel.layer.masksToBounds = YES;
        // 设置frame
        CGFloat badgeX = self.frame.size.width *0.55;
        self.badgeLabel.frame = CGRectMake(badgeX + 5, 6, badgeW_H, badgeW_H);
    } else {
        // 文字
        _badgeText = [badgeText copy];
        
        self.badgeLabel.hidden = NO;
        [self.badgeLabel setFont:[UIFont systemFontOfSize:11]];
        [self.badgeLabel setText:badgeText];
        CGFloat badgeH = 16;
        CGFloat badgeW = ceil([self.badgeLabel sizeThatFits:CGSizeMake(100, 12)].width) + 10;
        if (badgeH > badgeW) {
            badgeW = badgeH;
        }
        
        // 设置frame
        CGFloat badgeX = ceil(self.frame.size.width * 0.55);
        self.badgeLabel.frame = CGRectMake(badgeX, 4, badgeW, badgeH);
        
        self.badgeLabel.layer.cornerRadius = 8;
        self.badgeLabel.layer.masksToBounds = YES;
    }
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        [_badgeLabel setBackgroundColor:ColorWithHex(0xFF3552)];
        _badgeLabel.layer.borderColor = UIColor.whiteColor.CGColor;
        _badgeLabel.layer.borderWidth = 1;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_badgeLabel];
    }
    return _badgeLabel;
}
@end
