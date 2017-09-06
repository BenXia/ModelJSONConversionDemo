//
//  ModelForMJExtension.h
//  TestTemplateProject
//
//  Created by Ben on 2017/8/27.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

/**
 *  1.[NSNull null]                                   　✔︎
 *  2.嵌套Model                                  　      ✔︎
 *  3.NSArray中为Model                                  ✔︎
 *  4.字段需要换转处理                                  　 ✔︎
 *  5.字段 JSON 中没有                                   ✔︎
 *  6.未知字段(向后兼容）                                  ✔︎
 */

typedef NS_ENUM(NSUInteger, Sex) {
    SexMale,
    SexFemale
};

@interface MJExtensionBook : NSObject

@property (nonatomic, copy, nullable) NSString *name;

@end

@interface MJExtensionPhone : NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, assign) double price;

@end

@interface MJExtensionUser : NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) Sex sex;
@property (nonatomic, strong, nullable) NSDate *loginDate;
@property (nonatomic, strong, nullable) MJExtensionPhone *phone;
@property (nonatomic, copy, nullable) NSArray<MJExtensionBook *> *books;

@property (nonatomic, copy, nullable) NSString *notExistFieldOne;
@property (nonatomic, copy, nullable) NSString *notExistFieldTwo;

@end

#pragma mark -

/**
 *  7.继承情况下多态的支持                                 ✘
 */

@interface MJExtensionMessage : NSObject

@property (nonatomic, assign) NSUInteger msgId;

@end

@interface MJExtensionTextMessage: MJExtensionMessage

@property (nonatomic, copy, nullable) NSString *body;

@end

@interface MJExtensionPictureMessage : MJExtensionMessage

@property (nonatomic, strong, nullable) NSURL *imageURL;

@end

#pragma mark -

/**
 *  9.异常情况: NSString <-> NSNumber                     ✔︎
 *  10.异常情况: NSString <-> NSUInteger                  ✔︎
 *  11.异常情况: NSArray <-> NSString                     ✘
 */

@interface MJExtensionPerson : NSObject

@property (nonatomic, strong, nullable) NSNumber *age;
@property (nonatomic, assign) NSUInteger sex;
@property (nonatomic, copy, nullable) NSString *name;

@end


