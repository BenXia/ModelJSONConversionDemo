//
//  BNPopoverCommon.h
//  QQingCommon
//
//  Created by Ben on 2017/7/4.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#ifndef BNPopoverCommon_h
#define BNPopoverCommon_h


typedef NS_ENUM(NSUInteger, PopoverLayoutType){
    kPopoverLayoutType_Bottom = 0,   // 底部居中，默认
    kPopoverLayoutType_Center = 1,   // 中心居中
    kPopoverLayoutType_Custom = 2,   // 自定义，需要重写布局、打开/关闭动画相关方法
};

@protocol BNPopoverLayoutDelegate <NSObject>

@required
- (PopoverLayoutType)popoverLayoutType;      // 布局样式
- (CGSize)preferredContentSize;              // 浮层大小
- (BOOL)backgroundPassThrough;               // YES：背景透明，消息透传  NO：背景有透明度，消息拦截（此时上面的backgroundTapsDisabled才有意义）（默认为NO）
- (BOOL)backgroundTapsDisabled;              // YES：点击背景不关闭浮层  NO：点击背景关闭浮层（默认为NO）

@optional
// 下面三个方法只有布局样式为kPopoverLayoutType_Custom时需要实现，默认会按照底部居中的样式显示
- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;
- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView;

@end

#endif /* BNPopoverCommon_h */
