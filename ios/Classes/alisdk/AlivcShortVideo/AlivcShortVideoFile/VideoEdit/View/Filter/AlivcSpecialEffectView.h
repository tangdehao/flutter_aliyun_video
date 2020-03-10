//
//  AlivcSpecialEffectView.h
//  AliyunVideoClient_Entrance
//
//  Created by 张璠 on 2018/11/19.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliyunEffectFilterInfo.h"
#import "AliyunEffectMvGroup.h"
#import "AliyunTimelineView.h"

@protocol AlivcSpecialEffectViewDelegate <NSObject>
@optional

/**
 应用滤镜特效的效果
 */
- (void)applyButtonClick;

/**
 取消滤镜特效的效果
 */
- (void)noApplyButtonClick;

/**
 开始长按的时候的代理方法
 
 @param animtinoFilter 滤镜特效数据模型
 */
- (void)didBeganLongPressEffectFilter:(AliyunEffectFilterInfo *)animtinoFilter;

/**
 结束长按的时候的代理方法
 */
- (void)didEndLongPress;

/**
 滤镜特效的回删
 */
- (void)didRevokeButtonClick;

/**
 长按过程中定时调用的代理方法（每0.1秒调用一次）
 */
- (void)didTouchingProgress;

@end
@interface AlivcSpecialEffectView : UIView
/**
 此类的代理
 */
@property (nonatomic, weak) id<AlivcSpecialEffectViewDelegate> delegate;

/**
 选中的特效的数据模型
 */
@property (nonatomic, strong) AliyunEffectInfo *selectedEffect;


/**
 设置缩略图。frame自适应，不用设置frame
 
 */
@property (nonatomic, strong) AliyunTimelineView *timelineView;

/**
 让特效处于初始状态
 */
- (void)specialFilterReset;

/**
 结束长按手势 - 用与添加特效到视频最后时，结束长按手势
 */
- (void)endLongPress;
@end
