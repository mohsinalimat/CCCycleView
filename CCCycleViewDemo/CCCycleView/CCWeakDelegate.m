//
//  CCWeakDelegate.m
//  CCCycleViewDemo
//
//  Created by zacks on 2018/5/29.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCWeakDelegate.h"

@implementation CCWeakDelegate

- (instancetype)initWithTarget:(id)target
{
    _target = target;
    return self;
}

+ (instancetype)delegateWithTarget:(id)target
{
    return [[CCWeakDelegate alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

@end
