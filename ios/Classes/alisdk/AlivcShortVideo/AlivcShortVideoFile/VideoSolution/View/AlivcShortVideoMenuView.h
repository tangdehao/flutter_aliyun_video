//
//  AlivcShortVideoMenuView.h
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2018/12/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlivcShortVideoMenuViewDelegate<NSObject>

-(void)alivcShortVideoMenuViewDownloadAction;

-(void)alivcShortVideoMenuViewDeleteAction;

@end

@interface AlivcShortVideoMenuView : UIView

@property(nonatomic, weak)id<AlivcShortVideoMenuViewDelegate> _Nullable delegate;

/**
 显示View到指定View上
 
 @param superView 目标View
 @param animation 是否以动画方式显示
 @param completion 动画完成后的回调
 */
-(void)showInView:(UIView *)superView animation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion;

/**
 隐藏View
 
 @param animation 是否以动画方式隐藏
 @param completion 动画完成后的回调
 */
-(void)hiddenAnimation:(BOOL)animation completion:(void (^ __nullable)(BOOL finished))completion;

- (void)addDeleteButton;

- (void)hideDeleteButton;

@end
