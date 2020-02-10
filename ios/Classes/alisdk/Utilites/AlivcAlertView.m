//
//  AlivcAlertView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/29.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcAlertView.h"
#import "AlivcUIConfig.h"
#import "AlivcAlertView.h"
#import "UIColor+AlivcHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcAlertView()

@property(strong, nonatomic) UIView *contentView;

//title
@property(strong, nonatomic) UIView *titleView;



//message
@property(strong, nonatomic) UIView *messageView;

@property(strong, nonatomic) UIImageView *showImageView;

//buttom
@property(strong, nonatomic) UIView *bottomView;

//size
@property(assign, nonatomic) CGFloat conWidth; //内容视图的宽度
@property(assign, nonatomic) CGFloat conHeight; //内容视图的高度
@property(assign, nonatomic) CGFloat titleConHeight; //标题的高度
@property(assign, nonatomic) CGFloat buttonHeight; //底部按钮的高度

//store property
@property(strong, nonatomic, nullable) NSString *titleString;
@property(strong, nonatomic, nullable) NSString *messageString;
@property(strong, nonatomic, nullable) NSString *cancelString;
@property(strong, nonatomic) NSString *confirmString;
@property(strong, nonatomic, nullable) UIImage *showImage;
@property(assign, nonatomic) AlivcAlertViewStyle uiStyle; //ui风格

@end



@implementation AlivcAlertView

#pragma mark - getter
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
    }
    return _contentView;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIView *)messageView{
    if (!_messageView) {
        _messageView = [[UIView alloc]init];
    }
    return _messageView;
}

