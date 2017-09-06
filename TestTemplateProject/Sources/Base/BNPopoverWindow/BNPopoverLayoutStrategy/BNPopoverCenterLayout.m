//
//  BNPopoverCenterLayout.m
//  QQingCommon
//
//  Created by Ben on 2017/7/6.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import "BNPopoverCenterLayout.h"

@implementation BNPopoverCenterLayout

- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    CGSize contentSize = [self.popoverDelegate preferredContentSize];
    
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootVCView.mas_centerX);
        make.centerY.equalTo(rootVCView.mas_centerY);
        make.size.mas_equalTo(contentSize);
    }];
}

- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    CGSize contentSize = [self.popoverDelegate preferredContentSize];
    
    contentView.transform = CGAffineTransformIdentity;
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootVCView.mas_centerX);
        make.centerY.equalTo(rootVCView.mas_centerY);
        make.size.mas_equalTo(contentSize);
    }];
}

- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    CGSize contentSize = [self.popoverDelegate preferredContentSize];
    
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootVCView.mas_centerX);
        make.centerY.equalTo(rootVCView.mas_centerY);
        make.size.mas_equalTo(contentSize);
    }];
}

@end


