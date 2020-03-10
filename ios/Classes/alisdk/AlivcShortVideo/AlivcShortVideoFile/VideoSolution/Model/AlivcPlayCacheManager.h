//
//  AlivcPlayCacheManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/3/8.
//  Copyright © 2019年 Alibaba. All rights reserved.
//  管理封面图的缓存策略，本地存储策略

#import <Foundation/Foundation.h>
#import "AlivcQuVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcPlayCacheManager : NSObject

/**
 缓存一个数据模型 - 主要是封面图

 @param videoModel 数据模型
 */
+ (void)cacheAVideoModel:(AlivcQuVideoModel *)videoModel;

/**
 销毁内存与本地存储
 */
+ (void)clearData;

@end

NS_ASSUME_NONNULL_END
