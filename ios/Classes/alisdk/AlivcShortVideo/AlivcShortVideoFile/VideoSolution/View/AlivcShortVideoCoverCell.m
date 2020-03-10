#import "AlivcShortVideoCoverCell.h"
#import "UIImageView+WebCache.h"
#import <AliyunPlayer/AliyunPlayer.h>

#define iconWH 30

@interface AlivcShortVideoCoverCell ()

/**
 视频类型图
 */
@property (nonatomic, strong) UIImage *type_image;


/**
 展示视频类型UIImageView
 */
@property (nonatomic, strong) UIImageView *typeImageView;

/**
 用户头像
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 昵称
 */
@property (nonatomic, strong) UILabel *nickNameLabel;

/**
 描述label
 */
@property (nonatomic, strong) UILabel *desLabel;

/**
 描述label
 */
@property (nonatomic, strong) UIImageView *zaidaiImageView;

@end

@implementation AlivcShortVideoCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
    
}

- (UIViewController *)getSuperController{
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)initUI {
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = ScreenWidth;
    CGFloat imageH = ScreenHeight - KquTabBarHeight;
   
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView addSubview:self.typeImageView];
    [self.imageView addSubview:self.zaidaiImageView];
    [self.imageView addSubview:self.avatarImageView];
    [self.imageView addSubview:self.desLabel];
    [self.imageView addSubview:self.nickNameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.typeImageView.center = CGPointMake(ScreenWidth - iconWH/2 - 16, iconWH/2 + 8 + SafeTop);
}

#pragma mark - public method

- (void)addPlayer:(AliPlayer *)player {
    UIView *playView = player.playerView;
    
    UIViewController *controller = [self getSuperController];
    if ([NSStringFromClass([controller class])isEqualToString:@"AlivcShortVideoLivePlayViewController"]) {
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        CGFloat imageW = ScreenWidth;
        CGFloat imageH = ScreenHeight;
        self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
    }
    playView.frame = self.imageView.bounds;
    [self.imageView addSubview:playView];
    [self.imageView sendSubviewToBack:playView];
}


#pragma mark - setter & getter

- (void)setModel:(AlivcShortVideoBasicVideoModel *)model {
    if (!model) {
        return;
    }
    //默认遮盖图为首帧图
    BOOL isLive = NO;
    NSString *imageUrlString = model.firstFrameUrl;
    //直播场景下遮盖图为封面图
    if ([model isKindOfClass:[AlivcShortVideoLiveVideoModel class]]) {
        isLive = YES;
        imageUrlString = model.coverUrl;
    }
    //设置图片
    __weak typeof(self) weakSelf = self;
    if (imageUrlString && imageUrlString.length >0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if(image.size.width < image.size.height&&IPHONEX) {
                weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }else {
                weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
            //赋值给model
            if (isLive) {
                model.coverImage = image;
            }else{
                model.firstFrameImage = image;
            }
            
        }];
    }

    CGFloat beside = 12;
    CGFloat cyFirst = ScreenHeight - 120 - SafeAreaBottom;
    self.avatarImageView.center = CGPointMake(beside + self.avatarImageView.frame.size.width / 2 ,cyFirst);
    //头像
    if (model.belongUserAvatarImage) {
        self.avatarImageView.hidden = NO;
        self.avatarImageView.image = model.belongUserAvatarImage;
    }else if (model.belongUserAvatarUrl){
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.belongUserAvatarUrl]];
    }else{
        self.avatarImageView.hidden = YES;
    }
    //昵称
    if (model.belongUserName) {
        self.nickNameLabel.hidden = NO;
        self.nickNameLabel.text = model.belongUserName;
        [self.nickNameLabel sizeToFit];
        self.nickNameLabel.center = CGPointMake(CGRectGetMaxX(self.avatarImageView.frame) + beside + self.nickNameLabel.frame.size.width / 2, self.avatarImageView.center.y);
    }else{
        self.nickNameLabel.hidden = YES;
    }
    
    //描述
    if (model.videoDescription) {
        self.desLabel.hidden = NO;
        self.desLabel.text = model.videoDescription;
        [self.desLabel sizeToFit];
        self.desLabel.center = CGPointMake(beside + self.desLabel.frame.size.width / 2, CGRectGetMaxY(self.avatarImageView.frame) + beside + self.desLabel.frame.size.height / 2);
    }else{
        self.desLabel.hidden = YES;
    }
    self.zaidaiImageView.hidden = YES;
    
    if ([model isKindOfClass:[AlivcQuVideoModel class]]) {
        AlivcQuVideoModel *quModel = (AlivcQuVideoModel *)model;
        if (quModel.narrowTranscodeStatusString && quModel.narrowTranscodeStatusString.length >0) {
             self.zaidaiImageView.hidden = NO;
        }
  
       
    }
    
    if ([model isKindOfClass:[AlivcShortVideoLiveVideoModel class]]) {

        self.typeImageView.image= [UIImage imageNamed:@"alivc_icon_play_liveOnline"];
            return;
    }
    
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.frame = CGRectMake(0, 0, 36, 36);
        _avatarImageView.layer.cornerRadius = 4;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _avatarImageView;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.frame = CGRectMake(0, 0, 100, 30);
    }
    return _nickNameLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.frame = CGRectMake(0, 0, 150, 30);
        _desLabel.font = [UIFont systemFontOfSize:12];
    }
    return _desLabel;
}

- (UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iconWH, iconWH)];
        _typeImageView.backgroundColor = [UIColor clearColor];
        _typeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _typeImageView;
}

- (UIImageView *)zaidaiImageView {
    
    if (!_zaidaiImageView) {
        _zaidaiImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alivc_little_icon_narrowband"]];
        [_zaidaiImageView sizeToFit];
        _zaidaiImageView.center = CGPointMake(15 + _zaidaiImageView.frame.size.width / 2, SafeTop + 22);
       
    }
    return _zaidaiImageView;
}



@end
