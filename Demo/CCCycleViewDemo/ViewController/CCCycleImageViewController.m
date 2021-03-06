//
//  CCCycleImageViewController.m
//  CCCycleViewDemo
//
//  Created by MDLK-CC on 2018/5/10.
//  Copyright © 2018年 CC. All rights reserved.
//

#import "CCCycleImageViewController.h"
#import "CCViewScroolView.h"
#import "CCCycleViewDemoModel.h"

@interface CCCycleImageViewController ()<CCViewScrollViewDataSource,CCViewScrollViewDelegate>

@property (strong, nonatomic) IBOutlet CCViewScroolView *viewScrollView;

@property (weak, nonatomic) IBOutlet UITextField *indexField;

@end

@implementation CCCycleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *data = [@[] mutableCopy];
    for (int i = 0; i < 10; i++) {
        NSObject *model = [[NSObject alloc] init];
        model.cc_reUseStringKey = @"UIImageView";
        [data addObject:model];
    }
    self.viewScrollView.viewEdge = UIEdgeInsetsZero;
    self.viewScrollView.direction = UICollectionViewScrollDirectionHorizontal;
    self.viewScrollView.timeInterval = 5.0f;
    self.viewScrollView.infinite = YES;
    self.viewScrollView.modelArray = data;
    self.viewScrollView.dataSource = self;
    self.viewScrollView.delegate = self;
    self.viewScrollView.userDragEnable = YES;
    self.viewScrollView.configureViewBlock = ^(UIView *view, id model, NSInteger index) {
        UIImageView *imageView = (UIImageView *)view;
        UIImage *image = [UIImage imageNamed:@"0"];
        imageView.image = image;
    };
    [self.viewScrollView layoutNeedUpdate];
    [self.viewScrollView reloadData];
}


#pragma mark - CCViewScrollViewDataSource
- (UIView *)cc_viewForModel:(NSObject *)model
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
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


#pragma mark - 操作事件
- (IBAction)itemSizeDidChange:(UISlider *)sender {
    self.viewScrollView.itemSize = CGSizeMake(self.viewScrollView.frame.size.width*sender.value, self.viewScrollView.frame.size.height*sender.value);
    [self.viewScrollView layoutNeedUpdate];
}
- (IBAction)itemPaddingDidChange:(UISlider *)sender {
    self.viewScrollView.itemPadding = 100*sender.value;
    [self.viewScrollView layoutNeedUpdate];
}
- (IBAction)goButtonDidClick:(UIButton *)sender {
    [self.viewScrollView scrollToIndex:[self.indexField.text integerValue]];
}
- (IBAction)scrollDirectionDidChange:(UISwitch *)sender {
    self.viewScrollView.direction = sender.isOn;
    [self.viewScrollView layoutNeedUpdate];
}
- (IBAction)infiniteDidChange:(UISwitch *)sender {
    self.viewScrollView.infinite = sender.isOn;
    [self.viewScrollView reloadData];
}
@end
