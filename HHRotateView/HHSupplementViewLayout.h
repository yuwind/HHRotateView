//
//  HHSupplementViewLayout.h
//  HHRotateView
//
//  Created by 豫风 on 2019/6/12.
//  Copyright © 2019 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSupplementViewLayout : NSObject

@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^left)(CGFloat padding);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^right)(CGFloat padding);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^top)(CGFloat padding);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^bottom)(CGFloat padding);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^height)(CGFloat padding);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^size)(CGSize size);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^centX)(CGFloat padding);
@property (nonatomic, copy, readonly) HHSupplementViewLayout *(^centY)(CGFloat padding);
@property (nonatomic, copy, readonly) NSArray *relationArray;
@property (nonatomic, copy, readonly) NSArray *constArray;

@end