- (UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc]init];
    }
    return _showImageView;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 10;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
    }
    return _bottomView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [_cancelButton addTarget:self action:@selector(cancelButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateSelected];
        [_confirmButton addTarget:self action:@selector(confirmButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - System

- (instancetype)initWithAlivcTitle:(NSString *__nullable)title message:(NSString *__nullable)message delegate:(id)delegate cancelButtonTitle:(NSString *__nullable)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle{
    self = [super init];
    if (self) {
        self.titleString = title;
        self.messageString = message;
        self.cancelString = cancelButtonTitle;
        self.confirmString = confirmButtonTitle;
        self.showImage = [UIImage imageNamed:@"avcPromptWarning"];
        self.delegate = delegate;
        
        self.conWidth = 266;
        self.conHeight = 168;
        self.titleConHeight = 36;
        self.buttonHeight = 50;
        if (self.titleString) {
            self.conHeight = self.conHeight + self.titleConHeight;//让ui更好看
        }
        self.uiStyle = AlivcAlertViewStyleDark;
        [self configBaseUI];
        [self addNotification];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //赋值
    switch (self.uiStyle) {
        case AlivcAlertViewStyleDark:{
            self.contentView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
            self.titleLabel.textColor = [UIColor whiteColor];
            self.messageLabel.textColor = [UIColor whiteColor];
            [self deviceView].backgroundColor = [UIColor lightGrayColor];
            [self.cancelButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:[AlivcUIConfig shared].kAVCThemeColor forState:UIControlStateSelected];
        }
            
            break;
        case AlivcAlertViewStyleWhite:{
            self.contentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            self.messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            [self deviceView].backgroundColor = [UIColor colorWithHexString:@"#D7D8D9"];
            [self.cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [self.cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        }
            
        default:
            break;
    }
    
    self.showImageView.image = self.showImage;
    
    //横竖屏适配
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    CGFloat offsety = 0;
    if (ScreenWidth < ScreenHeight) {
        offsety = ScreenHeight / 10;
    }
    self.contentView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2 - offsety);
    
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [self  layoutSubviews];
}



#pragma mark - Public Method
- (void)setShowImage:(UIImage *__nullable)image{
    _showImage = image;
    [self.showImageView setImage:image];
}

- (void)show{
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    if (win) {
        [win addSubview:self];
    }
}

- (void)setContentSize:(CGSize)size{
    self.conWidth = size.width;
    self.conHeight = size.height;
    [self configBaseUI];
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
}

- (void)setStyle:(AlivcAlertViewStyle)style{
    _uiStyle = style;
}
#pragma mark - Private Method

- (void)configBaseUI{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, self.conWidth, self.conHeight);
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = true;
    
    CGFloat messageOY = 0;
    
    //title
    if (self.titleString) {
        
        [self.contentView addSubview:self.titleView];
        self.titleView.frame = CGRectMake(0, 0, self.conWidth, self.titleConHeight);
        messageOY = self.titleView.frame.size.height;
        
        [self.titleView addSubview:self.titleLabel];
        self.titleLabel.text = self.titleString;
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.conWidth / 2, self.titleConHeight / 2);
        
//        UIView *deviceView = [self deviceView];
//        deviceView.alpha = 0.5;
//        deviceView.frame = CGRectMake(16, self.titleView.frame.size.height - 1, self.conWidth - 32, 1);
//        [self.titleView addSubview:deviceView];
    }
    
    //message
    [self.contentView addSubview:self.messageView];
    if (self.titleString) {
        self.messageView.frame = CGRectMake(0, messageOY, self.conWidth, self.conHeight - self.titleConHeight - self.buttonHeight);
    }else{
        self.messageView.frame = CGRectMake(0, messageOY, self.conWidth, self.conHeight - self.buttonHeight);
    }
    
    [self.messageView addSubview:self.showImageView];
    self.showImageView.image = self.showImage;
    [self.showImageView sizeToFit];
    self.showImageView.center = CGPointMake(self.conWidth / 2, 12 + self.showImageView.frame.size.height / 2);
    if (self.messageString) {
        [self.messageView addSubview:self.messageLabel];
        self.messageLabel.text = self.messageString;
        
        CGFloat mLabely = 8 + self.showImageView.frame.size.height + 8;
        self.messageLabel.frame = CGRectMake(8, mLabely, self.conWidth - 8 * 2, self.messageView.frame.size.height - 8 - mLabely);
    }
    
    //bottom
    [self.contentView  addSubview:self.bottomView];
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.messageView.frame), self.conWidth, self.buttonHeight);
    [self.bottomView addSubview:[self deviceView]];
    if (self.cancelString) {
        [self.bottomView addSubview:self.cancelButton];
        self.cancelButton.frame = CGRectMake(0, 0, self.conWidth / 2, self.bottomView.frame.size.height);
        [self.cancelButton setTitle:self.cancelString forState:UIControlStateNormal];
        
        
//        UIView *deviceMidView = [[UIView alloc]initWithFrame:CGRectMake(self.conWidth / 2, 0, 1, self.bottomView.frame.size.height)];
//        deviceMidView.backgroundColor = [UIColor lightGrayColor];
//        deviceMidView.alpha = 0.6;
//        [self.bottomView addSubview:deviceMidView];
        
        [self.bottomView addSubview:self.confirmButton];
        self.confirmButton.frame = CGRectMake(self.conWidth / 2, 0, self.conWidth / 2, self.bottomView.frame.size.height);
    }else{
        [self.bottomView addSubview:self.confirmButton];
        self.confirmButton.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    }
    
    [self.confirmButton setTitle:self.confirmString forState:UIControlStateNormal];
    
}


- (void)addNotification{
    /**
     *  开始生成 设备旋转 通知
     */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
}

- (void)releaseNotification{
    /**
     *  销毁 设备旋转 通知
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil
     ];
    
    
    /**
     *  结束 设备旋转通知
     *
     *  @return return value description
     */
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (UIView *)deviceView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.conWidth, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

#pragma mark - Responce
- (void)cancelButtonTouched{
    
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:0];
    }
    [self removeFromSuperview];
    [self releaseNotification];
}

- (void)confirmButtonTouched{
    
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        NSInteger index = 1;
        if (!self.cancelString) {
            index = 0;
        }
        [self.delegate alertView:self clickedButtonAtIndex:index];
    }
    [self removeFromSuperview];
    [self releaseNotification];
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    
    
    
    
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
            [self layoutSubviews];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            [self layoutSubviews];
            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            [self layoutSubviews];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            break;
            
        default:
            NSLog(@"无法辨识");
            break;
    }
    
}

@end

NS_ASSUME_NONNULL_END
