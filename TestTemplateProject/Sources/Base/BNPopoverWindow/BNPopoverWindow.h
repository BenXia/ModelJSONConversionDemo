//
//  BNPopoverWindow.h
//  QQingCommon
//
//  Created by Ben on 2017/7/4.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNPopoverCommon.h"
#import "BNPopoverWindowRootVC.h"

@interface BNPopoverWindow : UIWindow

+ (instancetype)popoverWindowWithContentVC:(UIViewController *)contentVC popoverDelegate:(id <BNPopoverLayoutDelegate>)delegate;
+ (instancetype)popoverWindowWithContentView:(UIView *)contentView popoverDelegate:(id <BNPopoverLayoutDelegate>)delegate;

+ (void)dismissAllPopoverWindow;

- (void)showWithAnimated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end


