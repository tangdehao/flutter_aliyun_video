//
//  AlivcQuHeaderReusableView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliVideoClientUser;

@class AlivcQuHeaderReusableView;

@protocol AlivcQuHeaderReusableViewDelegate <NSObject>

- (void)nickButtonTouched;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AlivcQuHeaderReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIView *myVideoView;
@property (weak, nonatomic) IBOutlet UIView *myVideoBgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;

@property (weak, nonatomic) IBOutlet UILabel *myVideoCountLabel;

@property (weak, nonatomic) id <AlivcQuHeaderReusableViewDelegate>customDelegate;
/**
 重新调整下视图
 */
- (void)fixSize;

@end

NS_ASSUME_NONNULL_END
