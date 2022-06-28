//
//  HHBaseTableViewController.m
//  BaseTabBar
//
//  Created by yufeng on 2017/6/22.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import "HHBaseTableViewController.h"
#import "HHBaseTableViewCellModel.h"
#import "HHBaseTableViewCell.h"
#import "NSArray+HHSafe.h"
#import "NSObject+HHAdd.h"

@interface HHBaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HHBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseTableView];
}

- (void)configBaseTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.containerView.bounds style:UITableViewStylePlain];
    [self.containerView addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    for (Class class in [self registerReusableCell]) {
        [self.tableView registerClass:class forCellReuseIdentifier:NSStringFromClass(class)];
    }
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *tableViewDict = NSDictionaryOfVariableBindings(_tableView);
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:tableViewDict]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:tableViewDict]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isTwoDimensionalArray]) {
        return [self modelArray].count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isTwoDimensionalArray]) {
        NSArray *array = [[self modelArray] hh_objectSafelyAtIndex:section];
        return array.count;
    }
    return [self modelArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = nil;
    if ([self isTwoDimensionalArray]) {
        NSArray *array = [[self modelArray] hh_objectSafelyAtIndex:indexPath.section];
        model = [array hh_objectSafelyAtIndex:indexPath.row];
    } else {
        model = [[self modelArray] hh_objectSafelyAtIndex:indexPath.row];
    }
    HHBaseTableViewCellModel *cellModel = [model hh_as:HHBaseTableViewCellModel.class];
    NSString *reusableIdentifier = cellModel.reusableIdentifier;
    if (reusableIdentifier.length == 0) {
        reusableIdentifier = [self reusableIdentifier];
    }
    HHBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        NSAssert(NO, @"cell must not be nil");
        return [[UITableViewCell alloc] init];
    }
    cell.delegate = self;
    [cell updateCellWithModel:model];
    return cell;
}

- (NSArray *)modelArray {
    return @[];
}

- (NSArray<Class> *)registerReusableCell {
    return @[HHBaseTableViewCell.class];
}

- (NSString *)reusableIdentifier {
    return NSStringFromClass([self registerReusableCell].firstObject);
}

- (BOOL)isTwoDimensionalArray {
    NSArray *array = [self modelArray];
    NSArray *firstObject = [array hh_objectSafelyAtIndex:0];
    return [firstObject isKindOfClass:NSArray.class];
}

@end
