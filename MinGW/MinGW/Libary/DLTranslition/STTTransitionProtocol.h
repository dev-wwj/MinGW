//
//  STTTransitionProtocol.h
//  NativeEastNews
//
//  Created by xin song on 2018/7/23.
//  Copyright © 2018年 Gaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>


//NS_ASSUME_NONNULL_BEGIN

@protocol STTTransitionProtocol <NSObject>

@optional
/**
 *   用于转场用的Temp图片
 */
@property (nonatomic, strong) YYAnimatedImageView *tempImage;

/**
 *   图片起始位置
 */
@property (nonatomic, assign) CGRect originRect;

//图片展示，当前的tempImage
- (void)getTempImage;
@end

//NS_ASSUME_NONNULL_END
