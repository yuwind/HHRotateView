>因项目需求，会碰见像下图这样混排的轮播图，于是决定重写一个可以自定义每个pageView的轮播图，按照tableView的使用方法开始了造轮子，使用方法和tableView类似，同时支持重用pageView，横向和纵向。

![Snip20190629_99.png](https://upload-images.jianshu.io/upload_images/1801563-e22116066415fcfb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/1801563-7f696f8bc3a9c7aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 1、使用方法
```objc
@property (nonatomic, assign) BOOL dragEnable;  //default YES
@property (nonatomic, assign) CGFloat interval; //auto scroll time
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
```

## 2、数据源方法

```objc
/* must to implementation */
- (NSInteger)numberOfRowsInRotateView:(HHRotateView *)rotateView;

/* must to implementation call `dequeueReusableCellWithIdentifier` */
- (__kindof HHRotateViewCell *)rotateView:(HHRotateView *)rotateView cellForRowAtIndex:(NSInteger)index;

@optional

/* return a View like UIPageControl need to conform `HHRotateViewDelegate` */
- (__kindof UIView <HHRotateViewDelegate>*)viewForSupplementaryView:(HHRotateView *)rotateView;
/* return a layout object */
- (HHSupplementViewLayout *)layoutForSupplementaryView;
```
`viewForSupplementaryView `为获取pageControl对象
`HHSupplementViewLayout`对象为存储的pageControl的布局对象
```objc
- (HHSupplementViewLayout *)layoutForSupplementaryView
{
//距离底部10pt，中心x与父视图对其
    return HHSupplementViewLayout.new.bottom(-10).centX(0);
}
```

## 3、 效果图
![Untitled.gif](https://upload-images.jianshu.io/upload_images/1801563-0f2056e81a30d4f7.gif?imageMogr2/auto-orient/strip)

## 详见Demo 
