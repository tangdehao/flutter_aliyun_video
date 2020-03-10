//
//  AlivcShortVideoTabBar.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/8.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
//进入弹层状态的通知
static NSString *AlivcNotificationQuPlay_EnterMask = @"AlivcNotificationQuPlay_EnterMask";
//退出弹层状态的通知
static NSString *AlivcNotificationQuPlay_QutiMask = @"AlivcNotificationQuPlay_QutiMask";

@class AlivcShortVideoTabBar;

NS_ASSUME_NONNULL_BEGIN


@interface AlivcShortVideoTabBar : UITabBar

/**
 中间凸起的按钮
 */
@property (nonatomic, strong) UIButton *centerBtn;

@end

NS_ASSUME_NONNULL_END
