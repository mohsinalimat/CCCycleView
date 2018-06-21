//
//  CCViewScrollViewCell.m
//  MadrockChat
//
//  Created by MDLK-CC on 2018/5/8.
//  Copyright © 2018年 MadRock. All rights reserved.
//

#import "CCViewScrollViewCell.h"

@interface CCViewScrollViewCell()

@end

@implementation CCViewScrollViewCell

- (void)setSubView:(UIView *)subView
{
    _subView = subView;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:subView];
    [self.contentView addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.viewEdge.top],
                           [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.viewEdge.left],
                           [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.viewEdge.bottom],
                           [NSLayoutConstraint constraintWithItem:self.subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-self.viewEdge.right]]];
}


@end
