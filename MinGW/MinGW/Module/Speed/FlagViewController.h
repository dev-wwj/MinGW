//
//  FlagViewController.h
//  MinGW
//
//  Created by songxin on 2022/11/11.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlagViewController : BaseViewController
@property (nonatomic, copy) void(^block)(NSString *);
@end

NS_ASSUME_NONNULL_END
