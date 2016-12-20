//
//  YZYKLiveAddress.m
//  yingke
//
//  Created by yanzhen on 16/12/13.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "YZYKLiveAddress.h"

#define SELFLIVEADDRESS @"SelfLiveAddress"
@implementation YZYKLiveAddress

+ (void)saveSelfLiveAddress:(NSString *)address{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:address forKey:SELFLIVEADDRESS];
    [ud synchronize];
}

+ (NSString *)getSelfLiveAddress{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:SELFLIVEADDRESS];
}
@end
