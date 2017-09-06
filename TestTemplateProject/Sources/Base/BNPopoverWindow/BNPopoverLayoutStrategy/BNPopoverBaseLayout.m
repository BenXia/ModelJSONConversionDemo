//
//  BNPopoverBaseLayout.m
//  QQingCommon
//
//  Created by Ben on 2017/7/6.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import "BNPopoverBaseLayout.h"
#import "BNPopoverBottomLayout.h"
#import "BNPopoverCenterLayout.h"
#import "BNPopoverCustomLayout.h"

@implementation BNPopoverBaseLayout

+ (instancetype)popoverLayoutWithPopoverDelegate:(id <BNPopoverLayoutDelegate>)popoverDelegate {
    PopoverLayoutType popoverLayoutType = [popoverDelegate popoverLayoutType];
    Class classToUse = Nil;
    
    switch (popoverLayoutType) {
        case kPopoverLayoutType_Bottom: {
            classToUse = [BNPopoverBottomLayout class];
//            layoutToUse = [[BNPopoverBottomLayout alloc] initWithPopoverDelegate:delegate];
        }
            break;
        case kPopoverLayoutType_Center: {
            classToUse = [BNPopoverCenterLayout class];
//            layoutToUse = [[BNPopoverCenterLayout alloc] initWithPopoverDelegate:delegate];
        }
            break;
        case kPopoverLayoutType_Custom: {
            classToUse = [BNPopoverCustomLayout class];
//            layoutToUse = [[BNPopoverCustomLayout alloc] initWithPopoverDelegate:delegate];
        }
            break;
    }
    
    BNPopoverBaseLayout *layoutToUse = [[classToUse alloc] initWithPopoverDelegate:popoverDelegate];
    
    return layoutToUse;
}

- (instancetype)initWithPopoverDelegate:(id <BNPopoverLayoutDelegate>)popoverDelegate {
    if (self = [super init]) {
        self.popoverDelegate = popoverDelegate;
    }
    
    return self;
}

- (void)preShowLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    NSAssert(NO, @"子类必须重写该方法");
}

- (void)normalLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    NSAssert(NO, @"子类必须重写该方法");
}

- (void)postDismissLayoutForContentView:(UIView *)contentView rootVCView:(UIView *)rootVCView {
    NSAssert(NO, @"子类必须重写该方法");
}

@end


