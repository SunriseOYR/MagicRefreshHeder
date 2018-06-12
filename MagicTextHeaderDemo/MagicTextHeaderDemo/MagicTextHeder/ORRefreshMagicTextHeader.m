//
//  ORRefreshMagicTextHeader.h
//  ORST_Test
//
//  Created by 欧阳荣 on 2018/5/7.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import "ORRefreshMagicTextHeader.h"


@interface ORRefreshMagicTextHeader()
@property (nonatomic, assign) BOOL dontUpdate;
@property (nonatomic, assign) BOOL needEndAnimation;

@property (nonatomic, strong) ORMagicTextLayer *ttlayer;

@end

@implementation ORRefreshMagicTextHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];

    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    

    
    CGRect rect = CGRectMake(0, 0, width, self.bounds.size.height);

    NSString *text = self.text ? self.text : @"MagicText";
    
    _ttlayer = [ORMagicTextLayer layerWithText:text rect:rect];
    _ttlayer.maskColor = [UIColor lightGrayColor];
    _ttlayer.tintColor = [UIColor blueColor];
    
//    _ttlayer.font = [UIFont fontWithName:@"PingFangSC-Ultralight" size:38];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _ttlayer.progress = 0.f;
    [CATransaction commit];
    [CATransaction setDisableActions:NO];
    [CATransaction commit];

    [self.layer addSublayer:_ttlayer];
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    _dontUpdate = NO;

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state//首次idle-ing-idle 其余 pull-ing-idle
{
    MJRefreshCheckState;
    if (state == MJRefreshStateRefreshing) {

        _ttlayer.progress = 1.f;
        [_ttlayer startLoadAnimation];
        return;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    UIScrollView *sv = (UIScrollView *)self.superview;
    if (sv.isDragging || !_dontUpdate) {
        if (sv.isDragging) {
            _needEndAnimation = YES;
        }
        _dontUpdate = NO;
        _ttlayer.progress = pullingPercent;
    }
}

- (void)beginRefreshing{
    [super beginRefreshing];
    _needEndAnimation = YES;
}

- (void)endRefreshingWithoutAnimation{
    [super endRefreshing];
}

- (void)endRefreshing{
    if (!_needEndAnimation) {
        return;
    }
    /**必须在super前设置，防止闪烁*/
    _dontUpdate = YES;
    [super endRefreshing];
    [_ttlayer stopLoadAnimation];
    _ttlayer.progress = 0.f;
}

- (ORloadingStyle)loadStyle {
    return _ttlayer.loadingStyle;
}

- (void)setLoadStyle:(ORloadingStyle)loadStyle {
    _ttlayer.loadingStyle = loadStyle;
}

- (void)setFont:(UIFont *)font {
    _ttlayer.font = font;
}

- (void)setText:(NSString *)text {
    _ttlayer.text = text;
}

- (void)setTintColor:(UIColor *)tintColor {
    _ttlayer.tintColor = tintColor;
}

@end
