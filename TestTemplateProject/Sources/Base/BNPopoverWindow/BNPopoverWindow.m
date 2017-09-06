//
//  BNPopoverWindow.m
//  QQingCommon
//
//  Created by Ben on 2017/7/4.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import "BNPopoverWindow.h"
#import "BNPopoverBaseLayout.h"

NSMutableArray <BNPopoverWindow *> *g_popoverWindowArray;

@interface BNPopoverWindow ()

@property (nonatomic, strong) UIViewController *contentVC;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) BNPopoverWindowRootVC *windowRootVC;

@property (nonatomic, strong) UIWindow *originalKeyWindow;

@property (nonatomic, weak)   id<BNPopoverLayoutDelegate> popoverDelegate;
@property (nonatomic, strong) BNPopoverBaseLayout *popoverLayoutManager;

@property (nonatomic, assign) BOOL inShowAnimation;
@property (nonatomic, assign) BOOL inDismissedAnimation;

@end

@implementation BNPopoverWindow

+ (void)load {
    if (!g_popoverWindowArray) {
        g_popoverWindowArray = [NSMutableArray array];
    }
}

+ (instancetype)popoverWindowWithContentVC:(UIViewController *)contentVC popoverDelegate:(id <BNPopoverLayoutDelegate>)popoverDelegate {
    // If we start in landscape mode also update the windows frame to be accurate
    CGRect windowFrameToSet = [UIScreen mainScreen].bounds;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        windowFrameToSet = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    
    BNPopoverWindow *window = [[BNPopoverWindow alloc] initWithFrame:windowFrameToSet];
    if (window) {
        window.popoverDelegate = popoverDelegate;
        window.popoverLayoutManager = [BNPopoverBaseLayout popoverLayoutWithPopoverDelegate:popoverDelegate];
        [window setupForContentVC:contentVC];
    }
    return window;
}

+ (instancetype)popoverWindowWithContentView:(UIView *)contentView popoverDelegate:(id <BNPopoverLayoutDelegate>)popoverDelegate {
    CGRect windowFrameToSet = [UIScreen mainScreen].bounds;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        windowFrameToSet = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    
    BNPopoverWindow *window = [[BNPopoverWindow alloc] initWithFrame:windowFrameToSet];
    if (window) {
        window.popoverDelegate = popoverDelegate;
        window.popoverLayoutManager = [BNPopoverBaseLayout popoverLayoutWithPopoverDelegate:popoverDelegate];
        [window setupForContentView:contentView];
    }
    return window;
}

- (void)setupForContentVC:(UIViewController *)contentVC {
    self.contentVC = contentVC;
    
    [self setupForContentView:contentVC.view];
}

