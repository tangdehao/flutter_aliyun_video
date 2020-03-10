//
//  AlivcQuVideoModel.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//  视频信息的抽象 - 属性有为空的情况，注意判断

#import <Foundation/Foundation.h>
#import "AlivcShortVideoBasicVideoModel.h"

/**
 视频的抽象状态

 - AlivcQuVideoAbstractionStatus_On: 进行中
 - AlivcQuVideoAbstractionStatus_Success: 成功
 - AlivcQuVideoAbstractionStatus_Fail: 失败
 */
typedef NS_ENUM(NSInteger,AlivcQuVideoAbstractionStatus){
    AlivcQuVideoAbstractionStatus_On = 0,
    AlivcQuVideoAbstractionStatus_Success,
    AlivcQuVideoAbstractionStatus_Fail
};

@interface AlivcQuVideoModel : AlivcShortVideoBasicVideoModel
#pragma mark - 初始化方法

/**
 指定初始化方法 - Designated Initializers

 @param dic 用于初始化的数据
 @return 实例化对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

#pragma mark - 原始数据
/**
 创建时间-字符串的原始数据
 */
@property (strong, nonatomic, readonly) NSString *creationTimeString;

/**
 转码状态 - onTranscode（转码中），success（转码成功），fail（转码失败）
 */
@property (strong, nonatomic, readonly) NSString *transcodeStatusString;

/**
 截图状态 - onSnapshot（截图中），success（截图成功），fail（截图失败）
 */
@property (strong, nonatomic, readonly) NSString *snapshotStatusString;

/**
 审核状态 - onCensor（审核中），success（审核成功），fail（审核不通过）
 */
@property (strong, nonatomic, readonly) NSString *censorStatusString;

/**
 窄带高清转码状态 - onTranscode（转码中），success（转码成功），fail（转码失败）
 ps:窄带高清也是一种特殊的转码
 */
@property (strong, nonatomic, readonly) NSString *narrowTranscodeStatusString;


#pragma mark - 方便开发者使用的二次包装 - 基于原始数据
/**
 视频时长（秒）
 */
@property (assign, nonatomic, readonly) NSInteger duration;

/**
 创建时间
 */
@property (strong, nonatomic, readonly) NSDate *creationDate;

/**
 转码状态 - onTranscode（转码中），success（转码成功），fail（转码失败）
 */
@property (assign, nonatomic, readonly) AlivcQuVideoAbstractionStatus transcodeStatus;

/**
 截图状态 - onSnapshot（截图中），success（截图成功），fail（截图失败）
 */
@property (assign, nonatomic, readonly) AlivcQuVideoAbstractionStatus snapshotStatus;

/**
 审核状态 - assign（审核中），success（审核成功），fail（审核不通过）
 */
@property (assign, nonatomic, readonly) AlivcQuVideoAbstractionStatus ensorStatus;

/**
 窄带高清转码状态 - onTranscode（转码中），success（转码成功），fail（转码失败）
 ps:窄带高清也是一种特殊的转码
 */
@property (assign, nonatomic, readonly) AlivcQuVideoAbstractionStatus narrowTranscodeStatus;



@end


