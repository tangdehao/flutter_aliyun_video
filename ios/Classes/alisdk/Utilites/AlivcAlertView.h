//
//  AlivcAlertView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/6/29.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AlivcAlertViewStyle){
    AlivcAlertViewStyleDark = 0,
    AlivcAlertViewStyleWhite,
};

@interface AlivcAlertView : UIAlertView

/**
 自定义的弹窗显示 有2种风格可以设置，也可以自定义颜色组合

 @param title 标题
 @param message 信息
 @param delegate 代理 - 继承了UIAlertView的代理
 @param cancelButtonTitle 取消标题
 @param confirmButtonTitle 确定的标题
 @return 一个实例化的对象
 */
- (instancetype)initWithAlivcTitle:(NSString *__nullable)title message:(NSString *__nullable)message delegate:(id)delegate cancelButtonTitle:(NSString *__nullable)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;

/**
 设置显示图片

 @param image 要显示在信息之上的图片
 */
- (void)setShowImage:(UIImage *__nullable)image;

/**
 设置d自定义尺寸

 @param size 自定义尺寸
 */
- (void)setContentSize:(CGSize)size;

/**
 展示自己 - 可以通过另外的继承的show方法也可以实现

 @param view 用于展示的容器视图
 */
- (void)showInView:(UIView *)view;

/**
 设置风格 - 默认为黑暗风

 @param style UI风格
 */
- (void)setStyle:(AlivcAlertViewStyle)style;


/**
 标题label
 */
@property(strong, nonatomic) UILabel *titleLabel;

/**
 信息label
 */
@property(strong, nonatomic) UILabel *messageLabel;

/**
 确定按钮
 */
@property(strong, nonatomic) UIButton *confirmButton;

/**
 取消按钮
 */
@property(strong, nonatomic) UIButton *cancelButton;

@end
NS_ASSUME_NONNULL_END
