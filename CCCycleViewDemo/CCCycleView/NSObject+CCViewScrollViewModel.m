//
//  NSObject+CCViewScrollViewModel.m
//  MadrockChat
//
//  Created by MDLK-CC on 2018/5/8.
//  Copyright © 2018年 MadRock. All rights reserved.
//

#import "NSObject+CCViewScrollViewModel.h"
#import <objc/runtime.h>

static void *reUseStringKey = (void *)@"reUseStringKey";

@implementation NSObject (CCViewScrollViewModel)

- (NSString *)CC_reUseStringKey
{
    NSString *str = objc_getAssociatedObject(self, reUseStringKey);
    return str;
}

- (void)setCC_reUseStringKey:(NSString *)CC_reUseStringKey
{
    objc_setAssociatedObject(self, reUseStringKey, CC_reUseStringKey, OBJC_ASSOCIATION_RETAIN);
}

@end
