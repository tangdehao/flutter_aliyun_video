//
//  AlivcShortVideoUploadProgressView.h
//  AliyunVideoClient_Entrance
//
//  Created by 张璠 on 2018/11/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlivcShortVideoUploadProgressView : UIView
/**
 上传进度，0-1
 */
@property (nonatomic, assign) CGFloat progress;

- (instancetype)initWithBackgroundImage:(UIImage *)image;

- (void)setShowText:(NSString *)text;
@end
