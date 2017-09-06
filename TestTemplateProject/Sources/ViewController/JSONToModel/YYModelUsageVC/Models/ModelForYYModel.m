//
//  ModelForYYModel.m
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import "ModelForYYModel.h"

#pragma mark -

/**
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 */

@implementation YYModelPhone

// Coding/Copying/hash/equal/description 的支持
// 直接添加以下代码即可自动完成

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end

@implementation YYModelBook

// Coding/Copying/hash/equal/description 的支持
// 直接添加以下代码即可自动完成

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end

@implementation YYModelUser

//// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"test1", @"test2"];
//}
//// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"name"];
//}

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"loginDate" : @"login_date"};
    
//    // 更多用法
//    return @{@"name" : @"n",
//             @"page" : @"p",
//             @"desc" : @"ext.desc",
//             @"bookID" : @[@"id",@"ID",@"book_id"]};
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books" : @"MJExtensionBook"};
    
    // 更多用法
//    return @{@"shadows" : [Shadow class],
//             @"borders" : Border.class,
//             @"attachments" : @"Attachment" };
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *timestamp = dic[@"login_date"];
    if (![timestamp isKindOfClass:[NSNumber class]] && ![timestamp isKindOfClass:[NSString class]]) return NO;
    _loginDate = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
    return YES;
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!_loginDate) return NO;
    dic[@"login_date"] = [NSString stringWithFormat:@"%lld", (long long)[self.loginDate timeIntervalSince1970]];
    return YES;
}

// Coding/Copying/hash/equal/description 的支持
// 直接添加以下代码即可自动完成

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end

#pragma mark -

/**
 *  7.继承情况下多态的支持                                 ✔︎
 */

@implementation YYModelMessage

+ (Class)modelCustomClassForDictionary:(NSDictionary*)dictionary {
    if (dictionary[@"image_url"] != nil) {
        return YYModelPictureMessage.class;
    }
    
    if (dictionary[@"body"] != nil) {
        return YYModelTextMessage.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", dictionary);
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"msgId" : @"id"};
    
//    // 更多用法
//    return @{@"name" : @"n",
//             @"page" : @"p",
//             @"desc" : @"ext.desc",
//             @"bookID" : @[@"id",@"ID",@"book_id"]};
}

@end

@implementation YYModelTextMessage

@end

@implementation YYModelPictureMessage

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"msgId" : @"id",
             @"imageURL" : @"image_url"};
}

@end

#pragma mark -

/**
 *  9.异常情况: NSString <-> NSNumber                     ✔︎
 *  10.异常情况: NSString <-> NSUInteger                  ✔︎
 *  11.异常情况: NSArray <-> NSString                     ✘
 */

// 支持的自动转换
//JSON/Dictionary	                  Model
//
//NSString	                 NSNumber,NSURL,SEL,Class
//
//NSNumber	                        NSString
//
//NSString/NSNumber	       基础类型 (BOOL,int,float,NSUInteger,UInt64,...)
//                             NaN 和 Inf 会被忽略
//
//NSString	                   NSDate 以下列格式解析:
//                                yyyy-MM-dd
//                                yyyy-MM-dd HH:mm:ss
//                                yyyy-MM-dd'T'HH:mm:ss
//                                yyyy-MM-dd'T'HH:mm:ssZ
//                                EEE MMM dd HH:mm:ss Z yyyy
//
//NSDate	                   NSString 格式化为 ISO8601:
//                              "YYYY-MM-dd'T'HH:mm:ssZ"
//
//NSValue	                   struct (CGRect,CGSize,...)
//
//NSNull	                          nil,0
//
//"no","false",...	                 @(NO),0
//
//"yes","true",...	                 @(YES),1

@implementation YYModelPerson

@end


