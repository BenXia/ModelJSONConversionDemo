//
//  BNPopoverBaseLayout.h
//  QQingCommon
//
//  Created by Ben on 2017/7/6.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNPopoverCommon.h"

@interface BNPopoverBaseLayout : NSObject

@property (nonatomic, weak) id<BNPopoverLayoutDelegate> popoverDelegate;

// 工厂方法
+ (instancetype)popoverLayoutWithPopoverDelegate:(id <BNPopoverLayoutDelegate>)popoverDelegate;

// 子类需要重写的方法
- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;

@end


