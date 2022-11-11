//
//  CacheUnit.m
//  Testedonanimals
//
//  Created by songxin on 2022/11/10.
//

#import "CacheUnit.h"

@implementation CacheUnit

+ (void)setHistory:(NSDictionary *)info {
    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:@"History"];
    if (list == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:info];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"History"];
    }else {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:list];
        [arr addObject:info];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"History"];
    }
}
+ (NSArray *)getHistoryList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"History"];
}
@end
