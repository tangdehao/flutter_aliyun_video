//
//  AlivcShortVideoElasticView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/16.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AlivcShortVideoElasticView;

@protocol AlivcShortVideoElasticViewDelegate <NSObject>

/**
 视频拍摄按钮点击回调
 
 @param elasticView 对应的UI容器视图
 @param button 拍摄按钮
 */
- (void)shortVideoElasticView:(AlivcShortVideoElasticView *)elasticView shootButtonTouched:(UIButton *)button;


/**
 视频编辑按钮点击回调
 
 @param elasticView 对应的UI容器视图
 @param button 视频编辑按钮
 */
- (void)shortVideoElasticView:(AlivcShortVideoElasticView *)elasticView editButtonTouched:(UIButton *)button;

@end

@interface AlivcShortVideoElasticView : UIView

/**
 代理
 */
@property (nonatomic,weak) id <AlivcShortVideoElasticViewDelegate> delegate;
/**
 进入编辑状态
 
 @param editStatus YES:进入弹层状态 NO：不进入弹层状态
 @param containView 容器视图
 */
- (void)enterEditStatus:(BOOL)editStatus inView:(UIView *)containView;

@end

NS_ASSUME_NONNULL_END
