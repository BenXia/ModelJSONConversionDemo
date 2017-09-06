//
//  BaseWindowRootVC.h
//  TestTemplateProject
//
//  Created by Ben on 15/10/30.
//  Copyright © 2015年 QQingiOSTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWindowRootVC : UIViewController

@property (nonatomic, assign) UIStatusBarStyle statusBarStyleToSet;

+ (instancetype)createRootViewControllerWithStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end
