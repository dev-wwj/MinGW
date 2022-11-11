//
//  GetIPAddress.h
//  Testedonanimals
//
//  Created by songxin on 2022/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetIPAddress : NSObject
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end

NS_ASSUME_NONNULL_END