- (void)setupForContentView:(UIView *)contentView {
    self.backgroundColor = [UIColor clearColor];
    self.windowLevel = UIWindowLevelStatusBar;
    
    BNPopoverWindowRootVC *vc = [BNPopoverWindowRootVC createRootViewControllerWithStatusBarStyle:[UIApplication sharedApplication].statusBarStyle];
    vc.backgroundPassThrough = [self.popoverDelegate backgroundPassThrough];
    vc.contentView = contentView;
    @weakify(self);
    vc.didClickBackgroundControlBlock = ^{
        @strongify(self);
        if (![self.popoverDelegate backgroundTapsDisabled]) {
            [self dismissWithAnimated:YES];
        }
    };
    self.contentView = contentView;
    self.windowRootVC = vc;
    self.rootViewController = vc;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.popoverDelegate backgroundPassThrough]) {
        UIView *view = nil;
        
        if (self.contentView.superview) {
            CGRect rect = self.contentView.frame;
            
            if (CGRectContainsPoint(rect, point)) {
                return [super hitTest:point withEvent:event];
            }
        }
        
        return view;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - Utility methods

+ (void)addPopoverWindow:(BNPopoverWindow *)popoverWindow {
    @synchronized (g_popoverWindowArray) {
        [g_popoverWindowArray addObject:popoverWindow];
    }
}

+ (void)removePopoverWindow:(BNPopoverWindow *)popoverWindow {
    @synchronized (g_popoverWindowArray) {
        [g_popoverWindowArray removeObject:popoverWindow];
    }
}

#pragma mark - Public methods

+ (void)dismissAllPopoverWindow {
    @synchronized (g_popoverWindowArray) {
        if (g_popoverWindowArray.count > 0) {
            for (int i = (int)(g_popoverWindowArray.count - 1); i >= 0; i--) {
                BNPopoverWindow *popoverWindow = [g_popoverWindowArray objectAtIndex:i];
                
                [popoverWindow dismissWithAnimated:NO];
            }
        }
    }
}

- (void)showWithAnimated:(BOOL)animated {
    if (self.inShowAnimation) {
        return;
    }
    self.inShowAnimation = YES;
    
    self.originalKeyWindow = [UIApplication sharedApplication].keyWindow;
    [self makeKeyAndVisible];
    
    if (self.contentVC) {
        [self.contentVC willMoveToParentViewController:self.windowRootVC];
        [self.contentVC viewWillAppear:YES];
        
        [self.windowRootVC addChildViewController:self.contentVC];
        [self.windowRootVC.view addSubview:self.contentView];
        
        [self.contentVC viewDidAppear:YES];
        [self.contentVC didMoveToParentViewController:self.windowRootVC];
    } else if (self.contentView) {
        [self.windowRootVC.view addSubview:self.contentView];
    }
    
    [self.popoverLayoutManager preShowLayoutForContentView:self.contentView rootVCView:self.windowRootVC.view];
    
    [self.windowRootVC.view setNeedsUpdateConstraints];
    [self.windowRootVC.view layoutIfNeeded];
    
    if (animated) {
        self.contentView.alpha = 0;
        
        //[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.windowRootVC.backgroundControl.alpha = 1;
            self.contentView.alpha = 1;
            
            [self.popoverLayoutManager normalLayoutForContentView:self.contentView rootVCView:self.windowRootVC.view];
            [self.windowRootVC.view setNeedsUpdateConstraints];
            [self.windowRootVC.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [BNPopoverWindow addPopoverWindow:self];
            self.inShowAnimation = NO;
        }];
    } else {
        self.windowRootVC.backgroundControl.alpha = 1;
        self.contentView.alpha = 1;
        
        [self.popoverLayoutManager normalLayoutForContentView:self.contentView rootVCView:self.windowRootVC.view];
        [self.windowRootVC.view setNeedsUpdateConstraints];
        [self.windowRootVC.view layoutIfNeeded];
        
        [BNPopoverWindow addPopoverWindow:self];
        self.inShowAnimation = NO;
    }
}

- (void)dismissWithAnimated:(BOOL)animated {
    if (self.inDismissedAnimation) {
        return;
    }
    self.inDismissedAnimation = YES;
    
    void (^finishBlock)(void) = ^{
        if (self.contentVC) {
            [self.contentVC willMoveToParentViewController:nil];
            [self.contentVC viewWillDisappear:YES];
            
            [self.contentView removeFromSuperview];
            [self.contentVC removeFromParentViewController];
            
            [self.contentVC didMoveToParentViewController:nil];
            [self.contentVC viewDidDisappear:YES];
            
            self.contentVC = nil;
        } else if (self.contentView) {
            [self.contentView removeFromSuperview];
        }
        
        __strong typeof(self) strongSelf = self;
        
        [self.windowRootVC.backgroundControl removeFromSuperview];
        [self resignKeyWindow];
        [strongSelf.originalKeyWindow makeKeyAndVisible];
        [BNPopoverWindow removePopoverWindow:strongSelf];
        strongSelf.inDismissedAnimation = NO;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.windowRootVC.backgroundControl.alpha = 0;
            self.contentView.alpha = 0;
            
            [self.popoverLayoutManager postDismissLayoutForContentView:self.contentView rootVCView:self.windowRootVC.view];
            [self.windowRootVC.view setNeedsUpdateConstraints];
            [self.windowRootVC.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            finishBlock();
        }];
    } else {
        finishBlock();
    }
}

@end


