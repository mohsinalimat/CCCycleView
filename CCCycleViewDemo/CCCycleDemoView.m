//
//  CCCycleDemoView.m
//  CCCycleViewDemo
//
//  Created by zacks on 2018/5/28.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCCycleDemoView.h"

@implementation CCCycleDemoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.topTitleLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    self.bottomTitleLabel.layer.borderColor = [UIColor orangeColor].CGColor;
}

@end
