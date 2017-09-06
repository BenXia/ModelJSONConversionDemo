//
//  JSONUtils.h
//  TestTemplateProject
//
//  Created by Ben on 2017/9/5.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONUtils : NSObject

+ (id)getJSONObjectWithJSONFileName:(NSString *)JSONFileName;
+ (id)getJSONStringWithJSONFileName:(NSString *)JSONFileName;

@end


