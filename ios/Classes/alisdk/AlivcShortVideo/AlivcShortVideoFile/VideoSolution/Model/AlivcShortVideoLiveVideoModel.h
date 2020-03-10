//
//  AlivcShortVideoLiveModel.h
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/5/15.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "AlivcShortVideoBasicVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcShortVideoLiveVideoModel : AlivcShortVideoBasicVideoModel


/**
 指定初始化方法 - Designated Initializers
 
 @param dic 用于初始化的数据
 @return 实例化对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 id - 数据库自动递增的标识
 */
@property (strong, nonatomic, readonly) NSString *liveId;

@property (strong, nonatomic, readonly) NSString *liveUrl;


@end

NS_ASSUME_NONNULL_END
