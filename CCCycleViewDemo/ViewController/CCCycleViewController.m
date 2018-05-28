//
//  CCCycleViewController.m
//  CCCycleViewDemo
//
//  Created by zacks on 2018/5/28.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCCycleViewController.h"
#import "CCViewScroolView.h"
#import "CCCycleDemoView.h"

@interface CCCycleViewController ()<CCViewScrollViewDelegate,CCViewScrollViewDataSource>
@property (weak, nonatomic) IBOutlet CCViewScroolView *viewScrollView;

@end

@implementation CCCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < 10; i++) {
        NSObject *model = [[NSObject alloc] init];
        model.CC_reUseStringKey = @"cycleView";
        [data addObject:model];
    }
    self.viewScrollView.direction = UICollectionViewScrollDirectionVertical;
    self.viewScrollView.modelArray = data;
    self.viewScrollView.dataSource = self;
    self.viewScrollView.delegate = self;
    self.viewScrollView.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
    self.viewScrollView.configureViewBlock = ^(UIView *view, id model, NSInteger index) {
        CCCycleDemoView *cycleView = (CCCycleDemoView *)view;
        cycleView.titleOneLabel.text = @"传闻：NS版《精灵宝可梦》即将公布";
        cycleView.titleTwoLabel.text = @"传闻：NS版《精灵宝可梦》即将公布";
    };
    [self.viewScrollView layoutNeedUpdate];
    [self.viewScrollView reloadData];
}

#pragma mark - CCViewScrollViewDataSource
- (UIView *)cc_viewForModel:(NSObject *)model
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CCCycleDemoView" owner:nil options:nil] firstObject];
}

#pragma mark - CCViewScrollViewDelegate
- (void)cc_scrollDidSelectItem:(NSInteger)index model:(id)model view:(UIView *)view
{
    NSLog(@"%ld",(long)index);
}

- (void)cc_scrollDidScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    NSLog(@"from:%ld --> to:%ld",fromIndex,toIndex);
}

@end
