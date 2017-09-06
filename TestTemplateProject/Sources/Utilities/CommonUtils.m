//
//  CommonUtils.m
//  TestTemplateProject
//
//  Created by Ben on 2017/6/20.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "CommonUtils.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

void BN_swapMethodsFromClass(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@interface CommonUtils ()

@property (nonatomic, strong) MBProgressHUD *progressHUDForToast;

@end

@implementation CommonUtils

BN_IMP_SINGLETON( CommonUtils )

// Toast
+ (void)showToastWithText:(NSString *)text {
    [CommonUtils showToastWithText:text withImageName:nil blockUI:YES];
}

+ (void)showToastInWindow:(UIWindow*)window withText:(NSString *)text{
    [self showToastInWindow:window withText:text withImageName:nil blockUI:YES];
}

+ (void)showToastWithText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI{
    [self showToastInWindow:[UIApplication sharedApplication].keyWindow withText:text withImageName:imageName blockUI:needBlockUI];
}

+ (void)showToastInWindow:(UIWindow*)window withText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 方案一：使用MBProgressHUD
        [[CommonUtils sharedCommonUtils].progressHUDForToast hide:NO];
        if (window) {
            [CommonUtils sharedCommonUtils].progressHUDForToast = [[MBProgressHUD alloc] initWithWindow:window];
            
            // Full screen show.
            [window addSubview:[CommonUtils sharedCommonUtils].progressHUDForToast];
            [[CommonUtils sharedCommonUtils].progressHUDForToast bringToFront];
            
            [CommonUtils sharedCommonUtils].progressHUDForToast.labelText = text;
            if (([imageName length] > 0) && [UIImage imageNamed:imageName]) {
                [CommonUtils sharedCommonUtils].progressHUDForToast.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [CommonUtils sharedCommonUtils].progressHUDForToast.mode = MBProgressHUDModeCustomView;
            } else {
                [CommonUtils sharedCommonUtils].progressHUDForToast.mode = text.length > 0 ? MBProgressHUDModeText : MBProgressHUDModeIndeterminate;
                [CommonUtils sharedCommonUtils].progressHUDForToast.square = !(text.length > 0);
            }
            
            [CommonUtils sharedCommonUtils].progressHUDForToast.removeFromSuperViewOnHide = YES;
            [CommonUtils sharedCommonUtils].progressHUDForToast.dimBackground = needBlockUI;
            [CommonUtils sharedCommonUtils].progressHUDForToast.userInteractionEnabled = needBlockUI;
            
            [[CommonUtils sharedCommonUtils].progressHUDForToast show:YES];
            
            [[CommonUtils sharedCommonUtils].progressHUDForToast hide:YES afterDelay:1.5];
        }
        
        // 方案二：使用TSMessage
        //        [TSMessage setDefaultViewController:[[UIApplication sharedApplication].delegate.window rootViewController]];
        //
        //        [TSMessage showNotificationWithTitle:text//NSLocalizedString(@"Tell the user something", nil)
        //                                    subtitle:nil//NSLocalizedString(@"This is some neutral notification!", nil)
        //                                        type:TSMessageNotificationTypeMessage];
    });
}

// Screenshot
+ (UIImage *)screenshotForView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    imageData = nil;
    
    return image;
}

@end
