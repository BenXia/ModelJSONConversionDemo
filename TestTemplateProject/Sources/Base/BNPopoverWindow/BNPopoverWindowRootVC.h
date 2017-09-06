//
//  BNPopoverWindowRootVC.h
//  QQingCommon
//
//  Created by Ben on 2017/7/6.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import "BaseWindowRootVC.h"

@interface BNPopoverWindowRootVC : BaseWindowRootVC

@property (nonatomic, assign) BOOL   backgroundPassThrough;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy)   Block  didClickBackgroundControlBlock;

@property (nonatomic, strong) UIControl *backgroundControl;

@end
