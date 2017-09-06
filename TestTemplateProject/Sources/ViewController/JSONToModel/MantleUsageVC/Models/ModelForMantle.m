//
//  ModelForMantle.m
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ModelForMantle.h"

#pragma mark -

/**
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 */

@implementation MantlePhone

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name",
             @"price" : @"price"};
}

@end

@implementation MantleBook

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name"};
}

@end

@implementation MantleUser

// 该map不光是JSON->Model, Model->JSON也会用到
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"name" : @"name",
             @"age" : @"age",
             @"sex" : @"sex",
             @"loginDate" : @"login_date",
             @"phone" : @"phone",
             @"books" : @"books",
             @"notExistFieldOne" : @"notExistFieldOne"};
}

// 模型里面的模型
+ (NSValueTransformer *)phoneJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MantlePhone class]];
}

// 模型里面的数组
+ (NSValueTransformer *)booksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MantleBook class]];
}

// 时间
+ (NSValueTransformer *)loginDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *timeIntervalSince1970, BOOL *success, NSError *__autoreleasing *error) {
        NSTimeInterval timeInterval = [timeIntervalSince1970 doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return date;
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        NSTimeInterval timeInterval = date.timeIntervalSince1970;
        return @(timeInterval).stringValue;
    }];
}

@end

#pragma mark -

/**
 *  7.继承情况下多态的支持                                 ✔︎
 */

@implementation MantleMessage

+ (Class _Nullable)classForParsingJSONDictionary:(NSDictionary *_Nullable)JSONDictionary {
    if (JSONDictionary[@"image_url"] != nil) {
        return MantlePictureMessage.class;
    }
    
    if (JSONDictionary[@"body"] != nil) {
        return MantleTextMessage.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"msgId" : @"id"};
}

@end

@implementation MantleTextMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [mdict addEntriesFromDictionary:@{@"body" : @"body"}];
    
    return mdict;
}

@end

@implementation MantlePictureMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:[super JSONKeyPathsByPropertyKey]];
    [mdict addEntriesFromDictionary:@{@"imageURL" : @"image_url"}];
    
    return mdict;
}

@end

#pragma mark -

/**
 *  9.异常情况: NSString <-> NSNumber                     ✘
 *  10.异常情况: NSString <-> NSUInteger                  ✘
 *  11.异常情况: NSArray <-> NSString                     ✘
 */

@implementation MantlePerson

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"age" : @"age",
             @"sex" : @"sex",
             @"name" : @"name"};
}

@end


