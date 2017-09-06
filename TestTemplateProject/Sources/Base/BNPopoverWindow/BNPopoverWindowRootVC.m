//
//  BNPopoverWindowRootVC.m
//  QQingCommon
//
//  Created by Ben on 2017/7/6.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import "BNPopoverWindowRootVC.h"

@interface BNPopoverWindowRootVC ()

@property (nonatomic, strong) UIMotionEffectGroup *motionEffectGroup;

@end

@implementation BNPopoverWindowRootVC

#pragma mark - View life cycle

+ (instancetype)createRootViewControllerWithStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    BNPopoverWindowRootVC *rootVC = [[BNPopoverWindowRootVC alloc] init];
    rootVC.statusBarStyleToSet = statusBarStyle;
    return rootVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self configContentView];
    
    [self addBackgroundControl];
}

- (void)setBackgroundPassThrough:(BOOL)backgroundPassThrough {
    _backgroundPassThrough = backgroundPassThrough;
    
    self.backgroundControl.backgroundColor = backgroundPassThrough ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

#pragma mark - Private methods

- (void)configContentView {
    if (self.contentView) {
        [self.contentView addMotionEffect:self.motionEffectGroup];
    }
}

- (void)addBackgroundControl {
    self.backgroundControl.alpha = 0;
    [self.view addSubview:self.backgroundControl];
    
    [self.backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - IBActions

- (void)didClickBackgroundControl:(id)sender {
    if (self.didClickBackgroundControlBlock) {
        self.didClickBackgroundControlBlock();
    }
}

#pragma mark - Properties

- (UIControl *)backgroundControl {
    if (!_backgroundControl) {
        _backgroundControl = [[UIControl alloc] initWithFrame:CGRectZero];
        _backgroundControl.backgroundColor = self.backgroundPassThrough ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        [_backgroundControl addTarget:self action:@selector(didClickBackgroundControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backgroundControl;
}

- (UIMotionEffectGroup *)motionEffectGroup {
    if(!_motionEffectGroup) {
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        _motionEffectGroup = [UIMotionEffectGroup new];
        _motionEffectGroup.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    }
    
    return _motionEffectGroup;
}

@end


