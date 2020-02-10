//
//  AlivcBaseNavigationController+aliyun_autorotate.m
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/5/31.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseNavigationController+aliyun_autorotate.h"

@implementation AlivcBaseNavigationController (aliyun_autorotate)

-(BOOL)shouldAutorotate {
    
    if (self.viewControllers && self.viewControllers.count>0) {
        return [[self.viewControllers lastObject] shouldAutorotate];
    }else {
        return NO;
    }
    
   
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
        
    if (self.viewControllers && self.viewControllers.count>0) {
        UIInterfaceOrientationMask mask =  [[self.viewControllers lastObject] supportedInterfaceOrientations];
        return mask;
    }else {
       return UIInterfaceOrientationMaskPortrait;
    }

//    return UIInterfaceOrientationMaskPortrait;
//
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
