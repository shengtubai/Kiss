//
//  MainCellModle.m
//  Homework - 大麦网
//
//  Created by qianfeng on 16/1/15.
//  Copyright (c) 2016年 白. All rights reserved.
//

#import "MainCellModle.h"

@implementation MainCellModle
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"没有注册的属性%@",key);
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
