//
//  CommonUtils.h
//  TestTemplateProject
//
//  Created by Ben on 2017/6/20.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

void BN_swapMethodsFromClass(Class c, SEL orig, SEL new);

@interface CommonUtils : NSObject

BN_DEC_SINGLETON( CommonUtils )

// Toast
+ (void)showToastWithText:(NSString *)text;
+ (void)showToastInWindow:(UIWindow*)window withText:(NSString *)text;
+ (void)showToastWithText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI;
+ (void)showToastInWindow:(UIWindow*)window withText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI;

// Screenshot
+ (UIImage *)screenshotForView:(UIView *)view;

@end


