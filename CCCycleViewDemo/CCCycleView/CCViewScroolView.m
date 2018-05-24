//
//  CCViewScroolView.m
//  MadrockChat
//
//  Created by MDLK-CC on 2018/5/7.
//  Copyright © 2018年 MadRock. All rights reserved.
//

#import "CCViewScroolView.h"
#import "CCViewScrollViewCell.h"

@interface CCViewScroolView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic,readwrite) UICollectionView *collectionView;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger numOfPerSection;

@property (assign, nonatomic) CGPoint lastContentPosition;

@property (assign, nonatomic) NSIndexPath *nowIndexPath;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation CCViewScroolView

static NSInteger CCViewScrollMaxSection = 200;

#pragma mark - Init Method
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    
    [self paraInit];
}

- (void)paraInit
{
    self.timeInterval = 3.0f;
    self.userDragEnable = YES;
    self.infinite = YES;
    self.viewEdge = UIEdgeInsetsZero;
    self.direction = UICollectionViewScrollDirectionHorizontal;
    self.itemPadding = 10.0;
}

#pragma mark - public method 
- (void)reloadData
{
    [self.collectionView reloadData];
    self.nowIndexPath = self.nowIndexPath.row > 0 ? self.nowIndexPath : [NSIndexPath indexPathForRow:0 inSection:self.infinite?CCViewScrollMaxSection/2:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:[self targetPointForIndexPath:self.nowIndexPath] animated:NO];
    });
}

- (void)layoutNeedUpdate
{
    if (self.itemSize.height <= 0 || self.itemSize.width <= 0) {return;}
    
    self.layout.itemSize = self.itemSize;
    self.layout.minimumInteritemSpacing = self.itemPadding;
    self.layout.minimumLineSpacing = self.itemPadding;
    self.layout.scrollDirection = self.direction;
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setContentOffset:[self targetPointForIndexPath:self.nowIndexPath] animated:NO];
}

- (void)scrollToIndex:(NSInteger)index
{
    [self.collectionView reloadData];
    
    self.nowIndexPath = [NSIndexPath indexPathForRow:index inSection:index <= self.nowIndexPath.row ? self.nowIndexPath.section : self.nowIndexPath.section + 1];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:[self targetPointForIndexPath:self.nowIndexPath] animated:YES];
    });
}

#pragma mark - setParam

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    NSMutableSet *reuseKeys = [NSMutableSet set];
    for (NSObject * model in modelArray) {
        [reuseKeys addObject:model.CC_reUseStringKey];
    }
    for (NSString *key in reuseKeys) {
        [self.collectionView registerClass:[CCViewScrollViewCell class] forCellWithReuseIdentifier:key];
    }
    [self.collectionView reloadData];
}

- (void)setDirection:(UICollectionViewScrollDirection)direction
{
    _direction = direction;
    [self layoutNeedUpdate];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    
    [self cancleTimer];
    
    [self setupTimer];
}

- (void)setUserDragEnable:(BOOL)userDragEnable
{
    _userDragEnable = userDragEnable;
    self.collectionView.userInteractionEnabled = userDragEnable;
}

#pragma mark - Timer

- (void)setupTimer
{
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)cancleTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)timerRun:(NSTimer *)timer
{
    NSIndexPath *first = self.nowIndexPath;
    NSIndexPath *new = [NSIndexPath indexPathForRow:first.row+1 inSection:first.section];
    if (first.row >= self.numOfPerSection - 1) {
        if (self.infinite) {
            new = [NSIndexPath indexPathForRow:0 inSection:first.section + 1];
            if (new.section >= CCViewScrollMaxSection) {
                new = [NSIndexPath indexPathForRow:0 inSection:0];
            }
        }else{
             new = [NSIndexPath indexPathForRow:0 inSection:0];
        }
    }
    
    [self.collectionView setContentOffset:[self targetPointForIndexPath:new] animated:YES];
}

#pragma mark - canculate

/**
 计算一个点属于哪个indexPath
 */
