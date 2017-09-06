//
//  BNPopoverCustomLayout.m
//  QQingCommon
//
//  Created by Ben on 2017/7/6.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import "BNPopoverCustomLayout.h"

@implementation BNPopoverCustomLayout

- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    if (self.popoverDelegate && [self.popoverDelegate respondsToSelector:@selector(preShowLayoutForContentView:rootVCView:)]) {
        [self.popoverDelegate preShowLayoutForContentView:contentView rootVCView:rootVCView];
    } else {
        CGFloat heightToSet = [self.popoverDelegate preferredContentSize].height;
        
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rootVCView.mas_centerX);
            make.top.equalTo(rootVCView.mas_bottom);
            make.width.equalTo(rootVCView.mas_width);
            make.height.mas_equalTo(heightToSet);
        }];
    }
}

- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    if (self.popoverDelegate && [self.popoverDelegate respondsToSelector:@selector(normalLayoutForContentView:rootVCView:)]) {
        [self.popoverDelegate normalLayoutForContentView:contentView rootVCView:rootVCView];
    } else {
        CGFloat heightToSet = [self.popoverDelegate preferredContentSize].height;
        
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rootVCView.mas_centerX);
            make.bottom.equalTo(rootVCView.mas_bottom);
            make.width.equalTo(rootVCView.mas_width);
            make.height.mas_equalTo(heightToSet);
        }];
    }
}

- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    if (self.popoverDelegate && [self.popoverDelegate respondsToSelector:@selector(postDismissLayoutForContentView:rootVCView:)]) {
        [self.popoverDelegate postDismissLayoutForContentView:contentView rootVCView:rootVCView];
    } else {
        CGFloat heightToSet = [self.popoverDelegate preferredContentSize].height;
        
        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rootVCView.mas_centerX);
            make.top.equalTo(rootVCView.mas_bottom);
            make.width.equalTo(rootVCView.mas_width);
            make.height.mas_equalTo(heightToSet);
        }];
    }
}

@end


