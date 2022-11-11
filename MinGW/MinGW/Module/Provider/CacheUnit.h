//
//  CacheUnit.h
//  Testedonanimals
//
//  Created by songxin on 2022/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheUnit : NSObject
+ (void)setHistory:(NSDictionary *)info;
+ (NSArray *)getHistoryList;
@end

NS_ASSUME_NONNULL_END
