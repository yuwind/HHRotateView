//
//  HHRotateView.h
//  HHRotateView
//
//  Created by 豫风 on 2019/6/11.
//  Copyright © 2019 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHRotateViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHRotateViewStyle) {
    HHRotateViewHorizonal,
    HHRotateViewVertical,
};

@class HHRotateView;
@protocol HHRotateViewDelegate <NSObject>

@optional
- (void)didSelectCell:(HHRotateViewCell *)cell index:(NSInteger)index;
- (void)rotateView:(HHRotateView *)rotateView didScrollAtIndex:(NSInteger)index;

@end
@protocol HHRotateViewDataSrouce <NSObject>

/* must to implementation */
- (NSInteger)numberOfRowsInRotateView:(HHRotateView *)rotateView;

/* must to implementation call `dequeueReusableCellWithIdentifier` */
- (__kindof HHRotateViewCell *)rotateView:(HHRotateView *)rotateView cellForRowAtIndex:(NSInteger)index;

@end

/**
 a custom carousel, all method invoke just like using tableView, support reuse cell
 
 detail to see the demo
 */
@interface HHRotateView : UIView

@property (nonatomic, assign) BOOL dragEnable;//default YES
@property (nonatomic, assign) BOOL shouldAutoScroll;//default YES
@property (nonatomic, assign) CGFloat timeInterval; //auto scroll time default 5s
@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, weak) id<HHRotateViewDelegate>delegate;
@property (nonatomic, weak) id<HHRotateViewDataSrouce>dataSource;

/** init method  */
- (instancetype)initWithFrame:(CGRect)frame style:(HHRotateViewStyle)style;

/** must to register cell class */
- (void)registerClass:(Class)cellClass identifier:(NSString *)identifier;

/** need to dequeue cell class, support reuse cell */
- (__kindof HHRotateViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier index:(NSInteger)index;

/** reload cell it will call dataSource method */
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
