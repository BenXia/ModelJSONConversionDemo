//
//  ModelForJSONModel.m
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ModelForJSONModel.h"

#pragma mark -

/**
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 */

@implementation JSONModelBook
// 前面是服务器字段，后面是模型属性字段
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"name" : @"name"
                                                       }];
}
@end

@implementation JSONModelPhone
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"name" : @"name",
                                                       @"price" : @"price"
                                                       }];
}
@end

@implementation JSONModelUser
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"name" : @"name",
                                                       @"age" : @"age",
                                                       @"sex" : @"sex",
                                                       @"login_date" : @"loginDate",
                                                       @"phone" : @"phone",
                                                       @"books" : @"books"
                                                       }];
}

// 允许所有字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

// 最后校验，若不通过，则转为 Model 的时候，返回 nil
//- (BOOL)validate:(NSError *__autoreleasing *)error {
//    BOOL valid = [super validate:error];
//    
//    if (self.name.length == 0) {
//        *error = [NSError errorWithDomain:@"NameShouldNotBeEmpty" code:1 userInfo:nil];
//        valid = NO;
//    }
//    
//    return valid;
//}

- (void)setLoginDateWithNSString:(NSString *)string {
    self.loginDate = [NSDate dateWithTimeIntervalSince1970:string.doubleValue];
}

- (NSString *)JSONObjectForLoginDate {
    return [NSString stringWithFormat:@"%lld", (long long)[self.loginDate timeIntervalSince1970]];
}

@end

//@implementation JSONValueTransformer (CustomTransformer)
//
////时间戳转NSDate
//- (nullable NSDate *)NSDateFromNSString:(nullable NSString *)string {
//    return [NSDate dateWithTimeIntervalSince1970:string.doubleValue];
//}
//
////NSDate转时间戳
//- (nullable NSString *)JSONObjectFromNSDate:(nullable NSDate *)date {
//    return [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
//}
//
//@end

#pragma mark -

/**
 *  7.继承情况下多态的支持                                 ✘
 */

@implementation JSONModelMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"msgId" : @"id"};
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"msgId",
                                                       }];
}

// 允许所有字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation JSONModelTextMessage

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"msgId",
                                                       @"body" : @"body"
                                                       }];
}

// 允许所有字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation JSONModelPictureMessage

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"msgId",
                                                       @"image_url" : @"imageURL"
                                                       }];
}

// 允许所有字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

#pragma mark -

/**
 *  9.异常情况: NSString <-> NSNumber                     ✔︎
 *  10.异常情况: NSString <-> NSUInteger                  ✘(crash)
 *  11.异常情况: NSArray <-> NSString                     ✘
 */

@implementation JSONModelPerson

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"age" : @"age",
                                                       @"sex" : @"sex",
                                                       @"name" : @"name"
                                                       }];
}

// 允许所有字段为空
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end



