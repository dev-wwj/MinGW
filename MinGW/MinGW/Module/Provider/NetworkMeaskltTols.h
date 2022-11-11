//
//  NetworkMeaskltTols.h
//  AppDemo
//
//  Created by 丁冬冬 on 2022/11/9.
//
typedef void (^cg_PWBXCK) (float bd_PWBXCK);
typedef void (^ch_PWBXCK) (float bd_PWBXCK);

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMeaskltTols : NSObject

/**
 *  初始化测速方法
 *
 *  @param cg_PWBXCK       实时返回测速信息
 *  @param ch_PWBXCK 最后完成时候返回平均测速信息
 *
 *  @return MeasurNetTools对象
 */
- (instancetype)initWithblock_PWBXCK:(cg_PWBXCK)cg_PWBXCK ch_PWBXCK:(ch_PWBXCK)ch_PWBXCK ci_PWBXCK:(void (^) (NSError *error_PWBXCK))ci_PWBXCK;

/**
 *  开始测速
 */
-(void)startMeasur_PWBXCK;

/**
 *  停止测速，会通过block立即返回测试信息
 */
-(void)stopMeasur_PWBXCK;

@end

NS_ASSUME_NONNULL_END
