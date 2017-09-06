//
//  BasePopoverVC.h
//  QQingCommon
//
//  Created by Ben on 16/10/12.
//  Copyright © 2016年 QQingiOSTeam. All rights reserved.
//

#import "BaseViewController.h"
#import "BNPopoverCommon.h"

@interface BasePopoverVC : BaseViewController <BNPopoverLayoutDelegate>

//------------------------下面的方法可以选择性重写------------------------
- (PopoverLayoutType)popoverLayoutType;      // 默认为底部 kPopoverLayoutType_Bottom
- (CGSize)preferredContentSize;              // 默认为横屏(屏宽, 200), 竖屏(屏宽, 300)
- (BOOL)backgroundPassThrough;               // YES：背景透明，消息透传  NO：背景有透明度，消息拦截（此时上面的backgroundTapsDisabled才有意义）（默认为NO）
- (BOOL)backgroundTapsDisabled;              // YES：点击背景不关闭浮层  NO：点击背景关闭浮层（默认为NO）

// 下面三个方法只有布局样式为kPopoverLayoutType_Custom时需要实现，默认会按照底部居中的样式显示
- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
//--------------------------------------------------------------------

- (void)showWithAnimated:(BOOL)animated;
- (void)dismissWithAnimated:(BOOL)animated;

@end


