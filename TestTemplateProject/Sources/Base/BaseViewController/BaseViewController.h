//
//  BaseViewController.h
//  TestTemplateProject
//
//  Created by Ben on 2017/5/22.
//  Copyright (c) 2017年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

@interface BaseViewController : UIViewController

// 是否禁止右滑手势返回,默认为NO
- (BOOL)preferPopGestureRecognizerForbidden;

@end


