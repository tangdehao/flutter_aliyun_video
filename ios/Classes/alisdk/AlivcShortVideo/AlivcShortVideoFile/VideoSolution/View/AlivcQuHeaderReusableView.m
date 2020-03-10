//
//  AlivcQuHeaderReusableView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcQuHeaderReusableView.h"
#import "AliVideoClientUser.h"

@interface AlivcQuHeaderReusableView ()
@property (weak, nonatomic) IBOutlet UIView *smallMyVideo;
@property (weak, nonatomic) IBOutlet UILabel *myVideoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myVideoImageView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;

@end

@implementation AlivcQuHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatarImageView.layer.cornerRadius = CGRectGetWidth(_avatarImageView.frame) / 2;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_nickNameButton addTarget:self action:@selector(nickButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [_userButton addTarget:self action:@selector(nickButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    _myVideoLabel.text = NSLocalizedString(@"我的视频" , nil);
}

- (void)fixSize{
    CGRect frame = self.userInfoView.frame;
    CGRect myVideoFrame = CGRectMake(0, frame.size.height, frame.size.width, self.frame.size.height - frame.size.height);
    self.myVideoView.frame = myVideoFrame;
    self.myVideoBgView.frame = self.myVideoView.bounds;
    self.smallMyVideo.center = CGPointMake(frame.size.width / 2, myVideoFrame.size.height / 2);
}

- (void)nickButtonTouched{
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(nickButtonTouched)]) {
        [self.customDelegate nickButtonTouched];
    }
}

@end
