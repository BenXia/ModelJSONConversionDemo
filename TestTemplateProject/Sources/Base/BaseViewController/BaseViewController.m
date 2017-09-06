//
//  BaseViewController.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/22.
//  Copyright (c) 2017年 Ben. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = RGB(240, 240, 240);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //解决手势返回失效的问题
    if (self.navigationController.viewControllers.count > 1) {
        if ([self preferPopGestureRecognizerForbidden]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (BOOL)preferPopGestureRecognizerForbidden {
    return NO;
}

- (void)dealloc {
    NSLog (@"====DEALLOC==== %@ ", NSStringFromClass([self class]));
}

@end


