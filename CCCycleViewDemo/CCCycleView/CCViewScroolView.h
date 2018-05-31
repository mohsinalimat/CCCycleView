//
//  CCViewScroolView.h
//  MadrockChat
//
//  Created by MDLK-CC on 2018/5/7.
//  Copyright © 2018年 MadRock. All rights reserved.
//  用于view滑动效果


#import <UIKit/UIKit.h>
#import "NSObject+CCViewScrollViewModel.h"

@protocol CCViewScrollViewDataSource <NSObject>
@required
- (UIView *)cc_viewForModel:(id)model;
@optional
- (CGSize)cc_viewForModel:(id)model index:(NSInteger)index;

@end

@protocol CCViewScrollViewDelegate <NSObject>
@optional
- (void)cc_scrollDidSelectItem:(NSInteger)index model:(id)model view:(UIView *)view;

- (void)cc_scrollDidScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface CCViewScroolView : UIView

@property (weak , nonatomic) id<CCViewScrollViewDataSource> dataSource;

@property (weak , nonatomic) id<CCViewScrollViewDelegate> delegate;
/**
 default is UICollectionViewScrollDirectionHorizontal
 warning:after U change,u should call layoutNeedUpdate
 */
@property (assign, nonatomic) UICollectionViewScrollDirection direction;
/**
 whether user can drag the view
 default is YES
 */
@property (assign, nonatomic,getter=isUserDragEnable) BOOL userDragEnable;
/**
 whether the scroll is infinite
 default is YES
 */
@property (assign, nonatomic,getter=isInfinite) BOOL infinite;
/**
 whether the scroll is pageControl
 default is YES
 */
@property (assign, nonatomic,getter=isPageControl) BOOL pageControl;
/**
 the auto scroll time
 default is 3.0f
 */
@property (assign, nonatomic) NSTimeInterval timeInterval;
/**
 the item padding
 When scrollDirection is horizontal,item padding is right to next's left.
 When scrollDirection is vertical,item padding is bottom to next's top.
 default is 10.0
 warning:after U change,u should call layoutNeedUpdate
 */
@property (assign, nonatomic) CGFloat itemPadding;
/**
 the edge in cell.contentView
 default is UIEdgeInsetsZero
 warning:after U change,u should call layoutNeedUpdate
 */
@property (assign, nonatomic) UIEdgeInsets viewEdge;
/**
 the view Size
 default is (view's height and view's width) * 0.8
 warning:after U change,u should call layoutNeedUpdate
 */
@property (assign, nonatomic) CGSize itemSize;
/**
 the dataSource
 */
@property (strong, nonatomic) NSArray* modelArray;
/**
 give back the data and the custom view to set data
 */
@property (copy, nonatomic) void(^configureViewBlock)(UIView *view,id model,NSInteger index);
/**
 reload the Data
 */
- (void)reloadData;
/**
 reload the Layout
 */
- (void)layoutNeedUpdate;
/**
 scroll to the specific index
 */
- (void)scrollToIndex:(NSInteger)index;
@end
