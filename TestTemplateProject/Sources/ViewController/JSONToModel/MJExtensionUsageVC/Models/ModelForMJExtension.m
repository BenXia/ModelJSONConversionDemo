//
//  ModelForMJExtension.m
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ModelForMJExtension.h"

#pragma mark -

/**
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 */

@implementation MJExtensionPhone

MJExtensionCodingImplementation

@end

@implementation MJExtensionBook

MJExtensionCodingImplementation

@end

@implementation MJExtensionUser

MJExtensionCodingImplementation

// 这个数组中的属性名将会被忽略：不进行归档
//+ (NSArray *)mj_ignoredCodingPropertyNames {
//    return @[@"xxxx"];
//}
//
// 和上面的等效
//[MJExtensionUser mj_setupIgnoredCodingPropertyNames:^NSArray *{
//    return @[@"xxxx"];
//}];

//+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
//    if ([propertyName isEqualToString:@"loginDate"]) {
//        return [propertyName mj_underlineFromCamel];
//    }
//    
//    return propertyName;
//}
//
// 上面的等价于:
//[MJExtensionUser mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//    return @{@"loginDate" : @"login_date"};
//}];

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"name"]) {
        if (oldValue == nil) return @"";
        if (oldValue == [NSNull null]) return @"";
    } else if (property.type.typeClass == [NSDate class]) {
        NSTimeInterval timeInterval = [oldValue doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return date;
    }
    
    return oldValue;
}

@end

#pragma mark -

/**
 *  7.继承情况下多态的支持                                 ✘
 */

@implementation MJExtensionMessage

//+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
//    if ([propertyName isEqualToString:@"msgId"]) {
//        return @"id";
//    }
//    
//    return propertyName;
//}

// 上面的等价于
//[MJExtensionMessage mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//    return @{@"msgId" : @"id"};
//}];

@end

@implementation MJExtensionTextMessage

@end

@implementation MJExtensionPictureMessage

//+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
//    if ([propertyName isEqualToString:@"msgId"]) {
//        return @"id";
//    } else if ([propertyName isEqualToString:@"imageURL"]) {
//        return @"image_url";
//    }
//
//    return propertyName;
//}

@end

#pragma mark -

/**
 *  9.异常情况: NSString <-> NSNumber                     ✔︎
 *  10.异常情况: NSString <-> NSUInteger                  ✔︎
 *  11.异常情况: NSArray <-> NSString                     ✘
 */

@implementation MJExtensionPerson

@end


