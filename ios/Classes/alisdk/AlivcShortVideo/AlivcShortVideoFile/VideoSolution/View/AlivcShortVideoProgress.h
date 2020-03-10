//
//  AlivcShortVideoProgress.h
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2018/12/11.
//  Copyright © 2018年 wanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcShortVideoProgress;

@protocol AlivcShortVideoProgressDelegate <NSObject>

- (void)shortVideoProgressView:(AlivcShortVideoProgress *)view dismissButtonTouched:(UIButton *)button;

@end

/**
 下载进度条
 */
@interface AlivcShortVideoProgress : UIView


/**
  进度条宽度 默认：4
 */
@property(nonatomic, assign)CGFloat roundWidth;

/**
 底层圆圈背景色
 */
@property(nonatomic, strong)UIColor *roundBackgroundColor;

/**
 已下载圆圈颜色
 */
@property(nonatomic, strong)UIColor *roundProgressColor;

/**
 当前进度值
 */
@property(nonatomic, assign, readonly)CGFloat progressValue;

/**
 代理
 */
@property(nonatomic, weak) id <AlivcShortVideoProgressDelegate>delegate;

/**
 显示进度条在某个view

 @param view 添加进度条的目标view
 @return 进度条view实例
 */
+ (AlivcShortVideoProgress *)showInView:(UIView *)view delegate:(id <AlivcShortVideoProgressDelegate>)delegate;

/**
 隐藏进度条在某个view

 @param view 隐藏进度条的目标view
 @return 是否成功
 */
+ (BOOL)hideProgressForView:(UIView *)view;

/**
 刷新进度值在某个view

 @param progress 进度值
 @param view 想要刷新进度条进度的目标view
 */
+(void)refreshProgress:(int)progress inView:(UIView *)view;



/**
 刷新进度
 
 @param progress 进度值
 */
//-(void)refreshProgress:(int)progress;
//
///**
// 隐藏进度条
// */
//-(void)hide;
//
//-(void)showInView:(UIView *)superView;

@end
