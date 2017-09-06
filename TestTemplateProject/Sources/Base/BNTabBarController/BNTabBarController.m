//
//  BNTabBarController.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/22.
//  Copyright (c) 2017年 Ben. All rights reserved.
//

#import "BNTabBarController.h"

@interface BNTabBarController ()

@end

@implementation BNTabBarController

#pragma mark - 屏幕旋转相关

- (BOOL)shouldAutorotate {
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    
    return [nav.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    
    return [nav.topViewController supportedInterfaceOrientations];
}

@end