- (NSIndexPath *)indexPathForPoint:(CGPoint)point
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    if (self.direction == UICollectionViewScrollDirectionHorizontal) {
        CGFloat firstLeftPadding = [self getEdgeInsetsForSection:0].left;
        
        CGFloat middleLeftPadding = [self getEdgeInsetsForSection:1].left;
        CGFloat middleRightPadding = [self getEdgeInsetsForSection:1].right;
        
        if (!self.infinite) {
            NSInteger row = (point.x - firstLeftPadding + layout.itemSize.width/2.0) /(layout.minimumLineSpacing + layout.itemSize.width);
            return [NSIndexPath indexPathForRow:row inSection:0];
        }
        
        CGFloat sectionW = (middleLeftPadding + middleRightPadding) + self.numOfPerSection * layout.itemSize.width + (self.numOfPerSection - 1) * layout.minimumLineSpacing;
        
        CGFloat realX = point.x - firstLeftPadding;
        NSInteger section = realX/sectionW;
        
        CGFloat left = fmod(realX, sectionW);
        NSInteger row = (left - middleLeftPadding)/(layout.minimumLineSpacing + layout.itemSize.width);
        return [NSIndexPath indexPathForRow:row inSection:section];
    }else{
        CGFloat firstTopPadding = [self getEdgeInsetsForSection:0].top;
        CGFloat middleTopPadding = [self getEdgeInsetsForSection:1].top;
        CGFloat middleBottomPadding = [self getEdgeInsetsForSection:1].bottom;
        
        if (!self.infinite) {
            NSInteger row = (point.y - firstTopPadding + layout.itemSize.height/2.0) /(layout.minimumInteritemSpacing + layout.itemSize.height);
            return [NSIndexPath indexPathForRow:row inSection:0];
        }
        
        CGFloat sectionH = (middleTopPadding + middleBottomPadding) + self.numOfPerSection * layout.itemSize.height + (self.numOfPerSection - 1) * layout.minimumInteritemSpacing;
        
        CGFloat realY = point.y - firstTopPadding;
        NSInteger section = realY/sectionH;
        
        CGFloat left = fmod(realY, sectionH);
        NSInteger row = (left - middleTopPadding)/(layout.minimumInteritemSpacing + layout.itemSize.height);
        return [NSIndexPath indexPathForRow:row inSection:section];
    }
}

/**
 返回一个indexPath的中点位置
 */
- (CGPoint)targetPointForIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    if (self.direction == UICollectionViewScrollDirectionHorizontal) {
        CGFloat firstLeftPadding = [self getEdgeInsetsForSection:0].left;
        
        CGFloat middleLeftPadding = [self getEdgeInsetsForSection:1].left;
        CGFloat middleRightPadding = [self getEdgeInsetsForSection:2].right;
        
        CGFloat sectionW = (middleLeftPadding + middleRightPadding) + self.numOfPerSection * layout.itemSize.width + (self.numOfPerSection - 1) * layout.minimumLineSpacing;
        
        return CGPointMake(sectionW * indexPath.section + firstLeftPadding + (layout.minimumLineSpacing + layout.itemSize.width)*indexPath.row - firstLeftPadding,0);
    }else{
        CGFloat firstTopPadding = [self getEdgeInsetsForSection:0].top;
        
        CGFloat middleTopPadding = [self getEdgeInsetsForSection:1].top;
        CGFloat middleBottomPadding = [self getEdgeInsetsForSection:1].bottom;
        
        CGFloat sectionH = (middleTopPadding + middleBottomPadding) + self.numOfPerSection * layout.itemSize.height + (self.numOfPerSection - 1) * layout.minimumInteritemSpacing;
        
        return CGPointMake(0 ,sectionH * indexPath.section + firstTopPadding + (layout.minimumInteritemSpacing + layout.itemSize.height)*indexPath.row - firstTopPadding);
    }
}


/**
 根据不同的section、direction 返回不同的edge
 */
