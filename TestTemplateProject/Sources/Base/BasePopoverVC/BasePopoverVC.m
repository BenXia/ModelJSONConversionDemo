//
//  BasePopoverVC.m
//  QQingCommon
//
//  Created by Ben on 16/10/12.
//  Copyright © 2016年 QQingiOSTeam. All rights reserved.
//

#import "BasePopoverVC.h"
#import "BNPopoverWindow.h"

@interface BasePopoverVC ()

@property (nonatomic, weak) BNPopoverWindow *popWindow;

@end

@implementation BasePopoverVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BNPopoverLayoutDelegate

- (PopoverLayoutType)popoverLayoutType {
    return kPopoverLayoutType_Bottom;
}

- (CGSize)preferredContentSize {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? CGSizeMake([[UIScreen mainScreen] bounds].size.height, 200) : CGSizeMake([[UIScreen mainScreen] bounds].size.width, 300);
}

- (BOOL)backgroundPassThrough {
    return NO;
}

- (BOOL)backgroundTapsDisabled {
    return NO;
}

- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    CGFloat heightToSet = [self preferredContentSize].height;
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootVCView.mas_centerX);
        make.top.equalTo(rootVCView.mas_bottom);
        make.width.equalTo(rootVCView.mas_width);
        make.height.mas_equalTo(heightToSet);
    }];
}

- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    CGFloat heightToSet = [self preferredContentSize].height;
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootVCView.mas_centerX);
        make.bottom.equalTo(rootVCView.mas_bottom);
        make.width.equalTo(rootVCView.mas_width);
        make.height.mas_equalTo(heightToSet);
    }];
}

- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    CGFloat heightToSet = [self preferredContentSize].height;
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootVCView.mas_centerX);
        make.top.equalTo(rootVCView.mas_bottom);
        make.width.equalTo(rootVCView.mas_width);
        make.height.mas_equalTo(heightToSet);
    }];
}

#pragma mark - Public methods

- (void)showWithAnimated:(BOOL)animated {
    if (!self.popWindow) {
        self.popWindow = [BNPopoverWindow popoverWindowWithContentVC:self popoverDelegate:self];
    }
    
    [self.popWindow showWithAnimated:animated];
}

- (void)dismissWithAnimated:(BOOL)animated {
    if (!self.popWindow) {
        return;
    }
    
    [self.popWindow dismissWithAnimated:animated];
}

@end


