//
//  ViewController.m
//  HHRotateViewDemo
//
//  Created by 豫风 on 2019/6/12.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "ViewController.h"
#import "HHRotateView.h"
#import "HHRotateViewNormal.h"
#import "HHSupplymentView.h"
#import "HHCommon.h"

@interface ViewController ()<HHRotateViewDelegate,HHRotateViewDataSrouce>

@property (nonatomic, strong) HHRotateView *rotateView;
@property (nonatomic, strong) HHSupplymentView *supplyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rotateView = [[HHRotateView alloc] initWithFrame:CGRectZero style:HHRotateViewHorizonal];
    [self.view addSubview:self.rotateView];
    
    self.rotateView.heightTop_(CGRectMake(0, mStatusBarHeight+10, 0, 150));
    [self.rotateView registerClass:HHRotateViewNormal.class identifier:@"HHRotateViewNormal"];
    self.rotateView.dataSource = self;
    self.rotateView.delegate = self;
    
    HHSupplymentView *supplyView = HHSupplymentView.new;
    [self.rotateView addSubview:supplyView];
    self.supplyView = supplyView;
    supplyView.numberOfPages = 5;
    supplyView.style = HHSupplymentViewBar;
    supplyView.currentColor = [UIColor whiteColor];
    supplyView.normalColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    supplyView.bott_.offset_(-10).on_();
    supplyView.centX_.on_();
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

- (void)didSelectCell:(HHRotateViewCell *)cell index:(NSInteger)index {
    NSLog(@"点击了第%ld个cell",index);
}

- (void)rotateView:(HHRotateView *)rotateView didScrollAtIndex:(NSInteger)index {
    self.supplyView.currentPage = index;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.rotateView reloadData];
}

@end