- (UIEdgeInsets)getEdgeInsetsForSection:(NSInteger)section
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat padding = 0;
    if (self.direction == UICollectionViewScrollDirectionHorizontal) {
        padding = (CGRectGetWidth(self.collectionView.frame) - layout.itemSize.width)/2.0;
    }else{
        padding = (CGRectGetHeight(self.collectionView.frame) - layout.itemSize.height)/2.0;
    }
    
    CGFloat verticalPadding = (CGRectGetHeight(self.collectionView.frame) - self.itemSize.height)/2;
    CGFloat horizontalPadding = (CGRectGetWidth(self.collectionView.frame) - self.itemSize.width)/2;
    
    if (!self.infinite) {
        return self.direction ? UIEdgeInsetsMake(verticalPadding, padding, verticalPadding, padding) : UIEdgeInsetsMake(padding, horizontalPadding, padding, horizontalPadding);
    }
    
    if (section == 0) {
        return self.direction ? UIEdgeInsetsMake(verticalPadding, padding, verticalPadding, layout.minimumLineSpacing) : UIEdgeInsetsMake(padding, 0, layout.minimumLineSpacing, 0);
    }else if (section == CCViewScrollMaxSection - 1){
        return self.direction ? UIEdgeInsetsMake(verticalPadding, 0, verticalPadding, layout.sectionInset.right) : UIEdgeInsetsMake(0, horizontalPadding, layout.sectionInset.bottom, horizontalPadding);
    }
    return self.direction ? UIEdgeInsetsMake(verticalPadding, 0, verticalPadding, layout.minimumLineSpacing) : UIEdgeInsetsMake(0, horizontalPadding,layout.minimumInteritemSpacing, horizontalPadding);
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.infinite ? CCViewScrollMaxSection : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.numOfPerSection = self.modelArray.count;
    return self.numOfPerSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject * model = self.modelArray[indexPath.row];
    CCViewScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.CC_reUseStringKey forIndexPath:indexPath];
    if (!cell.subView) {
        cell.viewEdge = self.viewEdge;
        cell.subView = [self.dataSource CC_viewForModel:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject * model = self.modelArray[indexPath.row];
    CCViewScrollViewCell *scrollCell = (CCViewScrollViewCell *)cell;
    if (self.configureViewBlock) {
        self.configureViewBlock(scrollCell.subView, model, indexPath.row);
    }
}
#pragma mark - CollectionFlowLayoutDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [self getEdgeInsetsForSection:section];
}

#pragma mark - Collection Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(CC_scrollDidSelectItem:model:view:)]) {
        CCViewScrollViewCell *cell = (CCViewScrollViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSObject * model = self.modelArray[indexPath.row];
        [self.delegate CC_scrollDidSelectItem:indexPath.row model:model view:cell.subView];
    }
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *oldPath = self.nowIndexPath;
    if (self.direction) {
        self.nowIndexPath = [self indexPathForPoint:CGPointMake(scrollView.contentOffset.x + scrollView.bounds.size.width/2.0, scrollView.contentOffset.y)];
    }else{
        self.nowIndexPath = [self indexPathForPoint:CGPointMake(scrollView.contentOffset.x,scrollView.contentOffset.y + scrollView.bounds.size.height/2.0)];
    }
    
    if (oldPath != self.nowIndexPath) {
        if ([self.delegate respondsToSelector:@selector(CC_scrollDidScrollFromIndex:toIndex:)]) {
            [self.delegate CC_scrollDidScrollFromIndex:oldPath.row toIndex:self.nowIndexPath.row];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancleTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ((self.direction && fabs(velocity.x) < 0.5) || (self.direction == 0 && fabs(velocity.y) < 0.5)) {//滑动力度小 回到最近的cell
        targetContentOffset->x = [self targetPointForIndexPath:self.nowIndexPath].x;
        return;
    }
    NSIndexPath *index = [self indexPathForPoint:*targetContentOffset];
    CGPoint target = [self targetPointForIndexPath:index];
    self.lastContentPosition = target;
    if (self.direction) {
        targetContentOffset->x = target.x;
    }else{
        targetContentOffset->y = target.y;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.collectionView.frame, self.frame)) {
        self.collectionView.frame = self.bounds;
        self.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame)*0.8, CGRectGetHeight(self.collectionView.frame)*0.8);
        [self layoutNeedUpdate];
    }
}

@end
