//
//  CCWeakDelegate.h
//  CCCycleViewDemo
//
//  Created by zacks on 2018/5/29.
//  Copyright © 2018年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCWeakDelegate : NSProxy

@property (nonatomic ,weak ,readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)delegateWithTarget:(id)target;


@end
