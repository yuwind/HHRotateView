//
//  ViewController.m
//  HHRotateViewDemo
//
//  Created by 豫风 on 2019/6/12.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "ViewController.h"
#import "HHRotateView.h"
#import "UIView+HHLayout.h"
#import "HHRotateViewNormal.h"
#import "HHSupplymentView.h"

@interface ViewController ()<HHRotateViewDelegate,HHRotateViewDataSrouce>

@property (nonatomic, strong) HHRotateView *rotateView;
@property (nonatomic, strong) HHRotateView *verticalRotateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rotateView = [[HHRotateView alloc] initWithFrame:CGRectZero style:HHRotateViewHorizonal];
    [self.view addSubview:self.rotateView];
    self.rotateView.heightTop_(CGRectMake(0, 20, 0, 150));
    [self.rotateView registerClass:HHRotateViewNormal.class identifier:@"HHRotateViewNormal"];
    self.rotateView.dataSource = self;
    self.rotateView.delegate = self;
    self.rotateView.dragEnable = YES;
    [self.rotateView reloadData];
    
    self.verticalRotateView = [[HHRotateView alloc] initWithFrame:CGRectZero style:HHRotateViewVertical];
    [self.view addSubview:self.verticalRotateView];
    self.verticalRotateView.heightTop_(CGRectMake(0, 200, 0, 150));
    [self.verticalRotateView registerClass:HHRotateViewNormal.class identifier:@"HHRotateViewNormal"];
    self.verticalRotateView.dataSource = self;
    self.verticalRotateView.delegate = self;
    [self.verticalRotateView reloadData];
}

- (NSInteger)numberOfRowsInRotateView:(HHRotateView *)rotateView {
    return 5;
}

- (HHRotateViewCell *)rotateView:(HHRotateView *)rotateView cellForRowAtIndex:(NSInteger)index {
    HHRotateViewNormal *cell = [rotateView dequeueReusableCellWithIdentifier:@"HHRotateViewNormal" index:index];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    [cell updateTitleWithIndex:index];
    return cell;
}

- (UIView<HHRotateViewDelegate> *)viewForSupplementaryView:(HHRotateView *)rotateView
{
    static BOOL isInitial = NO;
    HHSupplymentView *supplyView = HHSupplymentView.new;
    supplyView.numberOfPages = 5;
    supplyView.style = isInitial?HHSupplymentViewDot:HHSupplymentViewBar;
    supplyView.currentColor = [UIColor whiteColor];
    supplyView.normalColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    isInitial = YES;
    return supplyView;
}

- (HHSupplementViewLayout *)layoutForSupplementaryView
{
    return HHSupplementViewLayout.new.bottom(-10).centX(0);
}

- (void)didSelectCell:(HHRotateViewCell *)cell index:(NSInteger)index
{
    NSLog(@"点击了第%ld个cell",index);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.rotateView reloadData];
}


@end
