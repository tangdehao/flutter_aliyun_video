//
//  AlivcPlayCacheManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/3/8.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcPlayCacheManager.h"

static NSMutableArray *videos = nil;
static NSInteger kSaveCount = 20;

@implementation AlivcPlayCacheManager

#pragma mark - Public Method

+ (void)cacheAVideoModel:(AlivcQuVideoModel *)videoModel{
    if (!videos) {
        videos = [[NSMutableArray alloc]init];
    }
    //1.缓存图片
    if (videoModel.firstFrameImage) {
        [self cacheFirstFrameImage:videoModel.firstFrameImage videoModel:videoModel];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoModel.firstFrameUrl]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                videoModel.firstFrameImage = image;
                [self cacheFirstFrameImage:image videoModel:videoModel];
            });
        });
    }
    
}

+ (void)cacheFirstFrameImage:(UIImage *)image videoModel:(AlivcQuVideoModel *)videoModel{
    //去重
    for (AlivcQuVideoModel *itemModel in videos) {
        if (itemModel == videoModel) {
            return;
        }
    }
    //2.存入数组
    [videos addObject:videoModel];
    NSLog(@"趣视频封面测试：%@---添加进缓存数组",videoModel.videoDescription);
    //3.进行数组管理
    if (videos.count > kSaveCount) {
        AlivcQuVideoModel *firstModel = videos.firstObject;
        firstModel.firstFrameImage = nil;
        [videos removeObject:firstModel];
    }
}


+ (void)clearData{
    if (videos.count) {
        for (AlivcQuVideoModel *itemModel in videos) {
            itemModel.firstFrameImage = nil;
        }
    }
    //头像缓存至为空
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"kAvatorImageSaveString"];
}


@end
