//
//  AlivcImage.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/10/10.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcImage.h"

static NSString *theBundleName = @"aliyun_video";

@implementation AlivcImage

+ (void)setImageBundleName:(NSString *)bundleName{
    theBundleName = bundleName;
}

+ (UIImage *)imageNamed:(NSString *)imageName{
    //baan
    NSString *path = [NSString stringWithFormat:@"%@.bundle/%@",theBundleName,imageName];
    UIImage *image = [UIImage imageNamed:path];
    return image;
    
//    UIImage *image = [UIImage imageNamed:imageName];
//    return image;

}

@end
