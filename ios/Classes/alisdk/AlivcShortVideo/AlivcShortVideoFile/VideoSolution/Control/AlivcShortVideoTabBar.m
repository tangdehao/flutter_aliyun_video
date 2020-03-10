//
//  AlivcShortVideoTabBar.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/8.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoTabBar.h"

@interface AlivcShortVideoTabBar ()


/**
 生成的用于回调的barItem,认准tag101
 */
@property (nonatomic, strong) UITabBarItem *centerItem;
@end

@implementation AlivcShortVideoTabBar

- (UIButton *)centerBtn
{
    if (_centerBtn == nil) {
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
        [_centerBtn setImage:[AlivcImage imageNamed:@"alivc_svHome_add"] forState:UIControlStateNormal];
        [_centerBtn setImage:[AlivcImage imageNamed:@"alivc_svHome_addClose"] forState:UIControlStateSelected];
        [_centerBtn addTarget:self action:@selector(clickCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.centerItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:101];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitMask) name:AlivcNotificationQuPlay_QutiMask object:nil];
    }
    return _centerBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 把 tabBarButton 取出来（把 tabBar 的 subViews 打印出来就明白了）
    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonArray addObject:view];
        }
    }
    
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    CGFloat centerBtnWidth = CGRectGetWidth(self.centerBtn.frame);
//    CGFloat centerBtnHeight = CGRectGetHeight(self.centerBtn.frame);
    
    // 重新布局其他 tabBarItem
    // 平均分配其他 tabBarItem 的宽度
    CGFloat barItemWidth = (barWidth - centerBtnWidth) / tabBarButtonArray.count;
    // 逐个布局 tabBarItem，修改 UITabBarButton 的 frame
    __block CGFloat centerBtn_cx = barHeight / 2;
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat beside = barItemWidth / 4; //偏移量
        CGRect frame = view.frame;
        // 只能适应2个item的情况，多个item需要另外改代码
        if (idx >= tabBarButtonArray.count / 2) {
            // 重新设置 x 坐标，如果排在中间按钮的右边需要加上中间按钮的宽度
            frame.origin.x = idx * barItemWidth + centerBtnWidth + beside;
        } else {
            frame.origin.x = idx * barItemWidth - beside;
        }
        // 重新设置宽度
        frame.size.width = barItemWidth;
        view.frame = frame;
        centerBtn_cx = view.center.y;
    }];
    
    // 设置中间按钮的位置，居中，凸起一丢丢
    self.centerBtn.center = CGPointMake(barWidth / 2, centerBtn_cx - 10);
    
    // 把中间按钮带到视图最前面
    if (self.centerBtn.superview == nil) {
        [self addSubview:self.centerBtn];
    }
    [self bringSubviewToFront:self.centerBtn];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.clipsToBounds || self.hidden || (self.alpha == 0.f)) {
        return nil;
    }
    UIView *result = [super hitTest:point withEvent:event];
    // 如果事件发生在 tabbar 里面直接返回
    if (result) {
        return result;
    }
    // 这里遍历那些超出的部分就可以了，不过这么写比较通用。
    for (UIView *subview in self.subviews) {
        // 把这个坐标从tabbar的坐标系转为 subview 的坐标系
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        // 如果事件发生在 subView 里就返回
        if (result) {
            return result;
        }
    }
    return nil;
}

#pragma mark - UIRespon
- (void)clickCenterBtn:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationQuPlay_EnterMask object:nil];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationQuPlay_QutiMask object:nil];
    }
  
}

- (void)quitMask{
    self.centerBtn.selected = NO;
}

@end
