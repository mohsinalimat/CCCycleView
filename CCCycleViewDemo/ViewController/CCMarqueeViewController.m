//
//  CCMarqueeViewController.m
//  CCCycleViewDemo
//
//  Created by zacks on 2018/5/28.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCMarqueeViewController.h"
#import "CCViewScroolView.h"

@interface CCMarqueeViewController ()<CCViewScrollViewDataSource,CCViewScrollViewDelegate>
@property (weak, nonatomic) IBOutlet CCViewScroolView *marqueeView;

@end

@implementation CCMarqueeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < 10; i++) {
        NSObject *model = [[NSObject alloc] init];
        model.cc_reUseStringKey = @"marqueee";
        [data addObject:model];
    }
    self.marqueeView.itemPadding = 0;
    self.marqueeView.direction = UICollectionViewScrollDirectionHorizontal;
    self.marqueeView.modelArray = data;
    self.marqueeView.dataSource = self;
    self.marqueeView.delegate = self;
    self.marqueeView.pageControl = NO;
    self.marqueeView.configureViewBlock = ^(UIView *view, id model, NSInteger index) {
        UILabel *label = (UILabel *)view;
        label.text = @"1 作为京师第一剑师，王越此时完全没了往日的气焰，自洛阳到徐州，一个月来，大小百余战，几乎使他灯枯油尽。 现在，已是深夜，他只想倒头睡三天，但窗外几声浅浅的呼吸告诉他万万不能倒下。 或许，这就是";
    };
    [self.marqueeView layoutNeedUpdate];
    [self.marqueeView reloadData];
}

#pragma mark - CCmarqueeViewDataSource
- (UIView *)cc_viewForModel:(NSObject *)model
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

- (CGSize)cc_viewForModel:(id)model index:(NSInteger)index
{
    return CGSizeMake([@"1 作为京师第一剑师，王越此时完全没了往日的气焰，自洛阳到徐州，一个月来，大小百余战，几乎使他灯枯油尽。 现在，已是深夜，他只想倒头睡三天，但窗外几声浅浅的呼吸告诉他万万不能倒下。 或许，这就是" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width + 30, 30);
}

#pragma mark - CCmarqueeViewDelegate
- (void)cc_scrollDidSelectItem:(NSInteger)index model:(id)model view:(UIView *)view
{
    NSLog(@"%ld",(long)index);
}

- (void)cc_scrollDidScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    NSLog(@"from:%ld --> to:%ld",fromIndex,toIndex);
}

@end
