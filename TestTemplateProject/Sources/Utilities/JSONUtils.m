//
//  JSONUtils.m
//  TestTemplateProject
//
//  Created by Ben on 2017/9/5.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "JSONUtils.h"

@implementation JSONUtils

+ (id)getJSONObjectWithJSONFileName:(NSString *)JSONFileName {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:JSONFileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    id content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return content;
}

+ (id)getJSONStringWithJSONFileName:(NSString *)JSONFileName {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:JSONFileName ofType:@"json"];
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    return jsonString;
}

@end


