//
//  ALivcShortVideoQuHomeTabBarController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/8.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoQuHomeTabBarController.h"
#import "AlivcShortVideoPersonalViewController.h"
//#import "AlivcShortVideoPlayViewControler.h"
#import "AlivcShortVideoPlayViewController.h"
#import "AlivcShortVideoTabBar.h"
#import "AlivcDefine.h"

@interface AlivcShortVideoQuHomeTabBarController ()

@property (strong, nonatomic) AlivcShortVideoTabBar *customBar;

@end

@implementation AlivcShortVideoQuHomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 利用KVO来使用自定义的tabBar
    self.customBar = [[AlivcShortVideoTabBar alloc]init];
    [self setValue:[[AlivcShortVideoTabBar alloc] init] forKey:@"tabBar"];
    [self addChildVC];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(centerButtonSelectedToNo) name:AlivcNotificationVideoStartPublish object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)addChildVC {
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor whiteColor];

    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.shadowImage = [[UIImage alloc] init];

    AlivcShortVideoPlayViewController *playVC =
        [[AlivcShortVideoPlayViewController alloc] init];
    playVC.tabBarItem.image = [[AlivcImage imageNamed:@"alivc_svHome_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    playVC.tabBarItem.selectedImage = [[AlivcImage imageNamed:@"alivc_svHome_icon_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:playVC];

    AlivcShortVideoPersonalViewController *personalVC =
        [[AlivcShortVideoPersonalViewController alloc] init];
    personalVC.tabBarItem.image = [[AlivcImage imageNamed:@"alivc_svHome_me"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalVC.tabBarItem.selectedImage = [[AlivcImage imageNamed:@"alivc_svHome_me_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:personalVC];
}

- (void)centerButtonSelectedToNo{
    self.customBar.centerBtn.selected = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationQuPlay_QutiMask object:nil];
    });
    
}

#pragma mark -
- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationQuPlay_QutiMask object:nil];
}



@end
