# CCCycleView
一个view循环器，目前来说，可以用来制作：
·1.轮播图
[cycleImage](https://github.com/zackschen/CCCycleView/Gifs/CycleImage.gif)
·2.view循环
[cycleView](https://github.com/zackschen/CCCycleView/Gifs/CycleView.gif)
·3.跑马灯效果
[cycleImage](https://github.com/zackschen/CCCycleView/Gifs/MarqueueView.gif)

### Requirement

·Xcode8+

·iOS8+

·ARC

### 使用

使用collectionView作为基础，需要在数据源对象中加入相应的reusekey，以根据数据不同，展示不同的view；还需要返回需要循环播放的view。

1、设置数据源reusekey及参数

```objective-c
NSMutableArray *data = [@[] mutableCopy];
for (int i = 0; i < 10; i++) {
    NSObject *model = [[NSObject alloc] init];
    model.cc_reUseStringKey = @"UIImageView";
    [data addObject:model];
}
self.viewScrollView.viewEdge = UIEdgeInsetsMake(5, 10, 2, 8);
self.viewScrollView.direction = UICollectionViewScrollDirectionHorizontal;
self.viewScrollView.timeInterval = 5.0f;
self.viewScrollView.infinite = YES;
self.viewScrollView.modelArray = data;//数据
self.viewScrollView.dataSource = self;
self.viewScrollView.delegate = self;
self.viewScrollView.userDragEnable = YES;
//回调来给每个view绑定数据
self.viewScrollView.configureViewBlock = ^(UIView *view, id model, NSInteger index) {
    UIImageView *imageView = (UIImageView *)view;
    imageView.image = [UIImage imageNamed:@"0"];
};
[self.viewScrollView layoutNeedUpdate];
[self.viewScrollView reloadData];
```

2、返回view

```objective-c
- (UIView *)cc_viewForModel:(NSObject *)model
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}
```

当然还有其他参数可以设置

```objective-c
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
```

目前的回调仅暴露了2个方法（如果后期有需要，可以加上）

```objective-c
@protocol CCViewScrollViewDelegate <NSObject>

- (void)cc_scrollDidSelectItem:(NSInteger)index model:(id)model view:(UIView *)view;

- (void)cc_scrollDidScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end
```
## License
CCCycleView is released under the MIT license.
## Feedback
·Email：cczacks@gmail.com
·Weibo：鐵甲陳小寶
·Twitter：zacks_Chen
