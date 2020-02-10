//
//  AliyunTimelineTimeFilterItem.h
//  qusdk
//
//  Created by Vienta on 2018/2/26.
//  Copyright © 2018年 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h> //先简单写

@interface AliyunTimelineTimeFilterItem : NSObject

@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat endTime;
@property (nonatomic, strong) UIColor *displayColor;
@property (nonatomic, strong) id obj;

@end
