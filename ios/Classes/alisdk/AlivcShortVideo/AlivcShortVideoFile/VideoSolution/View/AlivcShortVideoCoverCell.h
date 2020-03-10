//
//  AlivcShortVideoCoverCell.h
//  AliyunVideoClient_Entrance
//
//  Created by 孙震 on 2019/4/3.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AliyunPlayer/AliyunPlayer.h>baan
#import "AlivcQuVideoModel.h"
#import "AlivcShortVideoLiveVideoModel.h"
#import "AlivcShortVideoBasicVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AlivcShortVideoCoverCell : UICollectionViewCell

@property (nonatomic, strong) AlivcShortVideoBasicVideoModel *model;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//- (void)addPlayer:(AliPlayer *)player;




@end

NS_ASSUME_NONNULL_END
